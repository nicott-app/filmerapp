import 'dart:io';
import 'package:filmer/core/theme/app_colors.dart';
import 'package:filmer/features/auth/bloc/auth_bloc.dart';
import 'package:filmer/features/auth/bloc/auth_event.dart';
import 'package:filmer/features/auth/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void _handleSocialLogin(String provider) {
    if (provider == 'google') {
      context.read<AuthBloc>().add(LoginWithGoogle());
    } else {
      context.read<AuthBloc>().add(LoginWithApple());
    }
  }

  void _handleGuestLogin() {
    context.read<AuthBloc>().add(const LoginAsGuest('Invitado'));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          context.go('/home');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          return Scaffold(
            body: Stack(
              children: [
                _buildContent(context),
                if (isLoading)
                  Container(
                    color: Colors.black.withValues(alpha: 0.5),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
      return Column(
        children: [
          // Hero Section
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(48),
                    bottomRight: Radius.circular(48),
                  ),
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBbwxahIKRdb4vsUiy26D5ZU-W_uk5xMDBg3V_MUGIm36LOq6RDCOrlTmrBHVoG6AUCS-bSetmrFVRsXqaLn9ikihirUsyPGWqHpb3K2PHPYmL1tSJuENLL_zM3x2qsGBYX2Rt3ccd3uZa8TacEDPOhiuMnoIq59azS87XPsmMtrE-1SF1UgHcQAlZknbk_ahemiDLoUL4Xl95YrsCUXQgtt7qSPxo6uNArrtWFPr-ClovlJIsa32SYYlcwtDh9cYCQBgPfnZHt2Mc',
                    fit: BoxFit.cover,
                  ),
                ),
                // Gradient Overlay
                Positioned.fill(
                  child: Container(
                     decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(48),
                        bottomRight: Radius.circular(48),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.3),
                        ],
                      ),
                    ),
                  ),
                ),
                // Floating Logo
                Positioned(
                  bottom: -20, // Half sticking out
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.movie_filter_outlined, size: 40, color: AppColors.primary),
                    ),
                  ),
                ),
                

              ],
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
              child: Column(
                children: [
                  // Text
                  const SizedBox(height: 16),
                  Text(
                    'MovieMatch',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 32),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Deja de hacer scroll. Comienza a ver.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Buttons
                  if (Platform.isIOS)
                    _buildSocialButton(
                      context,
                      label: 'Continuar con Apple',
                      icon: Icons.apple, // Using material icon for simplicity
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      isDark: true, // For border handling
                      onTap: () => _handleSocialLogin('apple'),
                    ),
                  const SizedBox(height: 12),
                  _buildSocialButton(
                    context,
                    label: 'Continuar con Google',
                    icon: Icons.g_mobiledata, // Fallback
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    textColor: Theme.of(context).colorScheme.onSurface,
                    showBorder: true,
                    onTap: () => _handleSocialLogin('google'),
                  ),
                  
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'O',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: _handleGuestLogin,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.onSurface,
                        side: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: Row(
                        children: const [
                          SizedBox(width: 16),
                          Icon(Icons.person_outline),
                          Expanded(
                            child: Text(
                              'Continuar como Invitado',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(width: 40),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  // Footer Links
                  Text.rich(
                    TextSpan(
                      text: '¿Ya tienes una cuenta? ',
                      children: [
                        TextSpan(
                          text: 'Inicia sesión',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Términos',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(width: 8),
                      const Text('•', style: TextStyle(color: Colors.grey)),
                      const SizedBox(width: 8),
                      Text(
                        'Privacidad',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      );
  }

  Widget _buildSocialButton(BuildContext context, {
    required String label,
    required IconData icon,
    required Color backgroundColor,
    required Color textColor,
    bool showBorder = false,
    bool isDark = false,
    required VoidCallback onTap,
  }) {
    // Handle Apple button specific style for light/dark mode if needed
    if (label.contains('Apple') && Theme.of(context).brightness == Brightness.dark) {
       backgroundColor = Colors.white;
       textColor = Colors.black;
    }

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: showBorder ? BorderSide(color: Colors.grey.shade300) : BorderSide.none,
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(icon, size: 24),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 40), 
          ],
        ),
      ),
    );
  }
}

