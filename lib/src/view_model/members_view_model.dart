import 'dart:convert';

import 'package:evochurch/src/model/member_model.dart';
import 'package:evochurch/src/model/membership_model.dart';
import 'package:evochurch/src/model/model_index.dart';
import 'package:evochurch/src/view_model/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MembersViewModel extends ChangeNotifier {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final AuthServices _authServices = AuthServices();

  List<Member> _members = [];
  List<String> _memberRoles = [];
  Member? _selectedMember; // This is fine as nullable
  MembershipModel? _membershipProfile;

  bool _isLoading = false;

  // Getters
  List<Member> get members => _members;

  // Updated selectedMember getter with null check
  Member? get selectedMember => _selectedMember;
  MembershipModel? get membershipProfile => _membershipProfile;
  List<String> get memberRoles => _memberRoles;

  // Updated isLoading getter
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

  Stream<Map<String, dynamic>> getMembers() {
    // Initialize Supabase client
    final client = Supabase.instance.client;

    try {
      final response = client.rpc('spgetprofiles').asStream().map((list) {
        final MembersModel profileList = MembersModel.fromJson(list);

        return {
          'success': profileList.success,
          'status_code': profileList.statusCode,
          'message': profileList.message,
          'member_list': profileList.member
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

  Future<Map<String, dynamic>?> addMember(
      Member member, AddressModel address, ContactModel contact) async {
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

  Future<List<String>> getMemberRoles() async {
    try {
      final response = await _supabaseClient
          .from('member_roles')
          .select('role_name')
          .order('role_name', ascending: true);

      final List<String> roles = (response as List<dynamic>)
          .map((role) => role['role_name'] as String)
          .where((role) => role.isNotEmpty)
          .toList();

      _memberRoles = roles;
      notifyListeners();
    } catch (e) {
      print(e);
    }
    return _memberRoles;
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

  // Get Memberships data
  Future<Map<String, dynamic>> getMembershipByMemberId(String profileId) async {
    try {
      // final response = await _supabaseClient.from('membership').select().eq('profile_id', profileId);
      final response = await _supabaseClient
          .rpc('sp_get_membership_history_by_profile', params: {
        'p_church_id': _authServices.userMetaData!['church_id'],
        'p_profile_id': profileId,
      });

      _membershipProfile = MembershipModel.fromJson(response);
      // if (_membershipProfile!.membership!.isEmpty) {
      //   // Handle the case where the response is empty
      //   _membershipProfile = MembershipModel(
      //     success: false,
      //     statusCode: 404,
      //     message: 'No membership data found',
      //     membership: [],
      //   );
      // } else {
      //   // Handle the case where the response is not empty
      //   _membershipProfile = _membershipProfile;
      // }
      notifyListeners();

      // final membershipsList = response.map((element) => element).first;
      return _membershipProfile!.toJson();
    } catch (e) {
      throw Exception('Failed to load memberships: ${e.toString()}');
    }
  }

  // Membership Methods
  Future<Map<String, dynamic>> setMembershipMaintance(
      Map<String, dynamic> membership) async {
    try {
      final Map<String, dynamic> response =
          await _supabaseClient.rpc('spmaintancemembership', params: {
        'p_profile_id': membership['profileId'],
        'p_baptism_date': membership['baptismDate'],
        'p_baptism_church': membership['baptismChurch'],
        'p_baptism_pastor': membership['baptismPastor'],
        'p_membership_role': membership['membershipRole'],
        'p_baptism_church_city': membership['baptismChurchCity'],
        'p_baptism_church_country': membership['baptismChurchCountry'],
      });

      


      return response;
    } catch (e) {
      debugPrint('Error adding profile: $e');
      throw Exception('Failed to insert profile: $e');
    }
  }
}
