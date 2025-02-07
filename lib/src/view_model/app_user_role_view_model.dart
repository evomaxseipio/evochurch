import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/model_index.dart';

class AppUserRoleViewModel extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  List<AppUserRole> _roles = [];

  List<AppUserRole> get roles => _roles;

  AppUserRoleViewModel() {
    fetchRoles();
  }

  /// Fetch all roles from Supabase
  Future<void> fetchRoles() async {
    final response = await _supabase.from('app_users_role').select();
    _roles = response.map((role) => AppUserRole.fromJson(role)).toList();
    notifyListeners();
  }

  /// Add a new role
  Future<void> addRole(AppUserRole role) async {
    final response =
        await _supabase.from('app_users_role').insert(role.toJson());
    if (response.isEmpty) return;
    fetchRoles(); // Refresh list
  }

  

  /// Update a role
  Future<void> updateRole(AppUserRole role) async {
    await _supabase
        .from('app_users_role')
        .update(role.toJson())
        .match({'app_users_role_id': role.id!});
    fetchRoles(); // Refresh list
  }

  /// Delete a role
  Future<void> deleteRole(int id) async {
    await _supabase
        .from('app_users_role')
        .delete()
        .match({'app_users_role_id': id});
    fetchRoles(); // Refresh list
  }
}
