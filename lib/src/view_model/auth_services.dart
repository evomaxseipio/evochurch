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
  Map<String, dynamic>? get userMetaData  {
    _userMetadata = _supabase.auth.currentUser?.userMetadata;
    return _userMetadata;
  }
  
 



  // Sign Up
  Future<bool> signUp({required String email, required String password, 
  required String username, required String fullName}) async {
    _setLoading(true);
    _clearError();
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'username': username, 'full_name': fullName}
      );

      if (response.user != null) {
        debugPrint('Sign up successful.');
        _setError('Please check your email for confirmation link.');
        return true;
      } else {
        debugPrint('Sign up failed.');
        _setError('Sign up failed. Please try again.');
        return false;
      }
    } on AuthException catch (error) {
      debugPrint('Sign up failed: ${error.message}');
      _setError(error.message);
      return false;
    } catch (error) {
      debugPrint('An unexpected error occurred: $error');
      _setError('An unexpected error occurred: $error');
      return false;
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
      _username = response.user?.userMetadata![ 'username' ];
      _userId = response.user?.id;
      _userMetadata = response.user?.userMetadata;
      _churchId = response.user?.userMetadata![ 'church_id' ];



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
      await _supabase.auth.signInWithOtp(email: email,
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
}
