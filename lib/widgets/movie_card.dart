import 'package:filmer/core/theme/app_colors.dart';
import 'package:filmer/models/movie.dart';
import 'package:filmer/screens/movie_detail_screen.dart'; // Import
import 'package:filmer/services/ad_service.dart';
import 'package:flutter/material.dart';
import 'package:filmer/core/di/injection.dart';

class MovieCard extends StatefulWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to details
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MovieDetailScreen(movie: widget.movie)),
        );
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image
          _buildImage(),

          // Gradient Overlay
          _buildGradient(),

          // Content
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Platforms
                  _buildPlatforms(),
                  const SizedBox(height: 12),

                  // Title
                  _buildTitle(),
                  const SizedBox(height: 8),

                  // Meta Info
                  _buildMetaInfo(),
                  const SizedBox(height: 12),

                  // Synopsis
                  _buildSynopsis(),
                  const SizedBox(height: 12),

                  // Genres
                  _buildGenres(),
                  const SizedBox(height: 80), // Space for FABs
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Positioned.fill(
      child: Image.network(
        widget.movie.imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(color: Colors.grey[900]);
        },
      ),
    );
  }

  Widget _buildGradient() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.1),
              Colors.black.withValues(alpha: 0.8),
              Colors.black,
            ],
            stops: const [0.0, 0.5, 0.8, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildPlatforms() {
    return Row(
      children: widget.movie.platforms.map((p) => _buildPlatformIcon(p)).toList(),
    );
  }

  Widget _buildTitle() {
    return Text(
      widget.movie.title,
      style: const TextStyle(
        fontFamily: 'Spline Sans',
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        height: 1.1,
      ),
    );
  }

  Widget _buildMetaInfo() {
    return Row(
      children: [
        Text(widget.movie.year, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        const CircleAvatar(radius: 2, backgroundColor: AppColors.primary),
        const SizedBox(width: 8),
        Text(widget.movie.duration, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        const CircleAvatar(radius: 2, backgroundColor: AppColors.primary),
        const SizedBox(width: 8),
        const Icon(Icons.star, color: AppColors.primary, size: 16),
        const SizedBox(width: 4),
        Text(widget.movie.rating.toString(), style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSynopsis() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: AnimatedCrossFade(
        firstChild: Text(
          widget.movie.synopsis,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 12,
            height: 1.4,
          ),
        ),
        secondChild: Text(
          widget.movie.synopsis,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 12,
            height: 1.4,
          ),
        ),
        crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 200),
      ),
    );
  }

  Widget _buildGenres() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Genres List
        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.movie.genres.take(3).map((g) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Text(g, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
            )).toList(),
          ),
        ),
        
        // Spy Mode Button
        _buildSpyButton(),
      ],
    );
  }

  Widget _buildSpyButton() {
    return GestureDetector(
      onTap: _activateSpyMode,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
           color: Colors.purple.withValues(alpha: 0.3),
           shape: BoxShape.circle,
           border: Border.all(color: Colors.purpleAccent),
        ),
        child: const Icon(Icons.visibility, color: Colors.purpleAccent, size: 24),
      ),
    );
  }

  void _activateSpyMode() {

    // Check local "cheat" knowledge (requires RoomBloc to expose votes, pushing limits of this mock)
    // For specific "who liked what", we'd need to query Firestore or have RoomBloc expose it.
    // Let's assume RoomBloc has a method `doesAnyoneElseLike(movieId)`.
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text("Modo Espía 🕵️", style: TextStyle(color: Colors.white)),
        content: const Text(
          "¿Quieres saber si alguien de tu sala ya le dio LIKE a esta peli?\nVer 1 anuncio para descubrirlo.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
             onPressed: () => Navigator.pop(ctx),
             child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            onPressed: () {
              Navigator.pop(ctx);
              getIt<AdService>().showRewardedAd(
                onUserEarnedReward: () {
                   _revealSpyResult();
                },
              );
            },
            child: const Text("Ver Anuncio"),
          ),
        ],
      ),
    );
  }

  void _revealSpyResult() {
     // Mock logic for demo purposes (as RoomProvider real implementation is complex)
     // In real app: final likes = roomProvider.getLikers(widget.movie.id);
     
     // 50/50 Chance for demo excitement
     final bool mockedLike = DateTime.now().second % 2 == 0;
     
     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            mockedLike 
              ? "¡SÍ! Alguien ya le dio like ❤️" 
              : "Nadie le ha dado like todavía... 🤫",
            style: const TextStyle(fontSize: 16),
          ),
          backgroundColor: mockedLike ? Colors.green : Colors.grey,
          duration: const Duration(seconds: 4),
        ),
     );
  }

  Widget _buildPlatformIcon(String platform) {
    Color color = Colors.grey;
    String label = platform[0];
    
    if (platform == 'Netflix') color = const Color(0xFFE50914);
    if (platform == 'HBO') color = const Color(0xFF003893); // HBO Blue
    if (platform == 'Prime') color = const Color(0xFF00A8E1);
    if (platform == 'Max') color = Colors.purple;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

