import 'package:angs_2048/game_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';

void main() {
  Bloc.observer = GameObserver();
  runApp(GameApp());
}
