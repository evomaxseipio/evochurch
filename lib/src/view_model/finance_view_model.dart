import 'dart:async';

import 'package:evochurch/src/data/remote/response/api_response.dart';
import 'package:evochurch/src/model/fund_model.dart';
import 'package:evochurch/src/model/transaction_model.dart';
import 'package:evochurch/src/repository/finances/finance_repo_imp.dart';
import 'package:evochurch/src/view_model/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/remote/PostgresErrorHandler.dart';
class FinanceViewModel with ChangeNotifier {
  final _financeRepo = FinanceRepoImp();
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final AuthServices _authServices = AuthServices();

  StreamSubscription? _fundListSubscription;
  StreamSubscription? _transactionListSubscription;

  List<FundModel> _fundsList = [];
  List<TransactionModel> _transactionsList = [];
  FundModel? _selectedFund;
  TransactionModel? _selectedTransaction;

  // Loading states
  bool _isLoadingFunds = false;
  bool _isLoadingTransactions = false;
  String? _error;

  // Getters
  List<FundModel> get fundsList => _fundsList;
  List<TransactionModel> get transactionsList => _transactionsList;
  FundModel? get selectedFund => _selectedFund;
  TransactionModel? get selectedTransaction => _selectedTransaction;
  bool get isLoadingFunds => _isLoadingFunds;
  bool get isLoadingTransactions => _isLoadingTransactions;
  String? get error => _error;

  FinanceViewModel() {
    _initialize();
  }

  void _initialize() {
    _loadFunds();
    _loadTransactions();
  }

  @override
  void dispose() {
    _fundListSubscription?.cancel();
    _transactionListSubscription?.cancel();
    super.dispose();
  }

  // Funds Management
  void _loadFunds() {
    _isLoadingFunds = true;
    _error = null;
    notifyListeners();

    _fundListSubscription?.cancel();
    _fundListSubscription = getFundList().listen(
      (response) {
        _fundsList = response['fund_list'] as List<FundModel>;
        _isLoadingFunds = false;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        _isLoadingFunds = false;
        notifyListeners();
      },
    );
  }

  Stream<Map<String, dynamic>> getFundList() {
    try {
      return _supabaseClient
          .rpc(
            'spgetfunds',
            params: {'p_church_id': _authServices.userMetaData!['church_id']},
          )
          .asStream()
          .map((list) {
            final fundList = FundsModel.fromJson(list);
            return {
              'success': fundList.success,
              'status_code': fundList.statusCode,
              'message': fundList.message,
              'fund_list': fundList.fund,
            };
          })
          .handleError((error) {
            debugPrint('Error in fund stream: $error');
            throw Exception('Failed to load funds: $error');
          });
    } catch (error) {
      debugPrint('Error creating fund stream: $error');
      return Stream.error(Exception('Failed to load funds: $error'));
    }
  }

  Future<void> refreshFunds() async {
    _loadFunds();
  }

  Future<Map<String, dynamic>> addFund(FundModel fund) async {
    try {
      final fundMap = fund.toMap();
      final data = await _supabaseClient.from('funds').insert(fundMap).select();
      await refreshFunds();

      return {
        'status': 'Success',
        'message': 'Fund added successfully',
        'fund_id': data[0]['fund_id'],
      };
    } catch (e) {
      debugPrint('Error adding fund: $e');
      return {
        'status': 'Error',
        'message': 'Failed to add fund: $e',
        'fund_id': null,
      };
    }
  }

  Future<void> deleteFund(String fundId) async {
    try {
      await _supabaseClient.from('funds').delete().eq('fund_id', fundId);
      await refreshFunds();
    } catch (error) {
      debugPrint('Error deleting fund: $error');
      throw Exception('Failed to delete fund: $error');
    }
  }

  // Transactions Management
  void _loadTransactions() {
    _isLoadingTransactions = true;
    _error = null;
    notifyListeners();

    _transactionListSubscription?.cancel();
    _transactionListSubscription = getTransactionList().listen(
      (response) {
        _transactionsList = response['transaction_list'] as List<TransactionModel>;
        _isLoadingTransactions = false;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        _isLoadingTransactions = false;
        notifyListeners();
      },
    );
  }

  Stream<Map<String, dynamic>> getTransactionList() {
    try {
      return _supabaseClient
          .rpc(
            'sp_get_transaction_list',
            params: {'p_church_id': _authServices.userMetaData!['church_id']},
          )
          .asStream()
          .map((list) {
            final transactionList = TransactionListModel.fromJson(list);
            return {
              'success': transactionList.success,
              'status_code': transactionList.statusCode,
              'message': transactionList.message,
              'transaction_list': transactionList.transactionListModel,
            };
          })
          .handleError((error) {
            debugPrint('Error in transaction stream: $error');
            throw Exception('Failed to load transactions: $error');
          });
    } catch (error) {
      debugPrint('Error creating transaction stream: $error');
      return Stream.error(Exception('Failed to load transactions: $error'));
    }
  }

  Future<void> refreshTransactions() async {
    _loadTransactions();
  }

  Future<Map<String, dynamic>> addTransaction(Map<String, dynamic> transaction, int churchId, String userId) async {
    try {
      // final transactionMap = transaction.toMap();
      final data = await _supabaseClient
          .rpc( 'fn_create_transaction', params: {
            'p_church_id':churchId,
            'p_expenses_type_id': transaction['expenses_type_id'],
            'p_fund_id': transaction['fund_id'],
            'p_created_by_profile_id': userId,
            'p_transaction_amount': transaction['transaction_amount'],
            'p_description': transaction['transaction_description'],
            'p_payment_method': transaction['payment_method']
          });

      await refreshTransactions();

      return {
        'status': 'Success',
        'message': 'Transaction added successfully',
        // 'transaction_id': data[0]['transaction_id'],
      };
    } on PostgrestException catch (error, stackTrace) {
      // PostgresErrorHandler.showErrorDialog(context, error);
      final errorResponse = PostgresErrorHandler.handleError(error);
      return {
        'status': 'Error',
        'message': errorResponse.message,
        // 'transaction_id': null,
      };
      // PostgresErrorHandler.logError(error, stackTrace);
     
    } catch (e) {
      debugPrint('Error adding transaction: $e');


      return {
        'status': 'Error',
        'message': 'Failed to add transaction: $e.message',
        // 'transaction_id': null,
      };
    }
  }

  // Update transaction
  Future<Map<String, dynamic>> updateTransaction(Map<String, dynamic> transaction) async {
    try {
      await _supabaseClient.from('transactions').update(transaction).eq('transaction_id', transaction['transaction_id']);
      await refreshTransactions();
      return {
        'status': 'Success',
        'message': 'Transaction updated successfully',
        'transaction_id': transaction['transaction_id'],
      };
    } catch (e) { 
      debugPrint('Error updating transaction: $e');
      return {
        'status': 'Error',
        'message': 'Failed to update transaction: $e',
        'transaction_id': null,
      };
    }
  }



  // Delete Transaction
  Future<void> deleteTransaction(String transactionId) async {
    try {
      await _supabaseClient.from('transactions').delete().eq('transaction_id', transactionId);
      await refreshTransactions();
    } catch (error) {
      debugPrint('Error deleting transaction: $error');
      throw Exception('Failed to delete transaction: $error');
    }
  }

  // Selection methods
  void selectFund(FundModel fund) {
    _selectedFund = fund;
    notifyListeners();
  }

  void selectTransaction(TransactionModel transaction) {
    _selectedTransaction = transaction;
    notifyListeners();
  }
}
