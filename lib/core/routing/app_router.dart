import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:filmer/screens/home_screen.dart';
import 'package:filmer/screens/create_room_screen.dart';
import 'package:filmer/screens/join_room_screen.dart';
import 'package:filmer/screens/lobby_screen.dart';
import 'package:filmer/screens/preferences_screen.dart';
import 'package:filmer/screens/discovery_screen.dart';
import 'package:filmer/screens/intro_screen.dart';
import 'package:filmer/screens/welcome_screen.dart';
import 'package:filmer/screens/login_screen.dart';
import 'package:filmer/screens/match_screen.dart';
import 'package:filmer/main.dart'; // For InitialLinkHandler

final appRouter = GoRouter(
  initialLocation: '/',
  observers: [
    if (Firebase.apps.isNotEmpty)
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
  ],
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const IntroScreen(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const InitialLinkHandler(child: WelcomeScreen()),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/create_room',
      builder: (context, state) => const CreateRoomScreen(),
    ),
    GoRoute(
      path: '/join_room',
      builder: (context, state) => const JoinRoomScreen(),
    ),
    GoRoute(
      path: '/lobby',
      builder: (context, state) => const LobbyScreen(),
    ),
    GoRoute(
      path: '/filters',
      builder: (context, state) => const PreferencesScreen(),
    ),
    GoRoute(
      path: '/discovery',
      builder: (context, state) => const DiscoveryScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/match',
      builder: (context, state) => const MatchScreen(),
    ),
  ],
);
