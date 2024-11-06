import 'package:evochurch/src/model/fund_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FinanceViewModel extends ChangeNotifier {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

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

  set fundsList(List<FundModel> value) {
    _fundsList = value;
    notifyListeners();
  }

  // Methods
  Stream<Map<String, dynamic>> getFundList() {
    // Initialize Supabase client
    final client = Supabase.instance.client;

    try {
      final response = client.rpc('spgetfunds').asStream().map((list) {
        final FundsModel fundList = FundsModel.fromJson(list);

        return {
          'success': fundList.success,
          'status_code': fundList.statusCode,
          'message': fundList.message,
          'member_list': fundList.fund
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

  // Add Method
  Future<void> addFund(FundModel fund) async {
    try {
      // 1. Convert the FundModel to a Map
      final fundMap = fund.toMap();

      // 2. Insert the data into the 'Funds' table in Supabase
      await _supabaseClient.from('Funds').insert(fundMap);

      // 3. (Optional) Update the local fundsList
      _fundsList.add(fund);
      notifyListeners();

      debugPrint('Fund added successfully!');
    } catch (e) {
      debugPrint('Error adding fund: $e');
      // Handle the error appropriately, e.g., show an error message to the user
      throw Exception('Failed to add fund: $e');
    }
  }
}
