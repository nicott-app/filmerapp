import 'package:filmer/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.movie_filter_outlined, size: 32),
                const SizedBox(width: 8),
                Text(
                  'CINESWIPE',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                ),
              ],
            ),
            
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Card Deck
                      SizedBox(
                        height: 320,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Left Card
                            Positioned(
                              left: 0,
                              right: 220, // Push to left
                              bottom: 20,
                              top: 40,
                              child: Transform.rotate(
                                angle: -0.05,
                                child: _buildImageCard(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuAlvcA-LTE07g6N3BJsT62VgQ_R4voxd1BxiplEaImyba2nY44653gNsniv3aDwXorDRR2DOs8jPWl2LVXOCc2JXa_hPtlMG3YEGBNfaV_Hy4TS-0FSSFRVgbdRQa2i706V8lpNHNeWq9OdlMjXj4ye-qOQvdRLck26aSOtSqCUVztDhriu5XeNSTnkZjGvDUj8qwVdOkCD5yOYk4pYRYdlG6Tn4aCLN30ro01eq-tvvDbvQwbhbb83p4h1-9Rvarw9X1-jcpTeHr0',
                                  opacity: 0.8,
                                  scale: 0.9,
                                ),
                              ),
                            ),
                             // Right Card
                            Positioned(
                              right: 0,
                              left: 220, // Push to right
                              bottom: 20,
                              top: 40,
                              child: Transform.rotate(
                                angle: 0.05,
                                child: _buildImageCard(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCWpZU1-N96YTbHooGn_KNoLlgUqcCpiLmmFKKEA8ekQoYdWnOt7f3Ks_7akpW-gMvGiZWnX-qlCiJbpzqXQnSOMtDmdftpGBPMLdOU-gNIjOs3DSZLxLG3Uf8qoth5p2jQC15g4_i7mYcr6jke0wDKcJyGw4TVBMnsxjl2KaIJU9ClujsscHV_X4ooyOj7O6KXsGhSWg52V0tZ3pbRIef5Xy9a7ufqoHn00QMVS5lJrY7xjyZiyBuHwDVdE1DVbcr9NNc02Detmf8',
                                  opacity: 0.8,
                                  scale: 0.9,
                                ),
                              ),
                            ),
                            // Center Card
                            SizedBox(
                              width: 200,
                              child: _buildImageCard(
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuAbNUbn5vp2c5SkYcwUDM7BMVKLuaGosXahCJKKNWd9rkzxKftVqd9-SucTjCynNsmIyMMsjBiP3QwoGyv2JufuHKYbnrW-Dgi3NP0cMVOwVjNjhcZcHhUW46JK2ZhpmpesmhiMOzvsc20lFob-E3LeY70BYKV6u_V-oLniImzSDDDym1Zo6DX9ZkWaHL3bueXjaX9luK8x_019rzgGRm3gqoffjkIoID9zbWRyPahCXtSz1jBrEB_fYfzL2Txb_ypSJ2X1oocVjxE',
                                isCenter: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(width: 24, height: 8, decoration: BoxDecoration(color: Theme.of(context).colorScheme.onSurface, borderRadius: BorderRadius.circular(4))),
                          const SizedBox(width: 8),
                          Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(4))),
                          const SizedBox(width: 8),
                          Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(4))),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Text
                      Text(
                        'Deja de hacer scroll.\nComienza a ver.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Desliza a la derecha en las películas que amas. Nosotros haremos el resto y encontraremos tu match perfecto.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Footer
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        context.push('/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textLight,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Comenzar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                         // Navigate to Login
                         context.push('/login');
                    },
                    child: Text(
                      'Ya tengo una cuenta',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard(String url, {double opacity = 1.0, double scale = 1.0, bool isCenter = false}) {
    return Transform.scale(
      scale: scale,
      child: Opacity(
        opacity: opacity,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              if (isCenter)
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
               BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                Image.network(
                  url,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(color: Colors.grey[300]);
                  },
                  errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey),
                ),
                if (isCenter)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                        ),
                        child: const Icon(Icons.favorite, color: AppColors.primary),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

