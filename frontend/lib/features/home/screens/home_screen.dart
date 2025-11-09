// File: lib/features/home/screens/home_screen.dart (REVISI)

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/home/bloc/home_bloc.dart';
import 'package:frontend/features/home/widgets/game_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Panggil data saat masuk (Biarkan ini, sudah benar)
    context.read<HomeBloc>().add(HomeFetchList());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Games Store'),
        backgroundColor: const Color(0xFF1F1F1F),
        elevation: 0,
      ),
      body: Column(
        children: [
          // --- FITUR SEARCHING (Biarkan ini, sudah benar) ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Cari game (cth: "Cyberpunk")...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFF2A2A2A),
              ),
              onSubmitted: (query) {
                if (query.isNotEmpty) {
                  context.read<HomeBloc>().add(HomeSearchGames(query));
                } else {
                  context.read<HomeBloc>().add(HomeFetchList());
                }
              },
            ),
          ),

          // --- TAMBAHKAN JUDUL "Trending Games" ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Trending Games', // Judul dari gambar
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // --- DAFTAR GAME (BLOC BUILDER) ---
          Expanded(
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is HomeError) {
                  return Center(child: Text('Gagal memuat data: ${state.message}'));
                }
                if (state is HomeSuccess) {
                  if (state.games.isEmpty) {
                    return const Center(child: Text('Game tidak ditemukan.'));
                  }

                  // --- GRIDVIEW TELAH DIREVISI ---
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      // PERBAIKAN 1:
                      // Perkecil 'maxCrossAxisExtent' agar kolomnya
                      // jadi lebih banyak (180px per kartu)
                      maxCrossAxisExtent: 180, // Sebelumnya 300

                      // PERBAIKAN 2:
                      // Ubah rasio agar lebih mirip poster (2:3)
                      childAspectRatio: 2 / 3, // Sekitar 0.66

                      // Atur jarak antar kartu
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: state.games.length,
                    itemBuilder: (context, index) {
                      final game = state.games[index];
                      // Ini akan memanggil GameCard baru yang sudah bersih
                      return GameCard(game: game);
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}