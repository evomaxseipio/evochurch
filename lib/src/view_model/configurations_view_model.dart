import 'dart:async';

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

  
  final _adminUsersController = StreamController<List<AdminUser>>.broadcast();
  Stream<List<AdminUser>> get adminUsersStream => _adminUsersController.stream;

late final Stream<List<AdminUser>> adminUsersStream1;

  ConfigurationsViewModel() {
    loadUsers();
  }

  Stream<Map<String, dynamic>> loadUser()  {
    final churchId = authServices.userMetaData?['church_id'];

    try {
      final response = _supabaseClient.rpc(
        'sp_get_admin_user_list',
        params: {'p_church_id': churchId},
      ).asStream().map((list) {
      final users = AdminListResponse.fromJson(list);
      

        return {
          'success': users.success,
          'status_code': users.statusCode,
          'message': users.message,
          'users_list': users.adminList
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


   Future<void> loadUsers() async {
    final churchId = await authServices.userMetaData?['church_id'];

    try {
      final response = await _supabaseClient.rpc(
        'sp_get_admin_user_list',
        params: {'p_church_id': churchId},
      );
      final users = AdminListResponse.fromJson(response).adminList;
      _adminUsersController.add(users);
    } catch (e) {
      _adminUsersController.addError(e);
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
