import 'package:equatable/equatable.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';

sealed class BoardEvent extends Equatable {
  BoardEvent();

  @override
  List<Object> get props => [];
}

class StartNewGame extends BoardEvent {}

class MoveTile extends BoardEvent {
  final SwipeDirection direction;

  MoveTile(this.direction);

  @override
  List<Object> get props => [direction];
}

class MergeTiles extends BoardEvent {}

class EndRound extends BoardEvent {}

class UndoGame extends BoardEvent {}
