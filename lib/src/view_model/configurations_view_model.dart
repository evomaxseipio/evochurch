import 'package:evochurch/src/model/admin_users_model.dart';
import 'package:evochurch/src/model/users_model.dart';
import 'package:evochurch/src/view_model/index_view_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConfigurationsViewModel extends ChangeNotifier {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
   final authServices = AuthServices();
  List<AdminUser> users = [];
  bool isLoading = false;
  String? error;

  // ConfigurationsViewModel() {
  //   loadUsers();
  // }

  Future<void> loadUsers() async {
    isLoading = true;
    error = null;
    notifyListeners();

    
    final churchId = await authServices.userMetaData?['church_id'];

    try {
      final response = await _supabaseClient.rpc('sp_get_admin_user_list',
        params: {'p_church_id': churchId},);

        users = AdminListResponse.fromJson((response)).adminList;
        // users = (response as List).map((data) => AdminUserModel.fromJson(data)).toList();
        // debugPrint('Users: $users');

      //await _supabaseClient.auth.admin.listUsers(page: 1, perPage: 10);
      // .from('auth.users')
      // .select()
      // .order('created_at', ascending: false);

      // users = (response as List).map((data) => UserModel.fromJson(data)).toList();
    } catch (e) {
      error = 'Failed to load users: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createUser({
    required String email,
    required String password,
    required String role,
    String? firstName,
    String? lastName,
  }) async {
    try {
      // Create auth user
      final authResponse = await _supabaseClient.auth.admin.createUser(
        AdminUserAttributes(
          email: email,
          password: password,
          data: {'role': role},
        ),
      );

      // Add user details to users table
      await _supabaseClient.from('users').insert({
        'id': authResponse.user!.id,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'role': role,
      });

      await loadUsers(); // Refresh the list
    } catch (e) {
      throw 'Failed to create user: $e';
    }
  }

  Future<void> updateUser({
    required String userId,
    String? firstName,
    String? lastName,
    String? role,
  }) async {
    try {
      await _supabaseClient.from('users').update({
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
        if (role != null) 'role': role,
      }).match({'id': userId});

      await loadUsers(); // Refresh the list
    } catch (e) {
      throw 'Failed to update user: $e';
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      // Delete from auth
      await _supabaseClient.auth.admin.deleteUser(userId);

      // Delete from users table
      await _supabaseClient.from('users').delete().match({'id': userId});

      // Refresh the list
      await loadUsers();
    } catch (e) {
      throw 'Failed to delete user: $e';
    }
  }
}
