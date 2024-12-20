import 'package:evochurch/src/model/collection_model_type.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CollectionViewModel extends ChangeNotifier {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  List<Map<String, dynamic>> _collections = [];
  List<Map<String, dynamic>> get collections => _collections;

  List<CollectionType> _collectionTypes = [];
  List<CollectionType> get collectionTypes => _collectionTypes;

  // Constructor
  CollectionViewModel() {
    fetchActiveCollectionTypes();
  }

  Future<void> _fetchCollections() async {
    final response = await _supabaseClient.from('collections').select('*');
    _collections = List<Map<String, dynamic>>.from(response);
    notifyListeners();
  }

  Future<Map<String, dynamic>> createCollection(
      Map<String, dynamic> newCollection) async {
    try {
      newCollection.remove('collection_id');
      final response = await _supabaseClient
          .from('collections')
          .insert(newCollection)
          .select();
      _fetchCollections();
      notifyListeners();
      return {
        "status": "Success",
        "message": "Collection created successfully",
        "collection": response
      };
    } catch (e) {
      return {"status": "Error", "message": "Error creating collection: $e"};
    }
  }

  Future<void> updateCollection(Map<String, dynamic> collection) async {
    await _supabaseClient
        .from('collections')
        .update(collection)
        .eq('collection_id', collection['collection_id']);
    _fetchCollections();
  }

  Future<void> deleteCollection(String collectionId) async {
    await _supabaseClient
        .from('collections')
        .delete()
        .eq('collection_id', collectionId);
    _fetchCollections();
  }

  // Function to fetch active collection types
  Future<List<CollectionType>> fetchActiveCollectionTypes() async {
    try {
      final response = await _supabaseClient
          .from('collection_type')
          .select(
              'collection_type_id, collection_type_name, collection_type_description')
          .eq('collection_type_status', 'active')
          .order('collection_type_name', ascending: true);

      // Check if response contains data and map to CollectionType
      if (response.isEmpty) {
        return [];
      }

      _collectionTypes =
          response.map((json) => CollectionType.fromJson(json)).toList();
      notifyListeners(); // Notify listeners that data has changed
      return _collectionTypes;
    } catch (error) {
      debugPrint('Error fetching collection types: $error');
      throw error;
    }
  }
}
  
  
  // void showEditDialog(Map<String, dynamic> collection) {
  //   _collectionTypeController.text = collection['collection_type'].toString();
  //   _collectionAmountController.text = collection['collection_amount'].toString();
  //   _collactionDateController.text = collection['collaction_date'];
  //   _paymentMethodController.text = collection['payment_method'];
  //   _commentsController.text = collection['comments'];
  //   _isAnonymous = collection['is_anonymous'];
  //   notifyListeners();
  // }

  // void clearForm() {
  //   _collectionTypeController.clear();
  //   _collectionAmountController.clear();
  //   _collactionDateController.clear();
  //   _paymentMethodController.clear();
  //   _commentsController.clear();
  //   _isAnonymous = false;
  //   notifyListeners();
  // }








// // Add new collection
// Future<Map<String, dynamic>> addCollectionType(
//     CollectionType collectionType) async {
//       try {
//         final response = await _supabaseClient
//             .from('collection_type')
//             .insert(collectionType.toJson());
//         return response; 
//       } catch (e) {
//         print(e); 
//       }
//     }
