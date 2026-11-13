import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:filmer/domain/repositories/room_repository.dart';
import 'package:filmer/domain/repositories/movie_repository.dart';
import 'package:filmer/core/utils/result.dart';
import 'package:filmer/models/user.dart';
import 'package:filmer/models/movie.dart';
import 'package:filmer/features/room/bloc/room_bloc.dart';
import 'package:filmer/features/room/bloc/room_event.dart';
import 'package:filmer/features/room/bloc/room_state.dart';

class MockRoomRepository extends Mock implements RoomRepository {}
class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late MockRoomRepository mockRoomRepository;
  late MockMovieRepository mockMovieRepository;
  late RoomBloc roomBloc;
  
  final mockUser = const User(id: '123', name: 'Tester');
  final mockMovies = [
    Movie(id: 1, title: 'Inception', year: '2010', duration: '2h', rating: 8.8, genres: ['Action'], imageUrl: '', platforms: [], synopsis: 'Dream'),
  ];

  setUp(() {
    mockRoomRepository = MockRoomRepository();
    mockMovieRepository = MockMovieRepository();
    roomBloc = RoomBloc(mockRoomRepository, mockMovieRepository);
  });

  tearDown(() {
    roomBloc.close();
  });

  group('RoomBloc', () {
    test('El estado inicial debe ser RoomInitial', () {
      expect(roomBloc.state, isA<RoomInitial>());
    });

    test('Emite [RoomLoading, RoomSession] al despachar InitializeRoomSession exitosamente', () async {
      when(() => mockMovieRepository.getPopularMovies())
          .thenAnswer((_) async => Success(mockMovies));

      roomBloc.add(InitializeRoomSession(mockUser));

      await expectLater(
        roomBloc.stream,
        emitsInOrder([
          isA<RoomLoading>(),
          isA<RoomSession>()
              .having((s) => s.currentUser.id, 'userId', '123')
              .having((s) => s.movies.length, 'movies.length', 1),
        ]),
      );
    });

    test('Emite [RoomLoading, RoomError] cuando getPopularMovies falla', () async {
      when(() => mockMovieRepository.getPopularMovies())
          .thenAnswer((_) async => const Failure('Network error'));

      roomBloc.add(InitializeRoomSession(mockUser));

      await expectLater(
        roomBloc.stream,
        emitsInOrder([
          isA<RoomLoading>(),
          isA<RoomError>().having((s) => s.message, 'message', 'Failed to load movies'),
        ]),
      );
    });
  });
}
