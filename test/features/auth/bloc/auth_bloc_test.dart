import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:filmer/domain/repositories/auth_repository.dart';
import 'package:filmer/core/utils/result.dart';

import 'package:filmer/features/auth/bloc/auth_bloc.dart';
import 'package:filmer/features/auth/bloc/auth_event.dart';
import 'package:filmer/features/auth/bloc/auth_state.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late AuthBloc authBloc;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authBloc = AuthBloc(mockAuthRepository);
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    test('El estado inicial debe ser AuthInitial', () {
      expect(authBloc.state, isA<AuthInitial>());
    });

    test('Emite [AuthLoading, Authenticated] al iniciar sesión como invitado', () async {
      authBloc.add(const LoginAsGuest('Usuario Invitado'));

      await expectLater(
        authBloc.stream,
        emitsInOrder([
          isA<AuthLoading>(),
          isA<Authenticated>().having((s) => s.user.name, 'name', 'Usuario Invitado'),
        ]),
      );
    });

    test('Emite [AuthLoading, AuthError] cuando LoginWithGoogle falla o se cancela devolviendo Success(null)', () async {
      when(() => mockAuthRepository.signInWithGoogle()).thenAnswer((_) async => const Success(null));

      authBloc.add(LoginWithGoogle());

      await expectLater(
        authBloc.stream,
        emitsInOrder([
          isA<AuthLoading>(),
          isA<AuthError>().having((s) => s.message, 'message', contains('Google login cancelled or failed.')),
        ]),
      );
    });

    test('Emite [AuthLoading, AuthError] cuando LoginWithGoogle lanza Failure', () async {
      when(() => mockAuthRepository.signInWithGoogle())
          .thenAnswer((_) async => const Failure('Google Sign In Error'));

      authBloc.add(LoginWithGoogle());

      await expectLater(
        authBloc.stream,
        emitsInOrder([
          isA<AuthLoading>(),
          isA<AuthError>().having((s) => s.message, 'message', contains('Google Sign In Error')),
        ]),
      );
    });

    test('Emite [AuthLoading, Unauthenticated] cuando se despacha LogoutRequested', () async {
      when(() => mockAuthRepository.signOut()).thenAnswer((_) async => const Success(null));

      authBloc.add(LogoutRequested());

      await expectLater(
        authBloc.stream,
        emitsInOrder([
          isA<AuthLoading>(),
          isA<Unauthenticated>(),
        ]),
      );
    });
  });
}
