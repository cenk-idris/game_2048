import 'package:flutter_bloc/flutter_bloc.dart';

class GameObserver extends BlocObserver {
  GameObserver();

  @override
  void onTransition(Bloc bloc, Transition transition) {
    // TODO: implement onTransition
    super.onTransition(bloc, transition);
    // ignore: avoid_print
    print('From observer: ${bloc.runtimeType}, $transition');
  }
}
