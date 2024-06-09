import 'package:angs_2048/blocs/board_bloc/board_bloc.dart';
import 'package:angs_2048/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameApp extends MaterialApp {
  GameApp({super.key})
      : super(
            home: BlocProvider(
              create: (context) => BoardBloc(),
              child: Game(),
            ),
            title: '2048');
}
