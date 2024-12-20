import 'package:evochurch/src/model/expense_type_model.dart';
import 'package:evochurch/src/view_model/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExpensesTypeViewModel extends ChangeNotifier {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final AuthServices _authServices = AuthServices();

  List<ExpensesTypeModel> _expensesTypeList = [];
  ExpensesTypeModel? _selectedExpensesType;

  // Getters
  List<ExpensesTypeModel> get expensesTypeList => _expensesTypeList;
  ExpensesTypeModel? get selectedExpensesType => _selectedExpensesType;

  // Setters
  set selectedExpensesType(ExpensesTypeModel? value) {
    _selectedExpensesType = value;
    notifyListeners();
  }

  set setExpensesTypeList(List<ExpensesTypeModel> value) {
    _expensesTypeList = value;
    notifyListeners();
  }

  // Get Expenses Type List Stream Method
  Stream<Map<String, dynamic>> getExpensesTypeList() {
    try {
      final response = _supabaseClient
          .rpc('spgetexpensestypes', params: {'p_church_id': _authServices.userMetaData!['church_id']})
          .asStream()
          .map((list) {
            final ExpensesTypeResponse expensesTypeResponse = ExpensesTypeResponse.fromJson(list);
            setExpensesTypeList = expensesTypeResponse.expenseTypes;
            return {
              'success': expensesTypeResponse.success,
              'status_code': expensesTypeResponse.statusCode,
              'message': expensesTypeResponse.message,
              'expenses_type_list': expensesTypeResponse.expenseTypes
            };
          })
          .handleError((error) {
            debugPrint('Error in stream: $error');
            throw Exception('Failed to load expenses types: $error');
          });
      return response;
    } catch (error) {
      debugPrint('Error creating stream: $error');
      return Stream.error(Exception('Failed to load expenses types: $error'));
    }
  }

  // Refresh Expenses Types
  Future<void> refreshExpensesTypes() async {
    try {
      final response = await _supabaseClient.rpc('spgetexpensestypes', params: {'p_church_id': _authServices.userMetaData!['church_id']});
      final ExpensesTypeResponse expensesTypeResponse = ExpensesTypeResponse.fromJson(response);
      setExpensesTypeList = expensesTypeResponse.expenseTypes;
      notifyListeners();
    } catch (error) {
      debugPrint('Error refreshing expenses types: $error');
      throw Exception('Failed to refresh expenses types: $error');
    }
  }

  // Add Expenses Type
  Future<Map<String, dynamic>> addExpensesType(
      ExpensesTypeModel expensesType) async {
    Map<String, dynamic> response = {};
    try {
      // Convert the ExpensesType to a Map
      final expensesTypeMap = expensesType.toMap();

      // Insert the data into the 'expenses_type' table
      final data = await _supabaseClient
          .from('expenses_type')
          .insert(expensesTypeMap)
          .select();

      // Update the local list
      _expensesTypeList.add(expensesType);
      notifyListeners();

      // Refresh the list after adding
      await refreshExpensesTypes();

      return response = {
        'status': 'Success',
        'message': 'Expenses type added successfully',
        'expenses_type_id': data[0]['expenses_type_id'],
      };
    } catch (e) {
      debugPrint('Error adding expenses type: $e');
      return response = {
        'status': 'Error',
        'message': 'Failed to add expenses type: $e',
        'expenses_type_id': null,
      };
    }
  }

  // Delete Expenses Type
  Future<void> deleteExpensesType(int expensesTypeId) async {
    try {
      // Delete from the 'expenses_type' table
      await _supabaseClient
          .from('expenses_type')
          .delete()
          .eq('expenses_type_id', expensesTypeId);

      // Refresh the list after deleting
      await refreshExpensesTypes();
    } catch (error) {
      debugPrint('Error deleting expenses type: $error');
      throw Exception('Failed to delete expenses type: $error');
    }
  }

  // Update Expenses Type
  Future<Map<String, dynamic>> updateExpensesType(ExpensesTypeModel expensesType) async {
    Map<String, dynamic> response = {};
    try {
      // Convert the ExpensesType to a Map
      final expensesTypeMap = expensesType.toMap();

      // Update the data in the 'expenses_type' table
      await _supabaseClient
          .from('expenses_type')
          .update(expensesTypeMap)
          .eq('expenses_type_id', expensesType.expensesTypeId!);

      // Refresh the list after updating
      await refreshExpensesTypes();

      return response = {
        'status': 'Success',
        'message': 'Expenses type updated successfully',
        'expenses_type_id': expensesType.expensesTypeId,
      };
    } catch (e) {
      debugPrint('Error updating expenses type: $e');
      return response = {
        'status': 'Error',
        'message': 'Failed to update expenses type: $e',
        'expenses_type_id': null,
      };
    }
  }
}
