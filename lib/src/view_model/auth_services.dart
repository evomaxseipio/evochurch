import 'dart:async';

import 'package:evochurch/src/model/model_index.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class AuthServices extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  String? _errorMessage;
  bool _isLoading = false;
  String? _username;
  String? _userId;
  int? _churchId;
  Map<String, dynamic>? _userMetadata;
  

  // Getters
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  String? get username => _username;
  String? get userId => _userId;
  int get churchId {
    return _churchId = _userMetadata!['church_id'];
  }

  Map<String, dynamic>? get userMetaData {
    _userMetadata = _supabase.auth.currentUser?.userMetadata;
    return _userMetadata;
  }

  // Sign Up
  Future<AuthResult> signUp({
    required String email,
    required String password,
    required Map<String, dynamic> userAttributes,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: userAttributes,
      );

      if (response.user == null) {
        _setError('Sign up failed. Please try again.');
        return AuthResult(
          success: false,
          message: 'Sign up failed. Please try again.',
        );
      }

      if (response.user?.identities?.isEmpty ?? true) {
        _setError('Email already registered. Please sign in instead.');
        return AuthResult(
          success: false,
          message: 'Email already registered. Please sign in instead.',
        );
      }

      _setError('Please check your email for the confirmation link.');
      return AuthResult(
        response: response,
        success: true,
        message: 'Please check your email for the confirmation link.',
      );
    } on AuthException catch (error) {
      debugPrint('Sign up failed: ${error.message}');
      final errorMessage = _getReadableErrorMessage(error.message);
      _setError(errorMessage);
      return AuthResult(
        success: false,
        message: errorMessage,
      );
    } catch (error) {
      debugPrint('Unexpected error during sign up: $error');
      const errorMessage = 'An unexpected error occurred. Please try again.';
      _setError(errorMessage);
      return AuthResult(
        success: false,
        message: errorMessage,
      );
    } finally {
      _setLoading(false);
    }
  }


  // Get profile information from the authenticated user
  Future<AuthResult> getUserProfile() async {
    try {
      _setLoading(true);
      _clearError();
      late AuthResult? authResult;

      final response = await _supabase.rpc('sp_get_user_profile', params: {
        'p_profile_id': _userId,
      });

      authResult = AuthResult.fromJson(response);
      _setLoading(false);
      _setError(authResult.message);
      return authResult;
    } on AuthException catch (error) {
      debugPrint('Profile fetch failed: ${error.message}');
      final errorMessage = _getReadableErrorMessage(error.message);
      _setError(errorMessage);
      return AuthResult(
        success: false,
        statusCode: 400,
        message: errorMessage,
      );
    } on PostgrestException catch (error) {
      debugPrint('Database error during profile fetch: ${error.message}');
      final errorMessage = 'Failed to fetch user profile: ${error.message}';
      _setError(errorMessage);
      return AuthResult(
        success: false,
        statusCode: 400,
        message: errorMessage,
      );
    } catch (error) {
      debugPrint('Unexpected error during profile fetch: $error');
      const errorMessage =
          'An unexpected error occurred while fetching user profile';
      _setError(errorMessage);
      return AuthResult(
        success: false,
        statusCode: 400,
        message: errorMessage,
      );
    } finally {
      _setLoading(false);
    }
  }




  Future<AuthResult> updateUserMetadata({
    // String? email,
    // String? password,
    required int churchId,
    required String profileId,
    required int role,
    required bool isActive,
  }) async {
    try {
      _setLoading(true);
      _clearError();
      late AuthResult? authResult;

      final response = await _supabase.rpc('sp_admin_update_user', params: {
        // 'email': email,
        // 'password': password,
        'p_church_id': churchId,
        'p_profile_id': profileId,
        'p_role_id': role,
        'p_is_active': isActive,
      });   

      authResult = AuthResult.fromJson(response);
      _setLoading(false);
      _setError(authResult.message);
      return authResult;
    } on AuthException catch (error) {
      debugPrint('Metadata update failed: ${error.message}');
      final errorMessage = _getReadableErrorMessage(error.message);
      _setError(errorMessage);
      return AuthResult(
        success: false,
        statusCode: 400,
        message: errorMessage,
      );
    } on PostgrestException catch (error) {
      debugPrint('Database error during metadata update: ${error.message}');
      final errorMessage = 'Failed to update user data: ${error.message}';
      _setError(errorMessage);
      return AuthResult(
        success: false,
        statusCode: 400,
        message: errorMessage,
      );
    } catch (error) {
      debugPrint('Unexpected error during metadata update: $error');
      const errorMessage =
          'An unexpected error occurred while updating user data';
      _setError(errorMessage);
      return AuthResult(
        success: false,
        statusCode: 400,
        message: errorMessage,
      );
    } finally {
      _setLoading(false);
    }
  }

  // Sign In with email and password
  Future<bool> signIn({required String email, required String password}) async {
    _setLoading(true);
    _clearError();
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // Set username and userId
      _username = response.user?.userMetadata!['username'];
      _userId = response.user?.id;
      _userMetadata = response.user?.userMetadata;
      _churchId = int.tryParse(response.user?.userMetadata!['church_id']);

      // Notify listeners of changes
      notifyListeners();
      _setLoading(false);
      return response.user != null;
    } on AuthException catch (error) {
      _setError(error.message);
      _setLoading(false);
      return false;
    } catch (error) {
      _setLoading(false);
      _setError('An unexpected error occurred: $error');
      return false;
    }
  }

  // Sign In with OTP
  Future<bool> signInWithOtp({required String email}) async {
    _setLoading(true);
    _clearError();
    try {
      await _supabase.auth.signInWithOtp(
        email: email,
        emailRedirectTo:
            kIsWeb ? null : 'io.supabase.flutterquickstart://login-callback/',
      );
      _setError('Check your email for the OTP.');
      return true;
    } on AuthException catch (error) {
      _setError(error.message);
      return false;
    } catch (error) {
      _setError('An unexpected error occurred: $error');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Verify OTP
  Future<bool> verifyOtp({required String email, required String token}) async {
    _setLoading(true);
    _clearError();
    try {
      final response = await _supabase.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.magiclink,
      );
      _setLoading(false);
      return response.user != null;
    } on AuthException catch (error) {
      _setLoading(false);
      _setError(error.message);
      return false;
    } catch (error) {
      _setLoading(false);
      _setError('An unexpected error occurred: $error');
      return false;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
    notifyListeners();
  }

  // Check if user is authenticated
  bool isAuthenticated() {
    return _supabase.auth.currentUser != null;
  }

  // Get current user
  User? get currentUser => _supabase.auth.currentUser;

  // Private helper methods
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  String _getReadableErrorMessage(String message) {
    // Common Supabase auth error messages
    switch (message.toLowerCase()) {
      case 'user already registered':
        return 'This email is already registered. Please sign in instead.';
      case 'invalid email':
        return 'Please enter a valid email address.';
      case 'weak password':
        return 'Password is too weak. Please use at least 6 characters with numbers and letters.';
      case 'user not found':
        return 'User account not found. Please sign in again.';
      case 'invalid claims':
        return 'Invalid user data provided.';
      case 'invalid permissions':
        return 'You don\'t have permission to update this information.';
      default:
        return message;
    }
  }
}
