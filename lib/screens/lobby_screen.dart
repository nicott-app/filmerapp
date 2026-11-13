import 'package:filmer/core/theme/app_colors.dart';
import 'package:filmer/features/room/bloc/room_bloc.dart';
import 'package:filmer/features/room/bloc/room_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

class LobbyScreen extends StatelessWidget {
  const LobbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomBloc, RoomState>(
      builder: (context, state) {
        final room = state is RoomSession ? state.currentRoom : null;
        final participants = state is RoomSession ? state.participants : [];
        
        if (room == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Sala de Espera'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: AppColors.primary),
                  const SizedBox(height: 24),
                  const Text('Conectando a la sala...', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
                  )
                ],
              ),
            ),
          );
        }

        return Scaffold(
      appBar: AppBar(
        title: const Text('Sala de Espera'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
             // Not explicitly handled leaveRoom in RoomBloc yet, skipping for UI
             context.pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Code Display
            Text(
              'CÓDIGO DE SALA',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 2, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Adjusted padding
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                   Text(
                    room.code,
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, letterSpacing: 8),
                  ),
                  const SizedBox(width: 16),
                   IconButton(
                    icon: const Icon(Icons.share, color: AppColors.primary),
                    onPressed: () {
                       Share.share('Únete a mi sala en Filmer: https://filmer.app/join?code=${room.code}');
                    },
                   ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Comparte este código con tus amigos',
              style: TextStyle(color: Colors.grey),
            ),
            
            const SizedBox(height: 48),
            
            // Participants List
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: participants.length,
                itemBuilder: (context, index) {
                  final user = participants[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey.shade200,
                          child: Text(
                            user.name[0].toUpperCase(),
                            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        if (user.id == room.hostId) ...[
                          const SizedBox(height: 8),
                          Container(
                             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                             decoration: BoxDecoration(
                               color: AppColors.primary.withValues(alpha: 0.2),
                               borderRadius: BorderRadius.circular(4),
                             ),
                             child: const Text('Anfitrión', style: TextStyle(fontSize: 10, color: Colors.amber)),
                          )
                        ]
                      ],
                    ),
                  );
                },
              ),
            ),
            
            // Start Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                   context.push('/filters');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textLight,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 4,
                ),
                child: const Text('Comenzar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
      },
    );
  }
}

