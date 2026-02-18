import 'package:car_rongsok_app/core/extensions/logger_extension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Service untuk handle Google Sign-In authentication (google_sign_in v7)
class GoogleAuthService {
  final FirebaseAuth _auth;

  GoogleAuthService(this._auth);

  GoogleSignIn get _googleSignIn => GoogleSignIn.instance;

  bool _initialized = false;

  /// Initialize GoogleSignIn — panggil sekali di awal (e.g., dari DI/main)
  /// serverClientId = Web Client ID dari Firebase Console (OAuth 2.0 Web Client)
  Future<void> initialize() async {
    if (_initialized) return;
    // * serverClientId wajib di Android v7 agar CredentialManager bisa return ID token
    // * Ambil dari Firebase Console → Authentication → Sign-in method → Google → Web SDK config
    await _googleSignIn.initialize(
      serverClientId:
          '262950684512-d7gh3oq6sv44ujprooritdjffrc3skuj.apps.googleusercontent.com',
    );
    _initialized = true;
    logService('GoogleSignIn initialized');
  }

  /// Sign in dengan Google
  /// Returns Firebase ID Token jika sukses, null jika gagal/dibatalkan
  Future<String?> signInWithGoogle({
    required void Function(String error) onError,
  }) async {
    try {
      logService('Starting Google Sign-In...');

      // * Pastikan sudah diinisialisasi sebelum authenticate
      await initialize();

      // * Trigger Google authenticate flow (replaces signIn() in v7)
      final googleUser = await _googleSignIn.authenticate();

      // * Dapatkan ID Token dari authentication tokens
      final googleIdToken = googleUser.authentication.idToken;

      if (googleIdToken == null) {
        onError('Google Sign-In failed: no ID token received');
        return null;
      }

      // * Buat Firebase credential dari Google ID token
      final credential = GoogleAuthProvider.credential(idToken: googleIdToken);

      // * Sign in ke Firebase dengan Google credential
      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user == null) {
        onError('Google Sign-In failed. Please try again');
        return null;
      }

      // * Dapatkan Firebase ID Token (ini yang dikirim ke backend)
      final idToken = await userCredential.user!.getIdToken();
      logService('Google Sign-In successful: ${googleUser.email}');
      return idToken;
    } on GoogleSignInException catch (e) {
      logError('Google Sign-In exception', e);
      // * User membatalkan atau error
      if (e.code == GoogleSignInExceptionCode.canceled) {
        logService('Google Sign-In cancelled by user');
        return null;
      }
      onError('Google Sign-In failed: ${e.description ?? e.code.name}');
      return null;
    } catch (e, s) {
      logError('Unexpected error during Google Sign-In', e, s);
      onError('Google Sign-In failed: ${e.toString()}');
      return null;
    }
  }

  /// Sign out dari Google & Firebase
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      logService('Google auth signed out');
    } catch (e, s) {
      logError('Failed to sign out from Google', e, s);
    }
  }
}
