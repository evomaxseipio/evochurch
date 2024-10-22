import 'package:evochurch/src/model/addres_model.dart';
import 'package:evochurch/src/model/contact_model.dart';

class MemberProfile {
  final String firstName;
  final String lastName;
  final String nickname;
  final DateTime dateOfBirth;
  final String gender;
  final String maritalStatus;
  final String nationality;
  final String idType;
  final String idNumber;
  final bool isActive;
  final bool isMember;
  final AddressModel address;
  final String? profileImageUrl;
  // final String email;
  // final String phone;
  final String bio;
  final String role;
  final String location;
  final ContactModel contact;

  // ... keep other existing fields

  MemberProfile({
    required this.firstName,
    required this.lastName,
    required this.nickname,
    required this.dateOfBirth,
    required this.gender,
    required this.maritalStatus,
    required this.nationality,
    required this.idType,
    required this.idNumber,
    required this.isActive,
    required this.isMember,
    required this.address,
    this.profileImageUrl,
    // required this.email,
    // required this.phone,
    required this.bio,
    required this.role,
    required this.location, 
    required this.contact,
    // ... keep other required fields
  });
}
