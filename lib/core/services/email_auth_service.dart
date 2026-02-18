import 'package:car_rongsok_app/core/extensions/logger_extension.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Service untuk handle Firebase Email & Password authentication
class EmailAuthService {
  final FirebaseAuth _auth;

  EmailAuthService(this._auth);

  /// Register user baru dengan email & password
  /// Returns Firebase ID Token jika sukses, null jika gagal
  Future<String?> registerWithEmail({
    required String email,
    required String password,
    required void Function(String error) onError,
  }) async {
    try {
      logService('Registering with email: $email');

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        onError('Registration failed. Please try again');
        return null;
      }

      final idToken = await credential.user!.getIdToken();
      logService('Email registration successful');
      return idToken;
    } on FirebaseAuthException catch (e) {
      logError('Email registration failed', e);

      String errorMessage = 'Registration failed';

      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email is already registered';
        case 'invalid-email':
          errorMessage = 'Invalid email format';
        case 'weak-password':
          errorMessage = 'Password is too weak (min. 6 characters)';
        case 'operation-not-allowed':
          errorMessage = 'Email/password auth is not enabled';
      }

      onError(errorMessage);
      return null;
    } catch (e, s) {
      logError('Unexpected error during email registration', e, s);
      onError('Registration failed: ${e.toString()}');
      return null;
    }
  }

  /// Login dengan email & password
  /// Returns Firebase ID Token jika sukses, null jika gagal
  Future<String?> signInWithEmail({
    required String email,
    required String password,
    required void Function(String error) onError,
  }) async {
    try {
      logService('Signing in with email: $email');

      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        onError('Login failed. Please try again');
        return null;
      }

      final idToken = await credential.user!.getIdToken();
      logService('Email sign-in successful');
      return idToken;
    } on FirebaseAuthException catch (e) {
      logError('Email sign-in failed', e);

      String errorMessage = 'Login failed';

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No account found with this email';
        case 'wrong-password':
          errorMessage = 'Incorrect password';
        case 'invalid-email':
          errorMessage = 'Invalid email format';
        case 'user-disabled':
          errorMessage = 'This account has been disabled';
        case 'too-many-requests':
          errorMessage = 'Too many failed attempts. Please try again later';
        case 'invalid-credential':
          errorMessage = 'Invalid email or password';
      }

      onError(errorMessage);
      return null;
    } catch (e, s) {
      logError('Unexpected error during email sign-in', e, s);
      onError('Login failed: ${e.toString()}');
      return null;
    }
  }

  /// Sign out dari Firebase
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      logService('Firebase email auth signed out');
    } catch (e, s) {
      logError('Failed to sign out', e, s);
    }
  }

  /// Get current Firebase user
  User? get currentUser => _auth.currentUser;
}
