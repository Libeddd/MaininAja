import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/app/app_routes.dart';
import 'package:frontend/data/models/game_model.dart';

class GameCard extends StatelessWidget {
  final GameModel game;
  const GameCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigasi tetap berfungsi
        context.push('${AppRoutes.detail}/${game.id}');
      },
      // Kita gunakan ClipRRect agar gambar memiliki sudut tumpul (rounded)
      // persis seperti di gambar referensi
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0), // Atur radius
        child: CachedNetworkImage(
          imageUrl: game.backgroundImage,
          fit: BoxFit.cover, // Wajib agar gambar memenuhi kartu
          width: double.infinity,
          height: double.infinity,
          
          // Placeholder saat loading
          placeholder: (context, url) => Container(
            color: Colors.grey[900],
            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          
          // Tampilan jika gambar gagal dimuat
          errorWidget: (context, url, error) => Container(
             color: Colors.grey[900],
             child: const Center(child: Icon(Icons.image_not_supported)),
          ),
        ),
      ),
    );
  }
}