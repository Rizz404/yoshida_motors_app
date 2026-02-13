# Authentication Module Documentation

## 📋 Overview
Modul authentication lengkap untuk Car Rongsok App dengan Firebase Phone Authentication + OTP dan Laravel Sanctum backend.

## 🏗️ Struktur File

```
lib/
├── feature/auth/
│   ├── models/
│   │   ├── auth_response.dart          # Response model untuk login/register
│   │   ├── login_payload.dart          # Payload untuk login
│   │   ├── register_payload.dart       # Payload untuk register
│   │   ├── update_profile_payload.dart # Payload untuk update profile
│   │   └── models.dart                 # Barrel export
│   └── repositories/
│       ├── auth_repository.dart        # Abstract class repository
│       ├── auth_repository_impl.dart   # Implementasi repository
│       └── repositories.dart           # Barrel export
│
├── core/
│   ├── services/
│   │   └── auth_service.dart          # Service untuk manage token & user lokal
│   ├── network/
│   │   ├── dio_client.dart            # HTTP client dengan interceptors
│   │   └── interceptors/
│   │       ├── auth_interceptor.dart  # Auto inject Bearer token
│   │       └── locale_interceptor.dart # Auto inject Accept-Language
│   └── constants/
│       └── api_constants.dart         # API endpoints constants
│
└── di/
    └── service_providers.dart         # Riverpod providers setup
```

## 🔄 Authentication Flow

### Firebase + Backend Integration

```
┌─────────────┐
│ User Input  │
│ Phone Number│
└──────┬──────┘
       │
       ▼
┌─────────────────────┐
│ Firebase sends OTP  │
│ via SMS             │
└──────┬──────────────┘
       │
       ▼
┌─────────────────┐
│ User enters OTP │
└──────┬──────────┘
       │
       ▼
┌───────────────────────┐
│ Firebase verifies OTP │
│ Returns ID Token      │
└──────┬────────────────┘
       │
       ▼
┌────────────────────────┐
│ Send ID Token to API   │
│ POST /auth/register or │
│ POST /auth/login       │
└──────┬─────────────────┘
       │
       ▼
┌────────────────────────┐
│ Backend verifies token │
│ Returns User + Token   │
│ (Laravel Sanctum)      │
└──────┬─────────────────┘
       │
       ▼
┌───────────────────────┐
│ Save token locally    │
│ Save user data        │
└───────────────────────┘
```

## 🎯 API Endpoints

Semua endpoint sudah didefinisikan di `ApiConstant`:

```dart
// Authentication
POST   /auth/register  → ApiConstant.authRegister
POST   /auth/login     → ApiConstant.authLogin
GET    /auth/profile   → ApiConstant.authProfile
PUT    /auth/profile   → ApiConstant.authProfile
POST   /auth/logout    → ApiConstant.authLogout
```

## 📦 Models

### 1. RegisterPayload
```dart
final payload = RegisterPayload(
  idToken: firebaseIdToken,        // Required: Firebase ID Token
  phoneNumber: '+628123456789',    // Required
  name: 'John Doe',                // Optional
  email: 'john@example.com',       // Optional
  address: 'Jakarta',              // Optional
  fcmToken: deviceFcmToken,        // Optional
);
```

### 2. LoginPayload
```dart
final payload = LoginPayload(
  idToken: firebaseIdToken,   // Required: Firebase ID Token
  fcmToken: deviceFcmToken,   // Optional
);
```

### 3. UpdateProfilePayload
```dart
final payload = UpdateProfilePayload(
  name: 'New Name',      // Optional
  email: 'new@email.com', // Optional
  address: 'New Address', // Optional
  fcmToken: newFcmToken, // Optional
);
```

### 4. AuthResponse
```dart
class AuthResponse {
  final User user;
  final String token;  // Laravel Sanctum token
}
```

## 🔧 Usage Examples

### 1. Register dengan Firebase

