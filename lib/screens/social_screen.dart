import 'dart:ui';
import 'package:filmer/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Social',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                
                // Amigos en línea
                Text(
                  'Amigos en línea',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                       _buildFriendAvatar("Sofia", "https://i.pravatar.cc/150?u=sofia", true),
                       _buildFriendAvatar("Mateo", "https://i.pravatar.cc/150?u=mateo", true),
                       _buildFriendAvatar("Lucia", "https://i.pravatar.cc/150?u=lucia", false),
                       _buildFriendAvatar("Diego", "https://i.pravatar.cc/150?u=diego", false),
                       _buildAddFriendButton(context),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Actividad Reciente
                Text(
                  'Actividad Reciente',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                _buildActivityItem(
                  context,
                  "Sofia",
                  "hizo match en",
                  "Inception",
                  "https://i.pravatar.cc/150?u=sofia",
                  "5 min",
                ),
                _buildActivityItem(
                  context,
                  "Mateo",
                  "guardó",
                  "Dune: Parte Dos",
                  "https://i.pravatar.cc/150?u=mateo",
                  "2h",
                ),
                 _buildActivityItem(
                  context,
                  "Lucia",
                  "vio",
                  "Stranger Things",
                  "https://i.pravatar.cc/150?u=lucia",
                  "1d",
                ),
                _buildActivityItem(
                  context,
                  "Diego",
                  "comenzó a seguirte",
                  "",
                  "https://i.pravatar.cc/150?u=diego",
                  "2d",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFriendAvatar(String name, String imageUrl, bool isOnline) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(imageUrl),
              ),
              if (isOnline)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildAddFriendButton(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.withValues(alpha: 0.3), style: BorderStyle.solid),
          ),
          child: const Icon(Icons.add, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        const Text("Invitar", style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildActivityItem(BuildContext context, String user, String action, String target, String imageUrl, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(imageUrl),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                      children: [
                        TextSpan(text: user, style: const TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: " $action "),
                        if (target.isNotEmpty)
                          TextSpan(text: target, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                      ],
                    ),
                  ),
                ),
                Text(time, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

