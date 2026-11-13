import 'package:filmer/screens/lists_screen.dart';
import 'package:filmer/screens/social_screen.dart';
import 'package:filmer/screens/profile_screen.dart';
import 'package:filmer/core/theme/app_colors.dart';
import 'package:filmer/models/filter_options.dart';
import 'package:filmer/widgets/filter_sheet.dart';
import 'package:filmer/models/movie.dart';
import 'package:filmer/widgets/movie_card.dart';
import 'package:filmer/widgets/native_ad_card.dart'; // Import
import 'package:filmer/features/room/bloc/room_bloc.dart';
import 'package:filmer/features/room/bloc/room_event.dart';
import 'package:filmer/features/room/bloc/room_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:filmer/models/user.dart';
import 'package:filmer/features/auth/bloc/auth_bloc.dart';
import 'package:filmer/features/auth/bloc/auth_state.dart';
import 'package:filmer/services/ad_service.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  final CardSwiperController controller = CardSwiperController();

  int _selectedNavIndex = 0; // Navigation state
  FilterOptions _filterOptions = const FilterOptions();
  int? _lastShownMatchId;
  
  @override
  void initState() {
    super.initState();
  }

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      // With go_router we would pass state.extra, but we'll mock it for now
      _initialized = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }




  void _showFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterSheet(
        currentFilters: _filterOptions,
        onApply: (newOptions) {
          setState(() {
            _filterOptions = newOptions;
            // Reset swiper or handle empty state if needed
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoomBloc, RoomState>(
      listener: (context, state) {
         if (state is RoomSession && state.currentRoom?.matchMovieId != null) {
            final movieId = state.currentRoom!.matchMovieId;
            if (_lastShownMatchId == movieId) return;
            
            _lastShownMatchId = movieId;
            
            final idx = state.movies.indexWhere((m) => m.id == movieId);
            if (idx != -1) {
               final movie = state.movies[idx];
               showDialog(
                 context: context,
                 builder: (ctx) => AlertDialog(
                   backgroundColor: Colors.grey[900],
                   title: const Text("¡Elegida por Mayoría!", style: TextStyle(color: Colors.white)),
                   content: Text(
                     "La mayoría ha votado por ${movie.title}. ¿Ir a ver el Match?",
                     style: const TextStyle(color: Colors.white70),
                   ),
                   actions: [
                     TextButton(
                       onPressed: () => Navigator.pop(ctx),
                       child: const Text("Seguir deslizando", style: TextStyle(color: Colors.grey)),
                     ),
                     ElevatedButton(
                       style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                       onPressed: () {
                         Navigator.pop(ctx);
                         context.go('/match');
                       },
                       child: const Text("¡Ver Match!", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                     ),
                   ],
                 ),
               );
            }
         }
      },
      child: BlocBuilder<RoomBloc, RoomState>(
        builder: (context, state) {
          if (state is RoomLoading) {
             return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (state is RoomSession) {
             return _buildMainScaffold(context, state);
          }
          final errorMsg = state is RoomError ? state.message : "No se pudieron cargar las películas";
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      errorMsg,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {
                        final authState = context.read<AuthBloc>().state;
                        final user = authState is Authenticated ? authState.user : const User(id: 'guest', name: 'Invitado');
                        context.read<RoomBloc>().add(InitializeRoomSession(user));
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => context.go('/home'),
                      child: const Text('Volver al inicio', style: TextStyle(color: Colors.grey)),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainScaffold(BuildContext context, RoomSession state) {
    return Scaffold(
      body: _buildBody(state),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
          border: Border(top: BorderSide(color: Colors.grey.withValues(alpha: 0.1))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.style, 'Descubrir', 0),
            _buildNavItem(Icons.format_list_bulleted, 'Listas', 1),
            _buildNavItem(Icons.group, 'Social', 2),
            _buildNavItem(Icons.account_circle, 'Perfil', 3),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(RoomSession state) {
    switch (_selectedNavIndex) {
      case 0:
        return _buildDiscoveryView(state);
      case 1:
        return const ListsScreen();
      case 2:
        return const SocialScreen();
      case 3:
        return const ProfileScreen();
      default:
        return _buildDiscoveryView(state);
    }
  }

  Widget _buildDiscoveryView(RoomSession state) {
    final allMovies = state.movies;
    
    List<Movie> getFilteredMovies() {
       List<Movie> movies = allMovies.where((movie) {
         // simplified for diff
         return true; 
       }).toList();
       return movies;
    }
    
    final filteredMovies = getFilteredMovies();
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildHeaderButton(Icons.arrow_back, () {
                    // Return to Preferences / Genres
                    context.pop();
                  }),
                  Column(
                    children: [
                      Text('DESCUBRIENDO', style: TextStyle(fontSize: 10, letterSpacing: 1.5, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5), fontWeight: FontWeight.bold)),
                      const Text('Para ti', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  _buildHeaderButton(Icons.tune, _showFilters),
                ],
              ),
            ),
            
            // Card Stack
            Expanded(
              child: Stack(
                children: [
                   // Decorative Background
                   Positioned(
                    top: 24,
                    left: 32,
                    right: 32,
                    bottom: 100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                   ),
                  
                  if (filteredMovies.isEmpty)
                    const Center(child: Text("No hay resultados para estos filtros", style: TextStyle(color: Colors.white))),
                  if (filteredMovies.isNotEmpty)
                    CardSwiper(
                      controller: controller,
                      cardsCount: filteredMovies.length,
                      onSwipe: _onSwipe,
                      onUndo: _onUndo,
                      numberOfCardsDisplayed: filteredMovies.length < 3 ? filteredMovies.length : 3, // Prevent invalid count error
                      backCardOffset: const Offset(0, 40),
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 100), // Leave space for FABs bottom
                      cardBuilder: (context, index, horizontalOffsetPercentage, verticalOffsetPercentage) {
                        final item = filteredMovies[index];
                        if (item.id == -1) {
                           return const NativeAdCard();
                        }
                        return MovieCard(movie: item);
                      },
                    ),
                  
                  // FABs
                  Positioned(
                    bottom: 30, // Adjust overlap
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Undo Button (Rewarded)
                        _buildSmallActionButton(Icons.refresh, Colors.orange, () {
                           showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                backgroundColor: Colors.grey[900],
                                title: const Text("¿Deshacer acción?", style: TextStyle(color: Colors.white)),
                                content: const Text(
                                  "Mira un video corto para recuperar la carta anterior.",
                                  style: TextStyle(color: Colors.white70),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                      // Show Ad
                                      AdService().showRewardedAd(
                                        onUserEarnedReward: () {
                                            controller.undo();
                                        },
                                      );
                                    },
                                    child: const Text("Ver Video"),
                                  ),
                                ],
                              ),
                           );
                        }),
                        const SizedBox(width: 16),
                        
                        _buildActionButton(Icons.close, Colors.red, () {
                           if (filteredMovies.isNotEmpty) controller.swipe(CardSwiperDirection.left);
                        }),
                        const SizedBox(width: 16),
                        
                        _buildSuperLikeButton(Icons.bookmark, AppColors.primary, () {
                           // SuperLike Action or just Bookmark
                        }),
                        
                        const SizedBox(width: 16),
                        _buildActionButton(Icons.favorite, Colors.green, () {
                           if (filteredMovies.isNotEmpty) controller.swipe(CardSwiperDirection.right);
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
             const SizedBox(height: 16), // Home Indicator safe area
        ],
      ),
    );
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint(
      'The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top',
    );
    
    setState(() {
      
    });

    try {
      final state = context.read<RoomBloc>().state;
      if (state is RoomSession && previousIndex >= 0 && previousIndex < state.movies.length) {
        final movie = state.movies[previousIndex];
        if (movie.id != -1) {
          if (direction == CardSwiperDirection.right) {
            context.read<RoomBloc>().add(VoteMovieRequested(movie.id, true, movie));
          } else if (direction == CardSwiperDirection.left) {
            context.read<RoomBloc>().add(VoteMovieRequested(movie.id, false, movie));
          }
        }
      }
    } catch (e) {
      debugPrint("Error voting (ignored to keep UI alive): $e");
    }
    
    return true;
  }

  bool _onUndo(
    int? previousIndex,
    int currentIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint(
      'The card $currentIndex was undod from the ${direction.name}',
    );
    setState(() {
      
    });
    return true;
  }

  Widget _buildHeaderButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          shape: BoxShape.circle,
           boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Icon(icon, color: Theme.of(context).iconTheme.color, size: 20),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 32),
      ),
    );
  }
  
    Widget _buildSmallActionButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  Widget _buildSuperLikeButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(icon, color: Colors.black, size: 36),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = _selectedNavIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedNavIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary.withValues(alpha: 0.2) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isActive ? Colors.black : Colors.grey,
                  size: 24,
                ),
              ),
               if (isActive)
                Container(
                  width: 10,
                  height: 10,
                   decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 2),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.black : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

