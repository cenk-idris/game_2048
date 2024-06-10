import 'dart:math';
import 'package:angs_2048/managers/next_direction_cubit.dart';
import 'package:angs_2048/managers/round_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:uuid/uuid.dart';
import '../../models/board.dart';
import '../../models/tile.dart';
import 'board_event.dart';
import 'board_state.dart';

class BoardBloc extends Bloc<BoardEvent, BoardState> {
  final RoundCubit roundCubit;
  final NextDirectionCubit nextDirectionCubit;
  // We will use this list to retrieve the right index when user swipes up/down
  // which will allow us to reuse most of the logic.
  final verticalOrder = [12, 8, 4, 0, 13, 9, 5, 1, 14, 10, 6, 2, 15, 11, 7, 3];

  BoardBloc({required this.roundCubit, required this.nextDirectionCubit})
      : super(BoardState(Board.newGame(best: 0, tiles: []))) {
    on<StartNewGame>(_onStartNewGame);
    on<MoveTile>(_onMoveTile);
    on<MergeTiles>(_onMergeTiles);
    on<EndRound>(_endRound);
  }

  @override
  void onChange(Change<BoardState> change) {
    super.onChange(change);
    //print(change.nextState.board.tiles.toString());
  }

  void _onStartNewGame(StartNewGame event, Emitter<BoardState> emit) {
    emit(BoardState(_newGame()));
  }

  void _onMoveTile(MoveTile event, Emitter<BoardState> emit) {
    // Implement move logic here
    List<Tile> movedList = move(event.direction);
    Board updatedBoard = state.board.copyWith(tiles: movedList);
    for (var tile in state.board.tiles) {
      //print('${tile.index} - ${tile.nextIndex}');
    }

    emit(BoardState(updatedBoard));
    for (var tile in state.board.tiles) {
      //print('${tile.index} - ${tile.nextIndex}');
    }
    //add(MergeTiles());
  }

  void _onMergeTiles(MergeTiles event, Emitter<BoardState> emit) {
    Board mergedBoard = merge();
    emit(BoardState(mergedBoard));
  }

  Board merge() {
    List<Tile> tilesList = [];
    var tilesMoved = false;
    List<int> indexes = [];
    var score = state.board.score;

    for (int i = 0, l = state.board.tiles.length; i < l; i++) {
      var tile = state.board.tiles[i];

      var value = tile.value, merged = false;

      if (i + 1 < l) {
        // print(
        //     'This is ith: ${state.board.tiles[i].index} and i+1th: ${state.board.tiles[i + 1].index}');
        //sum the number of the two tiles with same index and mark the tile as merged and skip the next iteration
        var next = state.board.tiles[i + 1];
        if (tile.nextIndex == next.nextIndex ||
            tile.index == next.nextIndex && tile.nextIndex == null) {
          value = tile.value + next.value;
          merged = true;
          score += tile.value;
          ++i;
        }
      }

      if (merged || tile.nextIndex != null && tile.index != tile.nextIndex) {
        tilesMoved = true;
      }

      tilesList.add(tile.copyWith(
        index: tile.nextIndex ?? tile.index,
        nextIndex: null,
        value: value,
        merged: merged,
      ));
      indexes.add(tilesList.last.index);
    }

    // If tiles got moved then generate a new tile at random position of the available positions on the board.
    if (tilesMoved) {
      tilesList.add(random(indexes));
    }
    return state.board.copyWith(score: score, tiles: tilesList);
  }

