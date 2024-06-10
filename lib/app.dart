import 'package:angs_2048/managers/board_bloc/board_bloc.dart';
import 'package:angs_2048/game.dart';
import 'package:angs_2048/managers/board_bloc/board_event.dart';
import 'package:angs_2048/managers/next_direction_cubit.dart';
import 'package:angs_2048/managers/round_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameApp extends MaterialApp {
  GameApp({super.key})
      : super(
            home: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => RoundCubit(),
                ),
                BlocProvider(
                  create: (context) => NextDirectionCubit(),
                ),
                BlocProvider(
                  create: (context) => BoardBloc(
                    roundCubit: context.read<RoundCubit>(),
                    nextDirectionCubit: context.read<NextDirectionCubit>(),
                  )..add(StartNewGame()),
                ),
              ],
              child: Game(),
            ),
            title: '2048');
}
