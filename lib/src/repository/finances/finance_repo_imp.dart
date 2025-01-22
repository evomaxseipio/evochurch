import 'package:evochurch/src/model/fund_model.dart';
import 'package:evochurch/src/model/transaction_model.dart';
import 'package:evochurch/src/view_model/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'finance_repo.dart';

class FinanceRepoImp implements FinanceRepo {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final AuthServices _authServices = AuthServices();

  @override
  Future<List<FundsModel>?> getFundsList() {
    // TODO: Implement getFundsList
    throw UnimplementedError();
  }

  @override
  Future<List<TransactionModel>> getTransactionsList() async {
    try {
      final response = await _supabaseClient.rpc(
        'sp_get_transaction_list',
        params: {'p_church_id': _authServices.userMetaData?['church_id']},
      );

  
      // if (response.error != null) {
      //   debugPrint('Error fetching transactions: ${response.error!.message}');
      //   throw Exception(
      //       'Failed to load transactions: ${response.error!.message}');
      // }

      if (response['success']) {
        TransactionListModel transactionList = TransactionListModel.fromJson(response);
        List<TransactionModel> transactions = transactionList.transactionListModel;
        return transactions;
      } else {
        debugPrint('No data found for transactions');
        return [];
      }
    } catch (error) {
      debugPrint('Error fetching transactions: $error');
      throw Exception('Failed to load transactions: $error');
    }
  }
}
