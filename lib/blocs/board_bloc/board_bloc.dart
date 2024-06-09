import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../models/board.dart';
import '../../models/tile.dart';
import 'board_event.dart';
import 'board_state.dart';

class BoardBloc extends Bloc<BoardEvent, BoardState> {
  BoardBloc() : super(BoardState(Board.newGame(best: 0, tiles: []))) {
    on<StartNewGame>(_onStartNewGame);
    on<MoveTile>(_onMoveTile);
  }

  @override
  void onChange(Change<BoardState> change) {
    super.onChange(change);
    print(change.nextState.board.tiles.toString());
  }

  void _onStartNewGame(StartNewGame event, Emitter<BoardState> emit) {
    emit(BoardState(_newGame()));
  }

  void _onMoveTile(MoveTile event, Emitter<BoardState> emit) {
    // Implement move logic here
  }

  Board _newGame() {
    final bestScore = state.board.best + state.board.score;
    final tiles = [random([])];
    return Board.newGame(best: bestScore, tiles: tiles);
  }

  /// Generating random indexes for new Tile
  /// until it generates a random index that doesn't exist
  /// in the given [indexes] list.
  Tile random(List<int> indexes) {
    var i = 0;
    var rng = Random();
    do {
      i = rng.nextInt(16);
    } while (indexes.contains(i));

    return Tile(Uuid().v4(), 2, i);
  }
}