```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:car_rongsok_app/feature/auth/models/models.dart';
import 'package:car_rongsok_app/di/service_providers.dart';

class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  AuthNotifier(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  Future<void> registerWithPhone(String phoneNumber) async {
    state = const AsyncValue.loading();

    try {
      // 1. Firebase Phone Auth
      final FirebaseAuth auth = FirebaseAuth.instance;

      // Send OTP
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (_) {},
        verificationFailed: (e) {
          state = AsyncValue.error(e, StackTrace.current);
        },
        codeSent: (verificationId, resendToken) async {
          // User inputs OTP, then confirm
          final credential = PhoneAuthProvider.credential(
            verificationId: verificationId,
            smsCode: userInputOtp, // dari UI
          );

          final userCredential = await auth.signInWithCredential(credential);
          final idToken = await userCredential.user?.getIdToken();

          if (idToken != null) {
            // 2. Call backend API
            await _registerToBackend(idToken, phoneNumber);
          }
        },
        codeAutoRetrievalTimeout: (_) {},
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> _registerToBackend(String idToken, String phoneNumber) async {
    final authRepo = ref.read(authRepositoryProvider);
    final authService = ref.read(authServiceProvider);

    final payload = RegisterPayload(
      idToken: idToken,
      phoneNumber: phoneNumber,
      name: 'User Name', // dari form
      email: 'user@email.com', // dari form
      address: null,
      fcmToken: null, // dapat dari FCM
    );

    try {
      final result = await authRepo.register(payload);

      // Save token & user locally
      await authService.saveAccessToken(result.data.token);
      await authService.saveUser(result.data.user);

      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
```

### 2. Login dengan Firebase

```dart
Future<void> loginWithPhone(String phoneNumber) async {
  state = const AsyncValue.loading();

  try {
    final FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (_) {},
      verificationFailed: (e) {
        state = AsyncValue.error(e, StackTrace.current);
      },
      codeSent: (verificationId, resendToken) async {
        final credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: userInputOtp,
        );

        final userCredential = await auth.signInWithCredential(credential);
        final idToken = await userCredential.user?.getIdToken();

        if (idToken != null) {
          await _loginToBackend(idToken);
        }
      },
      codeAutoRetrievalTimeout: (_) {},
    );
  } catch (e, stack) {
    state = AsyncValue.error(e, stack);
  }
}

Future<void> _loginToBackend(String idToken) async {
  final authRepo = ref.read(authRepositoryProvider);
  final authService = ref.read(authServiceProvider);

  final payload = LoginPayload(
    idToken: idToken,
    fcmToken: null, // FCM token jika ada
  );

  try {
    final result = await authRepo.login(payload);

    await authService.saveAccessToken(result.data.token);
    await authService.saveUser(result.data.user);

    state = const AsyncValue.data(null);
  } catch (e, stack) {
    state = AsyncValue.error(e, stack);
  }
}
```

### 3. Get Profile

```dart
Future<User?> getCurrentUser() async {
  try {
    final authRepo = ref.read(authRepositoryProvider);
    final result = await authRepo.getProfile();

    // Update local storage
    final authService = ref.read(authServiceProvider);
    await authService.saveUser(result.data);

    return result.data;
  } catch (e) {
    // Handle error
    return null;
  }
}
```

### 4. Update Profile

```dart
Future<void> updateUserProfile({
  String? name,
  String? email,
  String? address,
}) async {
  try {
    final authRepo = ref.read(authRepositoryProvider);

    final payload = UpdateProfilePayload(
      name: name,
      email: email,
      address: address,
    );

    final result = await authRepo.updateProfile(payload);

    // Update local storage
    final authService = ref.read(authServiceProvider);
    await authService.saveUser(result.data);
  } catch (e) {
    // Handle error
  }
}
```

### 5. Logout

