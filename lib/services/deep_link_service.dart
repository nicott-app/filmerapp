import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:filmer/features/room/bloc/room_bloc.dart';
import 'package:filmer/features/room/bloc/room_event.dart';
import 'package:filmer/features/room/bloc/room_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DeepLinkService {
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  /// Initializes listeners. Should be called in main or root widget.
  void initDeepLinks(BuildContext context) {
    // Check initial link if app was launched by URL
    _checkInitialLink(context);

    // Listen to stream (while app is in background/foreground)
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      if (!context.mounted) return;
      _handleLink(context, uri);
    });
  }

  Future<void> _checkInitialLink(BuildContext context) async {
    try {
      final uri = await _appLinks.getInitialLink();
      if (uri != null) {
        if (!context.mounted) return;
        _handleLink(context, uri);
      }
    } catch (e) {
      debugPrint("Error checking initial link: $e");
    }
  }

  void _handleLink(BuildContext context, Uri uri) {
    debugPrint("Deep Link Received: $uri");
    
    // Check path or host to determine action
    // Schemes: filmer://join?code=XYZ or https://filmer.app/join?code=XYZ
    if (uri.pathSegments.contains('join') || uri.host == 'join') {
      final code = uri.queryParameters['code'];
      if (code != null) {
        _joinRoomFromLink(context, code);
      }
    }
  }

  void _joinRoomFromLink(BuildContext context, String code) {
    final roomBloc = context.read<RoomBloc>();
    final state = roomBloc.state;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Uniéndose a sala $code...")),
    );

    if (state is RoomSession && state.currentRoom?.code == code) return;

    roomBloc.add(JoinRoomRequested(code));
    // Navigation handled cleanly with GoRouter
    context.go('/lobby');
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}
