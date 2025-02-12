// user_model.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String role;

  UserModel({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      role: json['role'] ?? 'member',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'role': role,
    };
  }
}

/// Response type for sign up operation
class SignUpResult {
  final AuthResponse? response;
  final String? message;
  final bool success;

  SignUpResult({
    this.response,
    this.message,
    required this.success,
  });
}

class AuthResult {
  final bool success;
  final String message;
  final int? statusCode;
  final AuthResponse? response;
  final User? user;

  AuthResult({
    required this.success,
    required this.message,
    this.statusCode,
    this.response,
    this.user,
  });

  factory AuthResult.fromJson(Map<String, dynamic> json) {
    return AuthResult(
      success: json['success'],
      message: json['message'],
      statusCode: json['status_code'],
      response: json['response']?.map((e) => AuthResponse.fromJson(e),
      user: json['user']?.map((e) => User.fromJson(e))),
  );
}
}


