import 'dart:convert';

import 'package:evochurch/src/model/member_model.dart';
import 'package:evochurch/src/model/model_index.dart';
import 'package:evochurch/src/view_model/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MembersViewModel extends ChangeNotifier {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final AuthServices _authServices = AuthServices();

  List<Member> _members = [];
  Member? _selectedMember; // This is fine as nullable

  bool _isLoading = false;

  // Getters
  List<Member> get members => _members;

  // Updated selectedMember getter with null check
  Member? get selectedMember => _selectedMember;

  bool get isLoading => _isLoading;

  // Setters
  set selectedMember(Member? value) {
    _selectedMember = value;
    notifyListeners();
  }

  void selectMember(Member member) {
    _selectedMember = member;
    notifyListeners();
  }

  // void clearSelectedMember() {
  //   _selectedMember = null;
  //   notifyListeners();
  // }

  void setMembers(List<Member> value) {
    _members = value;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value; // Fixed: was always setting to false
    notifyListeners();
  }

  // Get the list of Members
  Future<List<Member>> getMemberList() async {
    try {
      setLoading(true);

      final String jsonString =
          await rootBundle.loadString('assets/data/members_data.json');
      final jsonData = jsonDecode(jsonString);
      final membersList = MembersModel.fromJson(jsonData).member;

      setMembers(membersList);
      return membersList;
    } catch (e) {
      throw Exception('Failed to load members: ${e.toString()}');
    } finally {
      setLoading(false);
    }
  }

  Future<Map<String, dynamic>> getMembers() async {
    // Initialize Supabase client
    final client = Supabase.instance.client;

    try {
      final response = await client.rpc('spgetprofiles');
      setLoading(true);
      final membersList = MembersModel.fromJson(response).member;
      setMembers(membersList);

      return {
        'success': response['success'],
        'status_code': response['status_code'],
        'message': response['message'],
        'member_list': membersList,
      };
    } catch (error) {
      return {
        'success': false,
        'status_code': 500,
        'message': "An error occurred while fetching members: $error",
        'member_list': [],
      };
    } finally {
      setLoading(false);
    }
  }

  Future<Map<String, dynamic>?> addMember(Member member, AddressModel address, ContactModel contact) async {
   
     try {
      final response = await _supabaseClient.rpc('spinsertprofiles', params: {
        'p_church_id': member.churchId,
        'p_first_name': member.firstName,
        'p_last_name': member.lastName,
        'p_nick_name': member.nickName,
        'p_date_of_birth': member.dateOfBirth?.toIso8601String(),
        'p_gender': member.gender,
        'p_marital_status': member.maritalStatus,
        'p_nationality': member.nationality,
        'p_id_type': member.idType,
        'p_id_number': member.idNumber,
        'p_is_member': member.isMember,
        'p_is_active': member.isActive,
        'p_bio': member.bio,
        'p_street_address': address.streetAddress,
        'p_state_province': address.stateProvince,
        'p_city_state': address.cityState,
        'p_country': address.country,
        'p_phone': contact.phone,
        'p_mobile_phone': contact.mobilePhone,
        'p_email': contact.email,
      });

      // Handle the JSON response from the stored procedure
      final Map<String, dynamic> responseData =
          response as Map<String, dynamic>;
      debugPrint(
          'Profile added successfully with ID: ${responseData['profile_id']}');
      return responseData;
    } catch (e) {
      debugPrint('Error adding profile: $e');
      throw Exception('Failed to insert profile: $e');
    }
  }

  Future<Map<String, dynamic>?> updateMember(
      Member member, AddressModel address, ContactModel contact) async {
    try {
      final response = await _supabaseClient.rpc('spupdateprofiles', params: {
        'p_id': member.memberId,
        'p_first_name': member.firstName,
        'p_last_name': member.lastName,
        'p_nick_name': member.nickName,
        'p_date_of_birth': member.dateOfBirth?.toIso8601String(),
        'p_gender': member.gender,
        'p_marital_status': member.maritalStatus,
        'p_nationality': member.nationality,
        'p_id_type': member.idType,
        'p_id_number': member.idNumber,
        'p_is_member': member.isMember,
        'p_is_active': member.isActive,
        'p_bio': member.bio,
        'p_street_address': address.streetAddress,
        'p_state_province': address.stateProvince,
        'p_city_state': address.cityState,
        'p_country': address.country,
        'p_phone': contact.phone,
        'p_mobile_phone': contact.mobilePhone,
        'p_email': contact.email,
      });

      // Handle the JSON response from the stored procedure
      final responseData = response;
      return responseData;
    } catch (e) {
      debugPrint('Error adding member: $e');
      throw Exception('Failed to insert member: $e');
    }
  }

  Future<User> updateUserMetaData() async {
    final UserResponse res = await _supabaseClient.auth.updateUser(
      UserAttributes(
        data: {'church_id': 1, 'role': 'pastor'},
      ),
    );
    final User? updatedUser = res.user;
    return updatedUser!;
  }
}
