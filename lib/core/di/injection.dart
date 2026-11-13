import 'package:get_it/get_it.dart';
import 'package:filmer/services/auth_service.dart';
import 'package:filmer/services/movie_service.dart';
import 'package:filmer/services/firestore_service.dart';
import 'package:filmer/services/ad_service.dart';
import 'package:filmer/domain/repositories/movie_repository.dart';
import 'package:filmer/domain/repositories/auth_repository.dart';
import 'package:filmer/domain/repositories/room_repository.dart';
import 'package:filmer/features/auth/bloc/auth_bloc.dart';
import 'package:filmer/features/room/bloc/room_bloc.dart';

final getIt = GetIt.instance;

void setupInjection() {
  // Services
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<FirestoreService>(() => FirestoreService());
  getIt.registerLazySingleton<MovieService>(() => MovieService());
  getIt.registerLazySingleton<AdService>(() => AdService());

  // Repositories
  getIt.registerLazySingleton<MovieRepository>(() => MovieRepositoryImpl(getIt<MovieService>()));
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(getIt<AuthService>()));
  getIt.registerLazySingleton<RoomRepository>(() => RoomRepositoryImpl(getIt<FirestoreService>()));

  // BLoCs
  getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt<AuthRepository>()));
  getIt.registerFactory<RoomBloc>(() => RoomBloc(getIt<RoomRepository>(), getIt<MovieRepository>()));
}
