import 'package:equatable/equatable.dart';

class AdminListResponse extends Equatable {
  final bool success;
  final int statusCode;
  final String message;
  final List<AdminUser> adminList;

  const AdminListResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.adminList,
  });

  factory AdminListResponse.fromJson(Map<String, dynamic> json) {
    return AdminListResponse(
      success: json['success'] ?? false,
      statusCode: json['status_code'] ?? 0,
      message: json['message'] ?? '',
      adminList: (json['adminlist'] as List<dynamic>?)
              ?.map((e) => AdminUser.fromJson(e))
              .toList() ??
          [],
    );
  }

  AdminListResponse copyWith({
    bool? success,
    int? statusCode,
    String? message,
    List<AdminUser>? adminList,
  }) {
    return AdminListResponse(
      success: success ?? this.success,
      statusCode: statusCode ?? this.statusCode,
      message: message ?? this.message,
      adminList: adminList ?? this.adminList,
    );
  }

  @override
  List<Object?> get props => [success, statusCode, message, adminList];
}

class AdminUser extends Equatable {
  final String userId;
  final String userEmail;
  final DateTime? emailConfirmedAt;
  final DateTime? lastSignInAt;
  final ProfileData profileData;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AdminUser({
    required this.userId,
    required this.userEmail,
    this.emailConfirmedAt,
    this.lastSignInAt,
    required this.profileData,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      userId: json['user_id'] ?? '',
      userEmail: json['user_email'] ?? '',
      emailConfirmedAt: json['email_confirmet_at'] != null
          ? DateTime.parse(json['email_confirmet_at'])
          : null,
      lastSignInAt: json['last_sing_in_at'] != null
          ? DateTime.parse(json['last_sing_in_at'])
          : null,
      profileData: ProfileData.fromJson(json['profile_data']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  AdminUser copyWith({
    String? userId,
    String? userEmail,
    DateTime? emailConfirmedAt,
    DateTime? lastSignInAt,
    ProfileData? profileData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AdminUser(
      userId: userId ?? this.userId,
      userEmail: userEmail ?? this.userEmail,
      emailConfirmedAt: emailConfirmedAt ?? this.emailConfirmedAt,
      lastSignInAt: lastSignInAt ?? this.lastSignInAt,
      profileData: profileData ?? this.profileData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        userEmail,
        emailConfirmedAt,
        lastSignInAt,
        profileData,
        createdAt,
        updatedAt
      ];
}

class ProfileData extends Equatable {
  final String? role;
  final String churchId;
  final String lastName;
  final String firstName;
  final String profileId;
  final bool emailVerified;
  final String roleName;

  const ProfileData({
    this.role,
    required this.churchId,
    required this.lastName,
    required this.firstName,
    required this.profileId,
    required this.emailVerified,
    this.roleName = '',
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      role: json['role'],
      churchId: json['church_id'].toString(),
      lastName: json['last_name'] ?? '',
      firstName: json['first_name'] ?? '',
      profileId: json['profile_id'] ?? '',
      emailVerified: json['email_verified'] ?? false,
      roleName: json['role_name'] ?? '',
    );
  }

  ProfileData copyWith({
    String? role,
    String? churchId,
    String? lastName,
    String? firstName,
    String? profileId,
    bool? emailVerified,
    String? roleName,
  }) {
    return ProfileData(
      role: role ?? this.role,
      churchId: churchId ?? this.churchId,
      lastName: lastName ?? this.lastName,
      firstName: firstName ?? this.firstName,
      profileId: profileId ?? this.profileId,
      emailVerified: emailVerified ?? this.emailVerified,
      roleName: roleName ?? this.roleName,
    );
  }

  @override
  List<Object?> get props =>
      [role, churchId, lastName, firstName, profileId, emailVerified, roleName];
}
