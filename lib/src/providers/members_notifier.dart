import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/member_model.dart';
import '../model/membership_model.dart';
import '../model/model_index.dart';
import '../view_model/auth_services.dart';

class MembersState {
  final List<Member> members;
  final bool isLoading;
  final String? error;
  final Member? selectedMember;
  final MembershipModel? membershipProfile;
  final Map<String, dynamic> memberFinances;
  final List<String> memberRoles;

  MembersState({
    this.members = const [],
    this.isLoading = false,
    this.error,
    this.selectedMember,
    this.membershipProfile,
    this.memberFinances = const {},
    this.memberRoles = const [],
  });

  MembersState copyWith({
    List<Member>? members,
    bool? isLoading,
    String? error,
    Member? selectedMember,
    MembershipModel? membershipProfile,
    Map<String, dynamic>? memberFinances,
    List<String>? memberRoles,
  }) {
    return MembersState(
      members: members ?? this.members,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedMember: selectedMember ?? this.selectedMember,
      membershipProfile: membershipProfile ?? this.membershipProfile,
      memberFinances: memberFinances ?? this.memberFinances,
      memberRoles: memberRoles ?? this.memberRoles,
    );
  }
}

class MembersNotifier extends StateNotifier<MembersState> {
  MembersNotifier() : super(MembersState()) {
    fetchMembers();
  }

  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final AuthServices _authServices = AuthServices();

  Future<void> fetchMembers() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _supabaseClient.rpc('spgetprofiles');
      final MembersModel profileList = MembersModel.fromJson(response);
      state = state.copyWith(
        members: profileList.member,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void selectMember(Member? member) {
    state = state.copyWith(selectedMember: member);
  }

  Future<Map<String, dynamic>?> addMember(
      Member member, AddressModel address, ContactModel contact) async {
    state = state.copyWith(isLoading: true, error: null);
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
      await fetchMembers();
      state = state.copyWith(isLoading: false);
      return response as Map<String, dynamic>;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> updateMember(
      Member member, AddressModel address, ContactModel contact) async {
    state = state.copyWith(isLoading: true, error: null);
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
      await fetchMembers();
      state = state.copyWith(isLoading: false);
      return response as Map<String, dynamic>;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
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
      state = state.copyWith(memberRoles: roles);
      return roles;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return [];
    }
  }

  Future<Map<String, dynamic>> getMembershipByMemberId(String profileId) async {
    try {
      final response = await _supabaseClient
          .rpc('sp_get_membership_history_by_profile', params: {
        'p_church_id': _authServices.userMetaData!['church_id'],
        'p_profile_id': profileId,
      });
      final membershipProfile = MembershipModel.fromJson(response);
      state = state.copyWith(membershipProfile: membershipProfile);
      return membershipProfile.toJson();
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getFinancialByMemberId(String profileId) async {
    try {
      final response = await _supabaseClient.rpc(
        'sp_get_collection_by_member',
        params: {
          'p_church_id': _authServices.userMetaData!['church_id'],
          'p_profile_id': profileId,
        },
      );
      state = state.copyWith(memberFinances: response);
      return response;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getFinancialByChurch() async {
    try {
      final response = await _supabaseClient.rpc(
        'sp_get_collection_by_member',
        params: {
          'p_church_id': _authServices.userMetaData!['church_id'],
        },
      );
      state = state.copyWith(memberFinances: response);
      return response;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }
}

final membersNotifierProvider =
    StateNotifierProvider<MembersNotifier, MembersState>(
        (ref) => MembersNotifier());
