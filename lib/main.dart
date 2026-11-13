import 'package:filmer/core/theme/app_theme.dart';


import 'package:filmer/services/ad_service.dart'; // Import
import 'package:filmer/services/deep_link_service.dart';

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';


import 'package:filmer/services/auth_service.dart'; // Import
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import
import 'package:filmer/core/di/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:filmer/features/auth/bloc/auth_bloc.dart';
import 'package:filmer/features/auth/bloc/auth_event.dart';
import 'package:filmer/features/room/bloc/room_bloc.dart';
import 'package:filmer/core/routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  setupInjection();

  // Initialize Firebase / Auth
  final bool firebaseReady = await getIt<AuthService>().initialize();

  if (firebaseReady) {
    // Crashlytics setup
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    // Remote Config setup
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ));
      await remoteConfig.setDefaults(const {
        "min_votes_for_match": 3,
      });
      await remoteConfig.fetchAndActivate();
    } catch (e) {
      debugPrint("Failed to fetch remote config: $e");
    }
  }
  
  // Load environment variables
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Warning: .env file not found. Using default/empty keys.");
  }
  
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => getIt<AuthBloc>()..add(CheckAuthStatus()),
        ),
        BlocProvider<RoomBloc>(
          create: (_) => getIt<RoomBloc>(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _deepLinkService = DeepLinkService();

  @override
  void initState() {
    super.initState();
    // Initialize Ads
    getIt<AdService>().init();
    getIt<AdService>().loadRewardedAd(); // Preload "Spy Mode" ad
  }

  @override
  void dispose() {
    _deepLinkService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Filmer',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}

/// Helper widget to access Context with Providers for DeepLinkService
class InitialLinkHandler extends StatefulWidget {
  final Widget child;
  const InitialLinkHandler({super.key, required this.child});

  @override
  State<InitialLinkHandler> createState() => _InitialLinkHandlerState();
}

class _InitialLinkHandlerState extends State<InitialLinkHandler> {
  @override
  void initState() {
    super.initState();
    DeepLinkService().initDeepLinks(context);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
