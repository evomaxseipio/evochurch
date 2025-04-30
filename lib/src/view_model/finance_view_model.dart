import 'dart:async';

import 'package:evochurch/src/data/remote/response/api_response.dart';
import 'package:evochurch/src/model/transaction_with_header__details_model.dart';
import 'package:evochurch/src/model/fund_model.dart';
import 'package:evochurch/src/model/transaction_model.dart';
import 'package:evochurch/src/repository/finances/finance_repo_imp.dart';
import 'package:evochurch/src/view_model/auth_services.dart';
import 'package:evochurch/src/view_model/index_view_model.dart';
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
  List<TransactionModel> _transactionsListByFund = [];
  HeaderDetails? _headerDetails;
  FundModel? _selectedFund;
  TransactionModel? _selectedTransaction;
  Map<String, dynamic> _churchFinances = {};

 

  // Loading states
  bool _isLoadingFunds = false;
  bool _isLoadingTransactions = false;
  String? _error;

  // Setters
  set setFundSelected(FundModel? value) {
    _selectedFund = value;
    notifyListeners();
  }

  set setTransactionSelected(TransactionModel? value) {
    _selectedTransaction = value;
    notifyListeners();
  }

  set setFundsList(List<FundModel> value) {
    _fundsList = value;
    notifyListeners();
  }

  // Getters
  List<FundModel> get fundsList => _fundsList;
  List<TransactionModel> get transactionsList => _transactionsList;
  HeaderDetails? get headerDetails => _headerDetails;
  List<TransactionModel> get transactionsListByFund => _transactionsListByFund;
  FundModel? get selectedFund => _selectedFund;
  TransactionModel? get selectedTransaction => _selectedTransaction;
  bool get isLoadingFunds => _isLoadingFunds;
  bool get isLoadingTransactions => _isLoadingTransactions;
  String? get error => _error;
  late int churchId;   
  Map<String, dynamic> get churchFinances => _churchFinances;
 

  final _fundStreamController = StreamController<void>.broadcast();
  Stream<void> get fundStreamController => _fundStreamController.stream;

  final StreamController<void> _transactionStreamController =
      StreamController<void>.broadcast();
  Stream<void> get transactionStreamController =>
      _transactionStreamController.stream;

  final _churchFinancesStreamController = StreamController<void>.broadcast();
  Stream<void> get onChurchFinancesChanged =>
      _churchFinancesStreamController.stream;

  FinanceViewModel() {
    churchId = int.parse(_authServices.userMetaData!['church_id']);
    _selectedFund = null;
    _selectedTransaction = null;
    _loadFunds();
    getTransactionList(null);
  }

  void notifyDataChanged() {
    _fundStreamController.add(null);
    _transactionStreamController.add(null);
    notifyListeners();
  }

    void notifyChurchFinancesChanged() {
    _churchFinancesStreamController.add(null);
    notifyListeners();
  }

  @override
  void dispose() {
    _fundStreamController.close();
    _transactionStreamController.close();
    _fundListSubscription?.cancel();
    _transactionListSubscription?.cancel();
    _churchFinancesStreamController.close();
    super.dispose();
  }

  // Transactions Management
  // void _loadTransactions({String? fundId}) {
  //   _isLoadingTransactions = true;
  //   _error = null;
  //   notifyListeners();

  //   _transactionListSubscription?.cancel();
  //   _transactionListSubscription = getTransactionList(fundId).listen(
  //     (response) {
  //       _transactionsList =
  //           response['transaction_list'] as List<TransactionModel>;
  //       _headerDetails = response['header_details'];
  //       _isLoadingTransactions = false;
  //       notifyListeners();
  //     },
  //     onError: (error) {
  //       _error = error.toString();
  //       _isLoadingTransactions = false;
  //       notifyListeners();
  //     },
  //   );
  // }

  // Get Transactions by Fund
  void loadTransactionsByFund(String? fundId) {
    getTransactionList(fundId);
  }

  // Funds Management
  void _loadFunds() {
    _error = null;
    notifyListeners();
    getFundList();
  }

  // Get fund primary data
  Future<FundModel> getFundPrimaryData() async {
    try {
      final data = await _supabaseClient
          .from('funds')
          .select()
          .eq('is_primary', true)
          .eq('church_id', churchId)
          .single();
      return FundModel.fromMap(data);
    } catch (e) {
      print(e);
      throw Exception('Failed to load fund primary data: $e');
    }
  }

  // Get Funds transaction Details
  Stream<Map<String, dynamic>> getFundsTransactionDetails(String fundId) {
    try {
      final churchId = int.parse(_authServices.userMetaData!['church_id']);
      return _supabaseClient
          .rpc(
            'sp_get_fund_transactions_list',
            params: {'p_church_id': churchId, 'p_fund_id': fundId},
          )
          .asStream()
          .map((list) {
            final fundTransactionDetails =
                TransactionWithHeaderDetailsModel.fromJson(list);

            if (!fundTransactionDetails.success) {
              return {
                'success': fundTransactionDetails.success,
                'status_code': fundTransactionDetails.statusCode,
                'message': fundTransactionDetails.message,
              };
            }

            _transactionsListByFund = fundTransactionDetails.transactionModel;
            notifyListeners();

            return {
              'success': fundTransactionDetails.success,
              'status_code': fundTransactionDetails.statusCode,
              'message': fundTransactionDetails.message,
              'header_details': fundTransactionDetails.headerDetails,
              'transaction_list': fundTransactionDetails.transactionModel,
            };
          })
          .handleError((error) {
            debugPrint('Error in fund transaction details stream: $error');
            throw Exception('Failed to load fund transaction details: $error');
          });
    } catch (error) {
      debugPrint('Error creating fund transaction details stream: $error');
      return Stream.error(
          Exception('Failed to load fund transaction details: $error'));
    }
  }

  // Get Transaction List
  Future<Map<String, dynamic>> getTransactionList(String? fundId) async {
    try {
      _isLoadingTransactions = true;
      notifyListeners();

      final transactonData = await _supabaseClient.rpc(
        'sp_get_transaction_list',
        params: {'p_church_id': churchId, 'p_fund_id': fundId},
      ).timeout(const Duration(seconds: 30)); // Add timeout to prevent hanging

      // Validate the response
      if (transactonData == null || transactonData.isEmpty) {
        _isLoadingTransactions = false;
        notifyListeners();
        return {
          'success': false,
          'status_code': 404,
          'message': 'No funds found',
          'fund_list': [],
        };
      }

      // Parse the response
      final transactionList =
          TransactionWithHeaderDetailsModel.fromJson(transactonData);
      _transactionsList = transactionList.transactionModel;
      _headerDetails = transactionList.headerDetails;
      _isLoadingTransactions = false;
      notifyListeners();

      return {
        'success': transactionList.success,
        'status_code': transactionList.statusCode,
        'message': transactionList.message,
        'header_details': transactionList.headerDetails,
        'transaction_list': transactionList.transactionModel,
      };
    } on PostgrestException catch (error) {
      // PostgresErrorHandler.showErrorDialog(context, error);
      _isLoadingFunds = false;
      notifyListeners();
      final errorResponse = PostgresErrorHandler.handleError(error);
      return {
        'success': false,
        'status_code': 404,
        'message': errorResponse.message,
        'transaction_list': [],
      };
    } on TimeoutException {
      _isLoadingFunds = false;
      notifyListeners();
      debugPrint('Fund list request timed out');
      return {
        'success': false,
        'status_code': 408,
        'message': 'Request timed out',
        'fund_list': [],
      };
    } on Exception catch (error) {
      _isLoadingFunds = false;
      notifyListeners();
      debugPrint('Failed to load funds: $error');
      return {
        'success': false,
        'status_code': 500,
        'message': 'Failed to load funds: ${error.toString()}',
        'fund_list': [],
      };
    }
  }

  Stream<Map<String, dynamic>> getTransactionListOld(String? fundId) {
    try {
      return _supabaseClient
          .rpc(
            'sp_get_transaction_list',
            params: {
              'p_church_id': _authServices.userMetaData!['church_id'],
              'p_fund_id': fundId
            },
          )
          .asStream()
          .map((list) {
            final transactionList =
                TransactionWithHeaderDetailsModel.fromJson(list);
            return {
              'success': transactionList.success,
              'status_code': transactionList.statusCode,
              'message': transactionList.message,
              'header_details': transactionList.headerDetails,
              'transaction_list': transactionList.transactionModel,
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

  // Get Contributions List
   Future<Map<String, dynamic>> getFinancialByChurch() async {
    try {
      _isLoadingFunds = true;
      notifyListeners();
      // Call Supabase RPC
      final response = await _supabaseClient.rpc(
        'sp_get_collection_by_church',
        params: {
          'p_church_id': churchId,
          
        },
      );

      // Validate response
      if (response == null || response.isEmpty) {
        throw FinancialDataException(
            'No financial data found for the given Church.');
      }

      _churchFinances = response;
      notifyListeners();

      return response;
    } on PostgrestException catch (error) {
      // PostgresErrorHandler.showErrorDialog(context, error);
      _isLoadingFunds = false;
      notifyListeners();
      final errorResponse = PostgresErrorHandler.handleError(error);
      return {
        'success': false,
        'status_code': 404,
        'message': errorResponse.message,
        'transaction_list': [],
      };
    } on TimeoutException {
      _isLoadingFunds = false;
      notifyListeners();
      debugPrint('Contributions list request timed out');
      return {
        'success': false,
        'status_code': 408,
        'message': 'Request timed out',
        'fund_list': [],
      };
    } on Exception catch (error) {
      _isLoadingFunds = false;
      notifyListeners();
      debugPrint('Failed to load Contributions: $error');
      return {
        'success': false,
        'status_code': 500,
        'message': 'Failed to load Contributions: ${error.toString()}',
        'fund_list': [],
      };
    }
  }

  // Get Contributions List
  Future<Map<String, dynamic>> getFinancialByChurchAndFund(String fundId) async {
    try {
      _isLoadingFunds = true;
      notifyListeners();
      // Call Supabase RPC
      final response = await _supabaseClient.rpc(
        'sp_get_collection_by_fund',
        params: {
          'p_church_id': churchId,
          'p_fund_id': fundId,
        },
      );

      // Validate response
      if (response == null || response.isEmpty) {
        throw FinancialDataException(
            'No financial data found for the given Church.');
      }

      _churchFinances = response;
      notifyListeners();

      return response;
    } on PostgrestException catch (error) {
      // PostgresErrorHandler.showErrorDialog(context, error);
      _isLoadingFunds = false;
      notifyListeners();
      final errorResponse = PostgresErrorHandler.handleError(error);
      return {
        'success': false,
        'status_code': 404,
        'message': errorResponse.message,
        'transaction_list': [],
      };
    } on TimeoutException {
      _isLoadingFunds = false;
      notifyListeners();
      debugPrint('Contributions list request timed out');
      return {
        'success': false,
        'status_code': 408,
        'message': 'Request timed out',
        'fund_list': [],
      };
    } on Exception catch (error) {
      _isLoadingFunds = false;
      notifyListeners();
      debugPrint('Failed to load Contributions: $error');
      return {
        'success': false,
        'status_code': 500,
        'message': 'Failed to load Contributions: ${error.toString()}',
        'fund_list': [],
      };
    }
  }








  Future<Map<String, dynamic>> getFundList() async {
    try {
      final fundsData = await _supabaseClient.rpc(
        'spgetfunds',
        params: {'p_church_id': _authServices.userMetaData!['church_id']},
      ).timeout(const Duration(seconds: 30)); // Add timeout to prevent hanging

      // Validate the response
      if (fundsData == null || fundsData.isEmpty) {
        return {
          'success': false,
          'status_code': 404,
          'message': 'No funds found',
          'fund_list': [],
        };
      }

      // Parse the response
      final fundList = FundsModel.fromJson(fundsData);

      // Update local state
      _fundsList = fundList.fund;

      // Notify listeners and stream controller
      notifyListeners();

      return {
        'success': fundList.success,
        'status_code': fundList.statusCode,
        'message': fundList.message,
        'fund_list': fundList.fund,
      };
    } on TimeoutException {
      debugPrint('Fund list request timed out');
      return {
        'success': false,
        'status_code': 408,
        'message': 'Request timed out',
        'fund_list': [],
      };
    } on Exception catch (error) {
      debugPrint('Failed to load funds: $error');
      return {
        'success': false,
        'status_code': 500,
        'message': 'Failed to load funds: ${error.toString()}',
        'fund_list': [],
      };
    }
  }

  // Add Fund Model
  Future<Map<String, dynamic>> addFund(FundModel fund) async {
    try {
      final fundMap = fund.toMap();
      final data = await _supabaseClient.from('funds').insert(fundMap).select();
      await getFundList();

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

  // Update Fund Model
  Future<Map<String, dynamic>> updateFund(FundModel fund) async {
    try {
      final fundMap = fund.toMap();
      await _supabaseClient
          .from('funds')
          .update(fundMap)
          .eq('fund_id', fund.fundId);

      // update total contribution in the fund
      await _supabaseClient.from('funds').update({
        'total_contributions': await Supabase.instance.client
            .from('collections')
            .select('collection_amount')
            .eq('fund_id', fund.fundId)
            .then((response) {
          if (response.isEmpty) return 0;
          return response.fold<double>(
              0,
              (sum, item) =>
                  sum + (item['collection_amount'] as num).toDouble());
        }),
      }).eq('fund_id', fund.fundId);

      await getFundList();

      return {
        'status': 'Success',
        'message': 'Fund updated successfully',
        'fund_id': fund.fundId,
      };
    } on PostgrestException catch (error) {
      // PostgresErrorHandler.showErrorDialog(context, error);
      final errorResponse = PostgresErrorHandler.handleError(error);
      return {
        'status': 'Error',
        'message': errorResponse.message,
        // 'transaction_id': null,
      };
      // PostgresErrorHandler.logError(error, stackTrace);
    } catch (e) {
      debugPrint('Error updating fund: $e');
      return {
        'status': 'Error',
        'message': 'Failed to update fund: $e',
        'fund_id': null,
      };
    }
  }

  Future<void> deleteFund(String fundId) async {
    try {
      await _supabaseClient.from('funds').delete().eq('fund_id', fundId);
      await getFundList();
    } catch (error) {
      debugPrint('Error deleting fund: $error');
      throw Exception('Failed to delete fund: $error');
    }
  }

  // Set Primary Fund
  Future<Map<String, dynamic>> setPrimaryFund(String fundId) async {
    try {
      final response = await _supabaseClient.rpc(
        'sp_change_primary_fund',
        params: {
          'p_fund_id': fundId,
          'p_church_id': churchId,
        },
      );

      // Update local state
      await getFundList();

      return {
        'success': response['success'],
        'status_code': response['status_code'],
        'message': response['message'],
      };
    } on PostgrestException catch (error) {
      // PostgresErrorHandler.showErrorDialog(context, error);
      final errorResponse = PostgresErrorHandler.handleError(error);
      return {
        'success': false,
        'status_code': 500,
        'message': errorResponse.message,
      };
      // PostgresErrorHandler.logError(error, stackTrace);
    } catch (e) {
      debugPrint('Error setting primary fund: $e');
      return {
        'success': false,
        'status_code': 500,
        'message': 'Failed to set primary fund: $e',
      };
    }
  }

  /*Stream<Map<String, dynamic>> getTransactionList() {
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
              'header_details': transactionList.headerDetails,
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
  }*/

  Future<void> refreshTransactionsByFund(String fundId) async {
    loadTransactionsByFund(fundId);
  }

  Future<Map<String, dynamic>> addTransaction(
      Map<String, dynamic> transaction, String userId) async {
    try {
      final churchId = int.parse(_authServices.userMetaData!['church_id']);
      final data = await _supabaseClient.rpc('fn_create_transaction', params: {
        'p_church_id': churchId,
        'p_expenses_type_id': transaction['expenses_type_id'],
        'p_fund_id': transaction['fund_id'],
        'p_created_by_profile_id': userId,
        'p_transaction_amount': transaction['transaction_amount'],
        'p_description': transaction['transaction_description'],
        'p_payment_method': transaction['payment_method']
      });

      await getTransactionList(transaction['fund_id']);

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
  Future<Map<String, dynamic>> updateTransaction(
      Map<String, dynamic> transaction) async {
    try {
      final churchId = int.parse(_authServices.userMetaData!['church_id']);

      // Update the transaction in the database
      await _supabaseClient
          .from('transactions')
          .update({
            'expenses_type_id': transaction['expenses_type_id'],
            'transaction_amount': transaction['transaction_amount'],
            'transaction_description': transaction['transaction_description'],
            'payment_method': transaction['payment_method'],
          })
          .eq('transaction_id', transaction['transaction_id'])
          .eq('church_id', churchId);

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


  // Authorize transaction
  Future<Map<String, dynamic>> authorizeTransaction(
      Map<String, dynamic> transaction, String userId) async {
    try {
      final churchId = int.parse(_authServices.userMetaData!['church_id']);

      // Authorize the transaction
      // Update the transaction in the database
      final data = await _supabaseClient
          .from('transactions')
          .update({
            'expenses_type_id': transaction['expenses_type_id'],
            'transaction_amount': transaction['transaction_amount'],
            'transaction_description': transaction['transaction_description'],
            'payment_method': transaction['payment_method'],
            'authorized_by_profile_id': userId,
            'authorization_status': 'APPROVED',
            'fund_id': transaction['fund_id'],
          })
          .eq('transaction_id', transaction['transaction_id'])
          .eq('church_id', churchId);


      // // Refresh the transaction list
      // await getTransactionList(null);

      return {
        'status': 'Success',
        'message': 'Transaction authorized successfully',
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
      debugPrint('Error authorizing transaction: $e');
      return {
        'status': 'Error',
        'message': 'Failed to authorize transaction: $e',
        // 'transaction_id': null,
      };
    }
  }




  // Delete Transaction
  Future<void> deleteTransaction(int transactionId) async {
    try {
      await _supabaseClient
          .from('transactions')
          .delete()
          .eq('transaction_id', transactionId);
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