```dart
Future<void> logout() async {
  try {
    final authRepo = ref.read(authRepositoryProvider);
    final authService = ref.read(authServiceProvider);

    // Call backend
    await authRepo.logout();

    // Clear local data
    await authService.deleteAccessToken();
    await authService.deleteUser();

    // Sign out from Firebase
    await FirebaseAuth.instance.signOut();
  } catch (e) {
    // Handle error
  }
}
```

## 🔐 AuthService (Local Storage)

Service untuk manage token dan user data di local storage:

```dart
// Get access token
final token = await authService.getAccessToken();

// Save access token
await authService.saveAccessToken('sanctum_token_here');

// Delete access token
await authService.deleteAccessToken();

// Get user
final user = await authService.getUser();

// Save user
await authService.saveUser(userModel);

// Delete user
await authService.deleteUser();
```

**Storage Details:**
- **Access Token**: Disimpan di `FlutterSecureStorage` (encrypted)
- **User Data**: Disimpan di `SharedPreferencesWithCache` (cache-able)

## 🌐 Automatic Features

### 1. Auto Authorization Header
`AuthInterceptor` otomatis inject Bearer token ke setiap request:
```
Authorization: Bearer {token}
```

### 2. Auto Locale Header
`LocaleInterceptor` otomatis inject Accept-Language:
```
Accept-Language: en-US | id-ID | ja-JP
```

### 3. Auto Token Invalidation
Jika token invalid (401), `onTokenInvalid` callback akan dipanggil untuk logout user.

## ⚠️ Important Notes

### 1. API Response Format
Backend harus return format sesuai dengan API Documentation:
```json
{
  "success": true,
  "message": "Success message",
  "data": {
    "user": {
      "id": 1,
      "firebase_uid": "abc123",
      "phone_number": "+628123456789",
      "name": "John Doe",
      "email": "john@example.com",
      "address": "Jakarta",
      "role": "customer",
      "fcm_token": null,
      "created_at": "2024-01-01T00:00:00.000000Z",
      "updated_at": "2024-01-01T00:00:00.000000Z"
    },
    "token": "sanctum_token_here"
  }
}
```

### 2. Field Naming Convention
- **Model (Dart)**: camelCase
- **API (JSON)**: snake_case
- Mapping dilakukan otomatis di `fromMap()` and `toMap()`

### 3. Error Handling
Repository akan throw `Exception` jika API return error. Gunakan try-catch:
```dart
try {
  final result = await authRepo.login(payload);
  // Success
} catch (e) {
  // Handle error: e.toString()
}
```

## 🧪 Testing

Untuk testing, mock `AuthRepository`:

```dart
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  test('login success', () async {
    final mockRepo = MockAuthRepository();

    when(() => mockRepo.login(any()))
        .thenAnswer((_) async => ApiSuccess(
          data: AuthResponse(user: mockUser, token: 'token'),
          message: 'Success',
        ));

    // Test your code
  });
}
```

## 📚 Dependencies

Required packages (sudah ada di pubspec.yaml):
- `flutter_riverpod` - State management & DI
- `dio` - HTTP client
- `flutter_secure_storage` - Secure token storage
- `shared_preferences` - User data cache
- `firebase_auth` - Firebase authentication
- `firebase_core` - Firebase core

## 🔗 Related Files

- **Router Guards**: Implementasikan di `lib/core/router/`
- **DI Setup**: `lib/di/service_providers.dart`
- **API Docs**: `API_DOCUMENTATION.md`

## 👨‍💻 Next Steps untuk Developer

1. ✅ **Auth logic sudah complete**
2. 🔲 Buat UI screens untuk:
   - Phone input screen
   - OTP verification screen
   - Profile screen
3. 🔲 Buat `AuthNotifier` provider di `lib/di/auth_providers.dart`
4. 🔲 Implement router guards untuk protected routes
5. 🔲 Setup FCM token management
6. 🔲 Add loading states dan error handling di UI

## 📝 Changelog

- **v1.0.0** - Initial implementation
  - Auth repository & models
  - Auth service untuk local storage
  - Firebase + Sanctum integration
  - Auto interceptors untuk token & locale
