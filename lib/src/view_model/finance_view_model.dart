import 'package:evochurch/src/model/fund_model.dart';
import 'package:evochurch/src/view_model/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FinanceViewModel extends ChangeNotifier {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final AuthServices _authServices = AuthServices();

  List<FundModel> _fundsList = [];
  FundModel? _selectedFund;

  // Getters
  List<FundModel> get fundsList => _fundsList;
  FundModel? get selectedFund => _selectedFund;

  // Setters
  set selectedFund(FundModel? value) {
    _selectedFund = value;
    notifyListeners();
  }

  set setFundsList(List<FundModel> value) {
    _fundsList = value;
    notifyListeners();
  }

  // Methods
  Stream<Map<String, dynamic>> getFundList() {
    try {
      final response = _supabaseClient.rpc('spgetfunds', params: { 'p_church_id': _authServices.userMetaData!['church_id'] }).asStream().map((list) {
        final FundsModel fundList = FundsModel.fromJson(list);
        setFundsList = fundList.fund;
        return {
          'success': fundList.success,
          'status_code': fundList.statusCode,
          'message': fundList.message,
          'fund_list': fundList.fund
        };
      }).handleError((error) {
        debugPrint('Error in stream: $error'); // Debug log
        throw Exception('Failed to load members: $error');
      });
      return response;
    } catch (error) {
      debugPrint('Error creating stream: $error');
      return Stream.error(Exception('Failed to load members: $error'));
    }
  }



    // Add a method to force refresh the funds list
  Future<void> refreshFunds() async {
    try {
      final response = await _supabaseClient.rpc('spgetfunds', params: { 'p_church_id': _authServices.userMetaData!['church_id'] });
      final FundsModel fundList = FundsModel.fromJson(response);
      setFundsList = fundList.fund;
    } catch (error) {
      debugPrint('Error refreshing funds: $error');
      throw Exception('Failed to refresh funds: $error');
    }
  }




  // Add Method
  Future<Map<String, dynamic>> addFund(FundModel fund) async {
    Map<String, dynamic> response = {};
    try {
      // 1. Convert the FundModel to a Map
      final fundMap = fund.toMap();

      // 2. Insert the data into the 'Funds' table in Supabase
      final data = await _supabaseClient.from('funds').insert(fundMap).select();
      // rpc('spinsertfunds', params: fundMap);

      // 3. (Optional) Update the local fundsList
      _fundsList.add(fund);
      notifyListeners();

      // Refresh the list after adding
      await refreshFunds();

      return response = {
        'status': 'Success',
        'message': 'Fund added successfully',
        'fund_id': data[0]['fund_id'],
      };
    } catch (e) {
      debugPrint('Error adding fund: $e');
      // Handle the error appropriately, e.g., show an error message to the user
      return response = {
        'status': 'Error',
        'message': 'Failed to add fund: $e',
        'fund_id': null,
      };
    }
  }

    // Method to delete a fund
  Future<void> deleteFund(String fundId) async {
    try {
      // Your existing delete fund logic here
      await _supabaseClient.from('funds').delete().eq('fund_id', fundId);
      // rpc('your_delete_fund_procedure', params: {'fund_id': fundId});
      
      // Refresh the list after deleting
      await refreshFunds();
    } catch (error) {
      debugPrint('Error deleting fund: $error');
      throw Exception('Failed to delete fund: $error');
    }
  }

}
