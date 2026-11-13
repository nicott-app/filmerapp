import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  AuthService();

  bool _isFirebaseInitialized = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Initialize Firebase. Call this in main.dart or before use.
  /// Returns false if initialization fails (e.g. creating a graceful degraded mode).
  Future<bool> initialize() async {
    try {
      await Firebase.initializeApp();
      _isFirebaseInitialized = true;
      debugPrint("Firebase initialized successfully.");
      return true;
    } catch (e) {
      debugPrint("Warning: Firebase initialization failed. Social Login will be simulated.");
      debugPrint("Error details: $e");
      // Likely missing google-services.json or GoogleService-Info.plist
      return false;
    }
  }

  /// Sign in with Google
  /// Returns a UserCredential on success, or throws error.
  Future<UserCredential?> signInWithGoogle() async {
    if (!_isFirebaseInitialized) {
      // Simulate login for dev without config
      await Future.delayed(const Duration(seconds: 2));
      debugPrint("Simulated Google Login Successful");
      return null; // Return null to indicate "mock success" handling in UI or provider
    }

    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      debugPrint("Google Sign In Error: $e");
      rethrow;
    }
  }

  /// Sign in with Apple
  Future<UserCredential?> signInWithApple() async {
     if (!_isFirebaseInitialized) {
      // Simulate login for dev without config
      await Future.delayed(const Duration(seconds: 2));
      debugPrint("Simulated Apple Login Successful");
      return null;
    }

    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final OAuthProvider oauthProvider = OAuthProvider('apple.com');
      final AuthCredential credential = oauthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      debugPrint("Apple Sign In Error: $e");
      rethrow;
    }
  }

  Future<void> signOut() async {
    if (_isFirebaseInitialized) {
      await FirebaseAuth.instance.signOut();
      await _googleSignIn.signOut();
    }
  }

  Future<void> deleteAccount() async {
    if (_isFirebaseInitialized) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete();
      }
      await _googleSignIn.signOut();
    }
  }

  // Helper to get current user data safely
  User? getCurrentUser() {
    if (_isFirebaseInitialized) {
      return FirebaseAuth.instance.currentUser;
    }
    return null;
  }
}
