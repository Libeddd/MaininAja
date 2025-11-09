// File: lib/features/home/bloc/home_bloc.dart (VERSI GABUNGAN)
// GANTI SEMUA ISI FILE LAMA ANDA DENGAN INI

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/data/models/game_model.dart';
import 'package:frontend/data/repositories/game_repository.dart';

// --- BAGIAN 1: EVENT ---
// (Sebelumnya ada di home_event.dart)
abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object> get props => [];
}

// Event untuk mengambil daftar game awal
class HomeFetchList extends HomeEvent {}

// Event untuk melakukan pencarian
class HomeSearchGames extends HomeEvent {
  final String query;
  const HomeSearchGames(this.query);

  @override
  List<Object> get props => [query];
}

// --- BAGIAN 2: STATE ---
// (Sebelumnya ada di home_state.dart)
abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}
class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<GameModel> games;
  const HomeSuccess(this.games);

  @override
  List<Object> get props => [games];
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}


// --- BAGIAN 3: BLOC ---
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  // POLYMORPHISM: Butuh kontrak repository
  final GameRepository _gameRepository;

  HomeBloc(this._gameRepository) : super(HomeInitial()) {
    
    // Mendaftarkan event handler
    on<HomeFetchList>(_onFetchHomeList);
    on<HomeSearchGames>(_onSearchGames);
  }

  // Handler untuk event 'HomeFetchList'
  Future<void> _onFetchHomeList(
    HomeFetchList event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading()); // Ubah state ke Loading
    try {
      final games = await _gameRepository.getGames();
      emit(HomeSuccess(games)); // Ubah state ke Success
    } catch (e) {
      emit(HomeError(e.toString())); // Ubah state ke Error
    }
  }

  // Handler untuk event 'HomeSearchGames'
  Future<void> _onSearchGames(
    HomeSearchGames event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading()); // Tampilkan loading saat mencari
    try {
      final games = await _gameRepository.searchGames(query: event.query);
      emit(HomeSuccess(games));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}