import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';

class NextDirectionCubit extends Cubit<SwipeDirection?> {
  NextDirectionCubit() : super(null);

  void queue(SwipeDirection direction) {
    emit(direction);
  }

  void clear() {
    emit(null);
  }
}
