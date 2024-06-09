import '../models/tile.dart';

class Board {
  // Current score on the board
  final int score;
  // Best score so far
  final int best;
  // Current list of tiles shown on the board
  final List<Tile> tiles;
  // Whether the game is over or not
  final bool over;
  // Whether the game is won or not
  final bool won;
  // Keeps the previous round board state used for the undo functionality
  final Board? undo;

  Board(this.score, this.best, this.tiles,
      {this.over = false, this.won = false, this.undo});

  // Create a model for a new game
  Board.newGame({required this.best, required this.tiles})
      : score = 0,
        over = false,
        won = false,
        undo = null;

  // Create an immutable copy of the board
  Board copyWith(
          {int? score,
          int? best,
          List<Tile>? tiles,
          bool? over,
          bool? won,
          Board? undo}) =>
      Board(score ?? this.score, best ?? this.best, tiles ?? this.tiles,
          over: over ?? this.over,
          won: won ?? this.won,
          undo: undo ?? this.undo);
}
