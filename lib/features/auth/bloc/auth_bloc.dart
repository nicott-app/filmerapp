import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:filmer/domain/repositories/auth_repository.dart';
import 'package:filmer/core/utils/result.dart';
import 'package:filmer/models/user.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LoginWithGoogle>(_onLoginWithGoogle);
    on<LoginWithApple>(_onLoginWithApple);
    on<LoginAsGuest>(_onLoginAsGuest);
    on<LogoutRequested>(_onLogoutRequested);
    on<DeleteAccountRequested>(_onDeleteAccountRequested);
  }

  Future<void> _onCheckAuthStatus(CheckAuthStatus event, Emitter<AuthState> emit) async {
    final user = _authRepository.getCurrentUser();
    if (user != null) {
       emit(Authenticated(user));
    } else {
       emit(Unauthenticated());
    }
  }

  Future<void> _onLoginWithGoogle(LoginWithGoogle event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _authRepository.signInWithGoogle();
    
    if (result is Success<User?>) {
      if (result.value != null) {
        emit(Authenticated(result.value!));
      } else {
        emit(const AuthError("Google login cancelled or failed."));
      }
    } else if (result is Failure) {
      emit(AuthError((result as Failure).error));
    }
  }

  Future<void> _onLoginWithApple(LoginWithApple event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _authRepository.signInWithApple();
    
    if (result is Success<User?>) {
      if (result.value != null) {
        emit(Authenticated(result.value!));
      } else {
        emit(const AuthError("Apple login cancelled or failed."));
      }
    } else if (result is Failure) {
      emit(AuthError((result as Failure).error));
    }
  }

  Future<void> _onLoginAsGuest(LoginAsGuest event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final user = User(
      id: "guest_${DateTime.now().millisecondsSinceEpoch}", 
      name: event.name
    );
    emit(Authenticated(user));
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await _authRepository.signOut();
    emit(Unauthenticated());
  }

  Future<void> _onDeleteAccountRequested(DeleteAccountRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _authRepository.deleteAccount();
    if (result is Success) {
      emit(Unauthenticated());
    } else if (result is Failure) {
      emit(AuthError(result.error));
    }
  }
}
