import 'package:car_rongsok_app/core/extensions/logger_extension.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Service untuk handle Firebase phone authentication
class PhoneAuthService {
  final FirebaseAuth _auth;

  PhoneAuthService(this._auth);

  /// Kirim OTP ke nomor telepon
  /// Returns verification ID yang akan digunakan untuk verifikasi OTP
  Future<String?> sendOTP({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String error) onError,
    void Function()? onAutoVerified,
  }) async {
    try {
      logService('Sending OTP to: $phoneNumber');

      String? verificationIdResult;

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // * Auto-verification (Android only)
          logService('Phone number auto-verified');
          onAutoVerified?.call();
        },
        verificationFailed: (FirebaseAuthException e) {
          logError('Phone verification failed', e);

          String errorMessage = 'Verification failed';

          if (e.code == 'invalid-phone-number') {
            errorMessage = 'Invalid phone number format';
          } else if (e.code == 'too-many-requests') {
            errorMessage = 'Too many requests. Please try again later';
          } else if (e.code == 'quota-exceeded') {
            errorMessage = 'SMS quota exceeded. Please contact support';
          }

          onError(errorMessage);
        },
        codeSent: (String verificationId, int? resendToken) {
          logService('OTP sent successfully: $verificationId');
          verificationIdResult = verificationId;
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          logService('Auto retrieval timeout: $verificationId');
          verificationIdResult = verificationId;
        },
      );

      return verificationIdResult;
    } catch (e, s) {
      logError('Failed to send OTP', e, s);
      onError('Failed to send OTP: ${e.toString()}');
      return null;
    }
  }

  /// Verify OTP dan dapatkan ID Token
  Future<String?> verifyOTP({
    required String verificationId,
    required String otpCode,
    required void Function(String error) onError,
  }) async {
    try {
      logService('Verifying OTP...');

      // * Create credential dari verification ID dan OTP
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpCode,
      );

      // * Sign in dengan credential
      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user == null) {
        onError('Authentication failed. Please try again');
        return null;
      }

      // * Dapatkan ID Token (ini yang dikirim ke backend)
      final idToken = await userCredential.user!.getIdToken();

      logService('OTP verified successfully');
      return idToken;
    } on FirebaseAuthException catch (e) {
      logError('OTP verification failed', e);

      String errorMessage = 'Invalid verification code';

      if (e.code == 'invalid-verification-code') {
        errorMessage = 'Invalid OTP code. Please check and try again';
      } else if (e.code == 'session-expired') {
        errorMessage = 'OTP expired. Please request a new code';
      }

      onError(errorMessage);
      return null;
    } catch (e, s) {
      logError('Failed to verify OTP', e, s);
      onError('Verification failed: ${e.toString()}');
      return null;
    }
  }

  /// Sign out dari Firebase (dipanggil saat logout)
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      logService('Firebase auth signed out');
    } catch (e, s) {
      logError('Failed to sign out from Firebase', e, s);
    }
  }

  /// Get current Firebase user
  User? get currentUser => _auth.currentUser;

  /// Check if user is signed in
  bool get isSignedIn => _auth.currentUser != null;
}
