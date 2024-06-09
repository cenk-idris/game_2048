import 'package:equatable/equatable.dart';
import '../../models/board.dart';
import '../../models/tile.dart';

class BoardState extends Equatable {
  final Board board;

  BoardState(this.board);

  @override
  List<Object> get props => [board];
}
