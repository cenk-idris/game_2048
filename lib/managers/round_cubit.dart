import 'package:flutter_bloc/flutter_bloc.dart';

class RoundCubit extends Cubit<bool> {
  RoundCubit() : super(true);

  void end() {
    emit(true);
  }

  void begin() {
    emit(false);
  }
}
