// File: lib/data/services/game_api_service.dart

import 'package:bitArena/core/network/dio_client.dart';
import 'package:bitArena/data/models/game_model.dart';
import 'package:bitArena/data/repositories/game_repository.dart';

// INHERITANCE: Mengimplementasikan kontrak GameRepository
class GameApiService implements GameRepository {
  final DioClient _dioClient;

  // Dependency Injection melalui constructor
  GameApiService(this._dioClient);

  @override
  Future<List<GameModel>> getGames({int page = 1}) async {
    try {
      final response = await _dioClient.get(
        'games',
        queryParameters: {'page': page, 'page_size': 20},
      );

      final List results = response.data['results'] as List;
      return results.map((game) => GameModel.fromJson(game)).toList();
    } catch (e) {
      throw Exception('Gagal memuat game: $e');
    }
  }

  @override
  Future<List<GameModel>> searchGames({required String query}) async {
    try {
      final response = await _dioClient.get(
        'games',
        queryParameters: {'search': query}, // API menggunakan 'search'
      );
      final List results = response.data['results'] as List;
      return results.map((game) => GameModel.fromJson(game)).toList();
    } catch (e) {
      throw Exception('Gagal mencari game: $e');
    }
  }

  @override
  Future<GameModel> getGameDetails({required String id}) async {
    try {
      // API untuk detail adalah 'games/{id}'
      final response = await _dioClient.get('games/$id');
      return GameModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Gagal memuat detail game: $e');
    }
  }

  // --- FUNGSI INI DIPERBAIKI AGAR SESUAI KONTRAK ---
  @override
  Future<List<GameModel>> getFilteredGames(Map<String, dynamic> filters) async {
    try {
      // Kita teruskan 'filters' sebagai queryParameters
      final response = await _dioClient.get(
        'games',
        queryParameters: filters,
      );
      final List results = response.data['results'] as List;
      return results.map((game) => GameModel.fromJson(game)).toList();
    } catch (e) {
      throw Exception('Gagal memfilter game berdasarkan genre: $e');
    }
  }
}
