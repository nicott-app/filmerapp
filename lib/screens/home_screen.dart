import 'package:flutter/material.dart';
import 'package:filmer/core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:filmer/features/auth/bloc/auth_bloc.dart';
import 'package:filmer/features/auth/bloc/auth_state.dart';
import 'package:filmer/features/room/bloc/room_bloc.dart';
import 'package:filmer/features/room/bloc/room_event.dart';
import 'package:filmer/models/user.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 48),
              Text(
                '¿Cómo quieres ver hoy?',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 32),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Elige tu modo para descubrir películas.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              
              const Spacer(),
              
              _buildModeCard(
                context,
                title: 'Jugar Solo',
                description: 'Descubre películas para tu propia lista.',
                icon: Icons.person_outline,
                color: Colors.blueAccent,
                onTap: () {
                  final authState = context.read<AuthBloc>().state;
                  final user = authState is Authenticated ? authState.user : const User(id: 'guest', name: 'Invitado');
                  context.read<RoomBloc>().add(InitializeRoomSession(user));
                  context.push('/filters');
                },
              ),
              
              const SizedBox(height: 24),
              
              _buildModeCard(
                context,
                title: 'Crear Sala',
                description: 'Invita amigos y encuentren una película juntos.',
                icon: Icons.group_add_outlined,
                color: AppColors.primary,
                textColor: Colors.black,
                onTap: () async {
                  try {
                    final authState = context.read<AuthBloc>().state;
                    final user = authState is Authenticated ? authState.user : const User(id: 'host', name: 'Yo');
                    context.read<RoomBloc>().add(InitializeRoomSession(user));
                    context.read<RoomBloc>().add(CreateRoomRequested());
                    
                    if (context.mounted) {
                      context.push('/lobby');
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error al crear sala: $e')),
                      );
                    }
                  }
                },
              ),
               
              const SizedBox(height: 24),
              
              _buildModeCard(
                context,
                title: 'Unirse a Sala',
                description: 'Ingresa un código para unirte a tus amigos.',
                icon: Icons.input,
                color: Colors.purpleAccent,
                onTap: () {
                   context.push('/join_room');
                },
              ),
              
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    Color textColor = Colors.white,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(color: Colors.grey.withValues(alpha: 0.8), fontSize: 14),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey.withValues(alpha: 0.3), size: 16),
          ],
        ),
      ),
    );
  }
}