  List<Tile> move(SwipeDirection direction) {
    bool vert =
        direction == SwipeDirection.up || direction == SwipeDirection.down;
    bool asc =
        direction == SwipeDirection.left || direction == SwipeDirection.up;
    // Sort the list of tiles by index.
    state.board.tiles.sort((a, b) =>
        (asc ? 1 : -1) *
        (vert
            ? verticalOrder[a.index].compareTo(verticalOrder[b.index])
            : a.index.compareTo(b.index)));
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
          var index = vert ? verticalOrder[tile.index] : tile.index,
              nextIndex = vert ? verticalOrder[next.index] : next.index;
          if (_inRange(index, nextIndex)) {
            tilesList.add(next.copyWith(nextIndex: tile.nextIndex));
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
    bool asc =
        direction == SwipeDirection.left || direction == SwipeDirection.up;
    bool vert =
        direction == SwipeDirection.up || direction == SwipeDirection.down;
    // Get the first index from the left in the row that the tile belongs to
    // Example: for left swipe tha can be 0, 4, 8, 12
    int index = vert ? verticalOrder[tile.index] : tile.index;
    int nextIndex = ((index + 1) / 4).ceil() * 4 - (asc ? 4 : 1);

    // If the list of the new tiles to be rendered is not empty get the last tile
    // and if that tile is in the same row as the current tile set the next index for that
    if (tilesList.isNotEmpty) {
      final last = tilesList.last;
      var lastIndex = last.nextIndex ?? last.index;
      lastIndex = vert ? verticalOrder[lastIndex] : lastIndex;
      if (_inRange(index, lastIndex)) {
        nextIndex = lastIndex + (asc ? 1 : -1);
      }
    }

    // Return immutable copy of the current tile with the new next index
    // which can be either be the top left index in the row
    // or the las tile's nextIndex/index + 1
    return tile.copyWith(
        nextIndex: vert ? verticalOrder.indexOf(nextIndex) : nextIndex);
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

  void _endRound(EndRound event, Emitter<BoardState> emit) {
    var gameOver = true, gameWon = false;
    List<Tile> tilesList = [];

    // If there is no more empty place on the board
    if (state.board.tiles.length == 16) {
      state.board.tiles.sort((a, b) => a.index.compareTo(b.index));

      for (int i = 0, l = state.board.tiles.length; i < l; i++) {
        var tile = state.board.tiles[i];

        // if there is a tile with 2048 then the game is won.
        if (tile.value == 2048) {
          gameWon = true;
        }

        var x = i - (((i + 1) / 4).ceil() * 4 - 4);

        // If tile can be merged with left tile then game is not lost.
        if (x > 0 && i - 1 >= 0) {
          final leftTile = state.board.tiles[i - 1];
          if (tile.value == leftTile.value) {
            gameOver = false;
          }
        }

        // If tile can be merged with right tile then game is not lost.
        if (x < 3 && i + 1 < l) {
          final rightTile = state.board.tiles[i + 1];
          if (tile.value == rightTile.value) {
            gameOver = false;
          }
        }

        // If tile can be merged with above tile then game is not lost.
        if (i - 4 >= 0) {
          final topTile = state.board.tiles[i - 4];
          if (tile.value == topTile.value) {
            gameOver = false;
          }
        }

        // If tile can be merged with below tile then game is not lost.
        if (i + 4 < l) {
          final bottomTile = state.board.tiles[i + 4];
          if (tile.value == bottomTile.value) {
            gameOver = false;
          }
        }

        //Set the tile merged: false
        tilesList.add(tile.copyWith(merged: false));
      }
    } else {
      // There is still a place on the board to add a tile so game is not lost.
      gameOver = false;
      for (var tile in state.board.tiles) {
        // If there is a tile with 2048 then game is won.
        if (tile.value == 2048) {
          gameWon = true;
        }
        // Set the tile merged: false
        tilesList.add(tile.copyWith(merged: false));
      }
    }

    emit(BoardState(
        state.board.copyWith(tiles: tilesList, over: gameOver, won: gameWon)));
    print('Is game over: ${state.board.over}');
  }

  bool endRound() {
    // End round
    add(EndRound());
    roundCubit.end();

    // If player moved too fast before the current
    // animation/transition finished, start the move for the next direction
    var nextDirection = nextDirectionCubit.state;
    if (nextDirection != null) {
      add(MoveTile(nextDirection));
      nextDirectionCubit.clear();
      return true;
    }
    return false;
  }
}
