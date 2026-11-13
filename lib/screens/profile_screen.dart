import 'package:filmer/core/theme/app_colors.dart';
import 'package:filmer/features/room/bloc/room_bloc.dart';
import 'package:filmer/features/room/bloc/room_state.dart';
import 'package:filmer/features/auth/bloc/auth_bloc.dart';
import 'package:filmer/features/auth/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomBloc, RoomState>(
      builder: (context, state) {
        final likedCount = state is RoomSession ? state.likedMovies.length : 0;
        final user = state is RoomSession ? state.currentUser : null;
        final viewCount = (likedCount * 2) + 3; // Mock dynamic data
        final matchCount = state is RoomSession && state.currentRoom?.matchMovieId != null ? 1 : 0;

        return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 24),
                // Avatar & Name
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary, width: 4),
                          image: const DecorationImage(
                            image: NetworkImage("https://i.pravatar.cc/300?u=yo"), // Mock user
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user?.name ?? "Usuario Invitado",
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "@cinéfilo_experto",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Stats Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem("Vistas", viewCount.toString()),
                    Container(height: 40, width: 1, color: Colors.grey.withValues(alpha: 0.3)),
                    _buildStatItem("Matches", matchCount.toString()),
                    Container(height: 40, width: 1, color: Colors.grey.withValues(alpha: 0.3)),
                    _buildStatItem("Guardadas", likedCount.toString()),
                  ],
                ),
                
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),
                
                // Settings Options
                _buildSettingsOption(
                  context, 
                  icon: Icons.tune, 
                  title: "Recalibrar Preferencias", 
                  subtitle: "Vuelve a elegir tus géneros favoritos",
                  onTap: () {
                    // Navigate to Preferences and remove back stack to restart flow logic or just push?
                    // Pushing is fine, user can go back.
                    context.push('/filters'); 
                  }
                ),
                _buildSettingsOption(
                  context, 
                  icon: Icons.notifications_none, 
                  title: "Notificaciones", 
                  subtitle: "Gestor de alertas",
                  onTap: () {},
                ),
                _buildSettingsOption(
                  context, 
                  icon: Icons.language, 
                  title: "Idioma", 
                  subtitle: "Español",
                  onTap: () {},
                ),
                
                 const SizedBox(height: 24),
                 
                 // Logout
                 SizedBox(
                   width: double.infinity,
                   child: OutlinedButton(
                     style: OutlinedButton.styleFrom(
                       foregroundColor: Colors.grey,
                       side: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
                       padding: const EdgeInsets.symmetric(vertical: 16),
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                     ),
                     onPressed: () {
                       context.read<AuthBloc>().add(LogoutRequested());
                       context.go('/');
                     },
                     child: const Text("Cerrar Sesión"),
                   ),
                 ),

                 const SizedBox(height: 12),

                 // Delete Account (Google Play Requirement)
                 SizedBox(
                   width: double.infinity,
                   child: TextButton.icon(
                     style: TextButton.styleFrom(
                       foregroundColor: Colors.red.shade400,
                       padding: const EdgeInsets.symmetric(vertical: 12),
                     ),
                     onPressed: () => _confirmDeleteAccount(context),
                     icon: const Icon(Icons.delete_forever, size: 18),
                     label: const Text("Eliminar cuenta y datos personales"),
                   ),
                 ),

                 const SizedBox(height: 24),

                 // TMDB Attribution (Mandatory API Requirement)
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                   child: Text(
                     'Este producto utiliza la API de TMDB pero no está respaldado ni certificado por TMDB.',
                     textAlign: TextAlign.center,
                     style: TextStyle(
                       color: Colors.grey.withValues(alpha: 0.5),
                       fontSize: 11,
                     ),
                   ),
                 ),
                 const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
      },
    );
  }

  void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('¿Eliminar cuenta permanentemente?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Esta acción es irreversible y eliminará tu perfil, listas y datos guardados de acuerdo con nuestras políticas de privacidad.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthBloc>().add(DeleteAccountRequested());
              context.go('/');
            },
            child: const Text('Eliminar definitivamente', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildSettingsOption(
    BuildContext context, {
    required IconData icon, 
    required String title, 
    required String subtitle,
    required VoidCallback onTap
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Theme.of(context).iconTheme.color),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
    );
  }
}

