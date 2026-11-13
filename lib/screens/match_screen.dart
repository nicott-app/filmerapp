import 'package:filmer/core/theme/app_colors.dart';
import 'package:filmer/features/room/bloc/room_bloc.dart';
import 'package:filmer/features/room/bloc/room_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:confetti/confetti.dart';
import 'package:filmer/models/movie.dart';
import 'package:filmer/screens/movie_detail_screen.dart';
import 'dart:math';

class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 4));
    _confettiController.play();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomBloc, RoomState>(
      builder: (context, state) {
        Movie? movie;
        if (state is RoomSession) {
          if (state.currentRoom?.matchMovieId != null) {
            final matchId = state.currentRoom!.matchMovieId;
            final matches = state.movies.where((m) => m.id == matchId);
            if (matches.isNotEmpty) {
              movie = matches.first;
            } else if (state.likedMovies.isNotEmpty) {
              movie = state.likedMovies.last;
            }
          } else if (state.likedMovies.isNotEmpty) {
            movie = state.likedMovies.last;
          }
        }

        if (movie == null) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: AppColors.primary),
                  const SizedBox(height: 16),
                  const Text('Sincronizando información del match...', style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.go('/home'),
                    child: const Text('Volver al inicio', style: TextStyle(color: AppColors.primary)),
                  )
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.black, // Cinematic feel
          body: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image with heavy gradient
              Image.network(
                movie.imageUrl,
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.5),
                      Colors.black.withValues(alpha: 0.85),
                      Colors.black,
                    ],
                  ),
                ),
              ),
              
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '¡ES UN MATCH!',
                        style: TextStyle(
                          fontFamily: 'Spline Sans',
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          letterSpacing: 3,
                          shadows: [
                            Shadow(color: AppColors.primary, blurRadius: 15),
                          ],
                        ),
                      ),
                      const SizedBox(height: 48),
                      
                      // Movie Poster with Pulse Animation
                      ScaleTransition(
                        scale: _pulseAnimation,
                        child: Container(
                          width: 220,
                          height: 330,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                               BoxShadow(
                                 color: AppColors.primary.withValues(alpha: 0.4), 
                                 blurRadius: 40, 
                                 spreadRadius: 5,
                                 offset: const Offset(0, 10),
                               ),
                            ]
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(movie.imageUrl, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      Text(
                        movie.title,
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            "${movie.rating} • ${movie.year}", 
                            style: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500)
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      
                      // Watch Now Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                             Navigator.push(
                               context,
                               MaterialPageRoute(builder: (_) => MovieDetailScreen(movie: movie!)),
                             );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.black,
                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                             elevation: 10,
                          ),
                          child: const Text('Ver Detalles y Tráiler 🍿', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                             context.go('/home');
                        },
                        child: const Text('Seguir buscando', style: TextStyle(color: Colors.white60, fontSize: 16)),
                      )
                    ],
                  ),
                ),
              ),

              // Confetti
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirection: pi / 2, // fall straight down
                  maxBlastForce: 6, 
                  minBlastForce: 2, 
                  emissionFrequency: 0.05, 
                  numberOfParticles: 40, 
                  gravity: 0.2,
                  colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple, AppColors.primary],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

