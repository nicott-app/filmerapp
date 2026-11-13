import 'package:filmer/models/user.dart';
import 'package:filmer/core/utils/result.dart';
import 'package:filmer/services/auth_service.dart';

abstract class AuthRepository {
  Future<Result<User?>> signInWithGoogle();
  Future<Result<User?>> signInWithApple();
  Future<Result<void>> signOut();
  Future<Result<void>> deleteAccount();
  User? getCurrentUser();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;

  AuthRepositoryImpl(this._authService);

  @override
  Future<Result<User?>> signInWithGoogle() async {
    try {
      final credential = await _authService.signInWithGoogle();
      if (credential != null && credential.user != null) {
        final user = User(
          id: credential.user!.uid,
          name: credential.user!.displayName ?? 'Usuario',
        );
        return Success(user);
      }
      return const Success(null); // Means user cancelled
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<User?>> signInWithApple() async {
    try {
      final credential = await _authService.signInWithApple();
      if (credential != null && credential.user != null) {
         final user = User(
          id: credential.user!.uid,
          name: credential.user!.displayName ?? 'Usuario',
        );
        return Success(user);
      }
      return const Success(null);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _authService.signOut();
      return const Success(null);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<void>> deleteAccount() async {
    try {
      await _authService.deleteAccount();
      return const Success(null);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  User? getCurrentUser() {
    final firebaseUser = _authService.getCurrentUser();
    if (firebaseUser != null) {
       return User(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? 'Usuario',
        );
    }
    return null;
  }
}
