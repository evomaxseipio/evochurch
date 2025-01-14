import 'package:evochurch/src/model/collection_model_type.dart';
import 'package:evochurch/src/model/expense_type_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class CollectionViewModel extends ChangeNotifier {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  // State variables
  List<Map<String, dynamic>> _collections = [];
  List<CollectionType> _collectionTypes = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Map<String, dynamic>> get collections => _collections;
  List<CollectionType> get collectionTypes => _collectionTypes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Constructor
  CollectionViewModel() {
    _initialize();
  }

  void _initialize() {
    fetchActiveCollectionTypes();
    _fetchCollections();
  }

  // Error handling helper
  void _handleError(String operation, dynamic error) {
    final errorMessage = 'Error $operation: $error';
    debugPrint(errorMessage);
    _error = errorMessage;
    _isLoading = false;
    notifyListeners();
  }

  // Collections Management
  Future<void> _fetchCollections() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _supabaseClient.from('collections').select('*');
      _collections = List<Map<String, dynamic>>.from(response);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _handleError('fetching collections', e);
    }
  }

  Future<Map<String, dynamic>> createCollection(
      Map<String, dynamic> newCollection) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Remove collection_id as it's auto-generated
      newCollection.remove('collection_id');

      final response = await _supabaseClient
          .from('collections')
          .insert(newCollection)
          .select();

      await _fetchCollections();

      return {
        "status": "Success",
        "message": "Collection created successfully",
        "collection": response
      };
    } catch (e) {
      _handleError('creating collection', e);
      return {"status": "Error", "message": "Error creating collection: $e"};
    }
  }

  Future<void> updateCollection(Map<String, dynamic> collection) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _supabaseClient
          .from('collections')
          .update(collection)
          .eq('collection_id', collection['collection_id']);

      await _fetchCollections();
    } catch (e) {
      _handleError('updating collection', e);
    }
  }

  Future<void> deleteCollection(String collectionId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _supabaseClient
          .from('collections')
          .delete()
          .eq('collection_id', collectionId);

      await _fetchCollections();
    } catch (e) {
      _handleError('deleting collection', e);
    }
  }

  // Collection Types Management
  Future<List<CollectionType>> fetchActiveCollectionTypes() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _supabaseClient
          .from('collection_type')
          .select('''
            collection_type_id,
            collection_type_name,
            collection_type_description
          ''')
          .eq('collection_type_status', 'active')
          .order('collection_type_name', ascending: true);

      if (response.isEmpty) {
        _collectionTypes = [];
      } else {
        _collectionTypes =
            response.map((json) => CollectionType.fromJson(json)).toList();
      }

      _isLoading = false;
      notifyListeners();
      return _collectionTypes;
    } catch (e) {
      _handleError('fetching collection types', e);
      return [];
    }
  }

  Future<Map<String, dynamic>> addCollectionType(
      CollectionType collectionType) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _supabaseClient
          .from('collection_type')
          .insert(collectionType.toJson())
          .select();

      await fetchActiveCollectionTypes();

      return {
        "status": "Success",
        "message": "Collection type added successfully",
        "collection_type": response
      };
    } catch (e) {
      _handleError('adding collection type', e);
      return {"status": "Error", "message": "Error adding collection type: $e"};
    }
  }

  // Refresh methods
  Future<void> refreshData() async {
    await Future.wait([
      _fetchCollections(),
      fetchActiveCollectionTypes(),
    ]);
  }
}
