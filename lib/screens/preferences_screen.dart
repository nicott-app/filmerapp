import 'package:filmer/core/theme/app_colors.dart';
import 'package:filmer/models/genre.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:filmer/models/filter_options.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  late List<Genre> _genres;

  @override
  void initState() {
    super.initState();
    _genres = availableGenres.asMap().entries.map((entry) {
      return Genre(
        id: entry.key + 1,
        name: entry.value,
        imageUrl: _getGenreImage(entry.value),
      );
    }).toList();
  }

  String _getGenreImage(String name) {
    String filename;
    switch (name) {
      case "Acción": filename = "action"; break;
      case "Aventura": filename = "adventure"; break;
      case "Comedia": filename = "comedy"; break;
      case "Drama": filename = "drama"; break;
      case "Fantasía": filename = "fantasy"; break;
      case "Terror": filename = "horror"; break;
      case "Sci-Fi": filename = "scifi"; break;
      case "Thriller": filename = "thriller"; break;
      case "Romance": filename = "romance"; break;
      case "Documental": filename = "documentary"; break;
      case "Animación": filename = "animation"; break;
      case "Crimen": filename = "crime"; break;
      case "Misterio": filename = "mystery"; break;
      case "Musical": filename = "musical"; break;
      case "Guerra": filename = "war"; break;
      case "Western": filename = "western"; break;
      case "Familia": filename = "family"; break;
      case "Historia": filename = "history"; break;
      default: filename = "action"; 
    }
    return "assets/images/genres/$filename.png";
  }

  final List<int> _selectedGenreIds = [1, 4]; // Pre-select some

  void _toggleGenre(int id) {
    setState(() {
      if (_selectedGenreIds.contains(id)) {
        _selectedGenreIds.remove(id);
      } else {
        _selectedGenreIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      Text(
                        'Preferencias',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () => context.push('/discovery'),
                        child: Text(
                          'Saltar',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Progress
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: Container(height: 6, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(3)))),
                          const SizedBox(width: 8),
                          Expanded(child: Container(height: 6, decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(3)))),
                           const SizedBox(width: 8),
                          Expanded(child: Container(height: 6, decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(3)))),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'PASO 1 DE 3: GÉNEROS',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          letterSpacing: 1.2,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Content
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
                    children: [
                      Text(
                        'Personaliza tu\nexperiencia',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 32),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Selecciona los géneros que más te interesan para empezar a descubrir.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: _genres.length,
                        itemBuilder: (context, index) {
                          final genre = _genres[index];
                          final isSelected = _selectedGenreIds.contains(genre.id);
                          
                          return GestureDetector(
                            onTap: () => _toggleGenre(genre.id),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: isSelected 
                                  ? Border.all(color: AppColors.primary, width: 4)
                                  : Border.all(color: Colors.transparent, width: 0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12), // Inner radius
                                child: Stack(
                                  children: [
                                    Image.asset(
                                      genre.imageUrl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(color: Colors.grey[800], child: const Icon(Icons.movie, color: Colors.white54));
                                      },
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Colors.black.withValues(alpha: 0.8),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Checkmark
                                    Positioned(
                                      top: 12,
                                      right: 12,
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 300),
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: isSelected ? AppColors.primary : Colors.white.withValues(alpha: 0.3),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          isSelected ? Icons.check : Icons.add,
                                          size: 16,
                                          color: isSelected ? Colors.black : Colors.white,
                                        ),
                                      ),
                                    ),
                                    // Label
                                    Positioned(
                                      bottom: 12,
                                      left: 12,
                                      child: Text(
                                        genre.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 32),
                      // Previews for next steps
                      _buildPreviewHeader('Plataformas'),
                      const SizedBox(height: 16),
                      // Mock platforms row
                      Row(
                        children: [
                          _buildMockPlatform('N', const Color(0xFFE50914)),
                          const SizedBox(width: 16),
                          _buildMockPlatform('D+', const Color(0xFF0063E5)),
                           const SizedBox(width: 16),
                          _buildMockPlatform('P', const Color(0xFF00A8E1)),
                        ],
                      ),
                       const SizedBox(height: 32),
                       _buildPreviewHeader('Favoritos'),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                             color: Theme.of(context).cardColor,
                             borderRadius: BorderRadius.circular(30),
                             border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
                          ),
                          child: Row(
                            children: const [
                               Icon(Icons.search, color: Colors.grey),
                               SizedBox(width: 8),
                               Text('Busca actores o directores...', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ],
            ),
            
              // FAB
            Positioned(
              bottom: 24,
              right: 24,
              child: FloatingActionButton.extended(
                onPressed: () {
                  context.push('/discovery');
                },
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textLight,
                elevation: 4,
                label: Row(
                  children: const [
                    Text('Continuar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ),
            
            // Bottom Gradient
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 48,
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Theme.of(context).scaffoldBackgroundColor,
                        Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text('Próximo', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
        ),
      ],
    );
  }

  Widget _buildMockPlatform(String label, Color color) {
    return Opacity(
      opacity: 0.5,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
          ),
        ],
      ),
    );
  }
}

