import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
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
    List<Tile> movedList = move(event.direction);
    Board updatedBoard = state.board.copyWith(tiles: movedList);
    print(
        '${state.board.tiles.first.index} - ${state.board.tiles.first.nextIndex}');
    emit(BoardState(updatedBoard));
    print(
        '${state.board.tiles.first.index} - ${state.board.tiles.first.nextIndex}');
  }

  List<Tile> move(SwipeDirection direction) {
    // Sort the list of tiles by index.
    state.board.tiles.sort((a, b) => a.index.compareTo(b.index));
    List<Tile> tilesList = [];

    for (int i = 0, l = state.board.tiles.length; i < l; i++) {
      Tile tile = state.board.tiles[i];

      // Calculate nextIndex for current tile.
      tile = _calculate(tile, tilesList, direction);
      tilesList.add(tile);

      if (i + 1 < l) {
        var next = state.board.tiles[i + 1];
        // Assign current tile nextIndex or index to the next tile if its
        // allowed to move
        if (tile.value == next.value) {
          var index = tile.index, nextIndex = next.index;
          if (_inRange(index, nextIndex)) {
            tilesList.add(next.copyWith());
            // Skip next iteration if next tile was already assigned nextIndex.
            i += 1;
            continue;
          }
        }
      }
    }
    return tilesList;
  }

  Tile _calculate(Tile tile, List<Tile> tilesList, direction) {
    // Get the first index from the left in the row that the tile belongs to
    // Example: for left swipe tha can be 0, 4, 8, 12
    int index = tile.index;
    int nextIndex = ((index + 1) / 4).ceil() * 4 - 4;

    // If the list of the new tiles to be rendered is not empty get the last tile
    // and if that tile is in the same row as the current tile set the next index for that
    if (tilesList.isNotEmpty) {
      final last = tilesList.last;
      final lastIndex = last.nextIndex ?? last.index;
      if (_inRange(index, lastIndex)) {
        nextIndex = lastIndex + 1;
      }
    }

    // Return immutable copy of the current tile with the new next index
    // which can be either be the top left index in the row
    // or the las tile's nextIndex/index + 1
    return tile.copyWith(nextIndex: nextIndex);
  }

  bool _inRange(int index, int nextIndex) {
    return index < 4 && nextIndex < 4 ||
        index >= 4 && index < 8 && nextIndex >= 4 && nextIndex < 8 ||
        index >= 8 && index < 12 && nextIndex >= 8 && nextIndex < 12 ||
        index >= 12 && nextIndex >= 12;
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
