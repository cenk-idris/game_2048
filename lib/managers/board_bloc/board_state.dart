import 'package:equatable/equatable.dart';
import '../../models/board.dart';

class BoardState extends Equatable {
  final Board board;

  BoardState(this.board);

  @override
  List<Object> get props => [board];
}
