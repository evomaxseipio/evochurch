import 'package:uuid/uuid.dart';

class Profile {
  final String id;
  final String firstName;
  final String lastName;
  String? nickName;
  DateTime? dateOfBirth;
  String? gender;
  String? maritalStatus;
  String? nationality;
  String? idType;
  String? idNumber;
  bool isMember;
  bool isActive;
  String? bio;
  final DateTime createdAt;
  DateTime updatedAt;

  Profile({
    String? id,
    required this.firstName,
    required this.lastName,
    this.nickName,
    this.dateOfBirth,
    this.gender,
    this.maritalStatus,
    this.nationality,
    this.idType,
    this.idNumber,
    this.isMember = false,
    this.isActive = true,
    this.bio,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Profile copyWith({
    String? firstName,
    String? lastName,
    String? nickName,
    DateTime? dateOfBirth,
    String? gender,
    String? maritalStatus,
    String? nationality,
    String? idType,
    String? idNumber,
    bool? isMember,
    bool? isActive,
    String? bio,
    DateTime? updatedAt,
  }) {
    return Profile(
      id: this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      nickName: nickName ?? this.nickName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      nationality: nationality ?? this.nationality,
      idType: idType ?? this.idType,
      idNumber: idNumber ?? this.idNumber,
      isMember: isMember ?? this.isMember,
      isActive: isActive ?? this.isActive,
      bio: bio ?? this.bio,
      createdAt: this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      nickName: json['nick_name'],
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'])
          : null,
      gender: json['gender'],
      maritalStatus: json['marital_status'],
      nationality: json['nationality'],
      idType: json['id_type'],
      idNumber: json['id_number'],
      isMember: json['is_member'] ?? false,
      isActive: json['is_active'] ?? true,
      bio: json['bio'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'nick_name': nickName,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'marital_status': maritalStatus,
      'nationality': nationality,
      'id_type': idType,
      'id_number': idNumber,
      'is_member': isMember,
      'is_active': isActive,
      'bio': bio,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
