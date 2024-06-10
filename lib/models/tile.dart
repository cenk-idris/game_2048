class Tile {
  // Unique id used as ValueKey for the TileWidget
  final String id;
  // The number on the tile
  final int value;
  // The index of the tile on the board from which
  // the position of the tile will be calculated
  final int index;
  // The next index of the tile on the board
  final int? nextIndex;
  // Whether the tile was merged with another tile
  final bool merged;

  Tile(this.id, this.value, this.index, {this.nextIndex, this.merged = false});

  // Create an immutable copy of the tile
  Tile copyWith(
          {String? id, int? value, int? index, int? nextIndex, bool? merged}) =>
      Tile(id ?? this.id, value ?? this.value, index ?? this.index,
          nextIndex: nextIndex ?? this.nextIndex,
          merged: merged ?? this.merged);

  /// Calculate the current top position based on the current index
  double getTop(double size) {
    final i = ((index + 1) / 4).ceil();
    return ((i - 1) * size) + (12.0 * i);
  }

  /// Calculate the current left position based on the current index
  double getLeft(double size) {
    final i = (index - (((index + 1) / 4).ceil() * 4 - 4));
    return (i * size) + (12.0 * (i + 1));
  }

  double? getNextTop(double size) {
    if (nextIndex == null) return null;
    var i = ((nextIndex! + 1) / 4).ceil();
    return ((i - 1) * size) + (12.0 * i);
  }

  double? getNextLeft(double size) {
    if (nextIndex == null) return null;
    var i = nextIndex! - (((nextIndex! + 1) / 4).ceil() * 4 - 4);
    return (i * size) + (12.0 * (i + 1));
  }
}
