import 'package:evochurch/src/model/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/model_index.dart';

class ProfileViewModel extends ChangeNotifier {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  


  Future<Map<String, dynamic>?> addProfile(
      Profile profile, AddressModel address, ContactModel contact) async {
   
    try {
      final response = await _supabaseClient.rpc('spinsertprofiles', params: {
        'p_first_name': profile.firstName,
        'p_last_name': profile.lastName,
        'p_nick_name': profile.nickName,
        'p_date_of_birth': profile.dateOfBirth?.toIso8601String(),
        'p_gender': profile.gender,
        'p_marital_status': profile.maritalStatus,
        'p_nationality': profile.nationality,
        'p_id_type': profile.idType,
        'p_id_number': profile.idNumber,
        'p_is_member': profile.isMember,
        'p_is_active': profile.isActive,
        'p_bio': profile.bio,
        'p_street_address': address.streetAddress,
        'p_state_province': address.stateProvince,
        'p_city_state': address.cityState,
        'p_country': address.country,
        'p_phone': contact.phone,
        'p_mobile_phone': contact.mobilePhone,
        'p_email': contact.email,
      });

      // Handle the JSON response from the stored procedure
      final Map<String, dynamic> responseData = response as Map<String, dynamic>;
      debugPrint('Profile added successfully with ID: ${responseData['profile_id']}');
      return responseData;
    } catch (e) {
      debugPrint('Error adding profile: $e');
      throw Exception('Failed to insert profile: $e');
    }
  }

  Future<Map<String, dynamic>?> updateProfile(Profile profile, AddressModel address, ContactModel contact) async {
    try {
      final response = await _supabaseClient.rpc('spupdateprofiles', params: {
        'p_id': profile.id,
        'p_first_name': profile.firstName,
        'p_last_name': profile.lastName,
        'p_nick_name': profile.nickName,
        'p_date_of_birth': profile.dateOfBirth?.toIso8601String(),
        'p_gender': profile.gender,
        'p_marital_status': profile.maritalStatus,
        'p_nationality': profile.nationality,
        'p_id_type': profile.idType,
        'p_id_number': profile.idNumber,
        'p_is_member': profile.isMember,
        'p_is_active': profile.isActive,
        'p_bio': profile.bio,
        'p_street_address': address.streetAddress,
        'p_state_province': address.stateProvince,
        'p_city_state': address.cityState,
        'p_country': address.country,
        'p_phone': contact.phone,
        'p_mobile_phone': contact.mobilePhone,
        'p_email': contact.email,
      });

      // Handle the JSON response from the stored procedure
      final Map<String, dynamic> responseData = response as Map<String, dynamic>;
      debugPrint('Profile updated successfully with ID: ${responseData['profile_id']}');
      return responseData;
    } catch (e) {
      debugPrint('Error adding profile: $e');
      throw Exception('Failed to insert profile: $e');
    }
  }
}
