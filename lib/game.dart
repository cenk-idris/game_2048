import '../managers/board_bloc/board_bloc.dart';
import '../managers/board_bloc/board_event.dart';
import '../managers/board_bloc/board_state.dart';
import '../components/button.dart';
import '../components/empty_board.dart';
import '../components/score_board.dart';
import '../components/tile_board.dart';
import '../const/colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';

class Game extends StatefulWidget {
  Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> with TickerProviderStateMixin {
  // The controller used to move the tiles
  late final AnimationController _moveController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  )..addStatusListener((status) {
      print('move animation status: ${AnimationStatus.completed}');
      // When the movement finishes merge the tiles
      // and start the scale animation which gives the pop effect
      if (status == AnimationStatus.completed) {
        context.read<BoardBloc>().add(MergeTiles());
        _scaleController.forward(from: 0.0);
      }
    });

  // The curve animation for the move animation controller.
  late final CurvedAnimation _moveAnimation = CurvedAnimation(
    parent: _moveController,
    curve: Curves.easeInOut,
  );

  // The controller used to show a popup effect when the tiles get merged
  late final AnimationController _scaleController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  )..addStatusListener((status) {
      // When the scale animation finishes end the round and if there is a queued movement start the move controller again for the next direction.
      print('move animation status: ${AnimationStatus.completed}');
      if (status == AnimationStatus.completed) {
        if (context.read<BoardBloc>().endRound()) {
          _moveController.forward(from: 0.0);
        }
      }
    });

  late final CurvedAnimation _scaleAnimation = CurvedAnimation(
    parent: _scaleController,
    curve: Curves.easeInOut,
  );

  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    // Dispose animations
    _moveAnimation.dispose();
    _scaleAnimation.dispose();
    _moveController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: (KeyEvent event) {
        // Move the tiles with the arrows on the keyboard on Desktop
      },
      child: SwipeDetector(
        onSwipe: (direction, offset) {
          // ignore: avoid_print
          print(direction);
        },
        onSwipeLeft: (offset) {
          // ignore: avoid_print
          print('You swiped left');
          context.read<BoardBloc>().add(MoveTile(SwipeDirection.left));
          _moveController.forward(from: 0.0);
        },
        onSwipeRight: (offset) {
          // ignore: avoid_print
          print('You swiped right');
          context.read<BoardBloc>().add(MoveTile(SwipeDirection.right));
          _moveController.forward(from: 0.0);
        },
        onSwipeDown: (offset) {
          print('You swiped down');
          context.read<BoardBloc>().add(MoveTile(SwipeDirection.down));
          _moveController.forward(from: 0.0);
        },
        onSwipeUp: (offset) {
          print('You swiped up');
          context.read<BoardBloc>().add(MoveTile(SwipeDirection.up));
          _moveController.forward(from: 0.0);
        },
        child: Scaffold(
          backgroundColor: backgroundColor,
          body: BlocBuilder<BoardBloc, BoardState>(
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '2048',
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 52.0,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                //TODO: Add the score board and best score
                                ScoreBoard(),
                              ],
                            ),
                            SizedBox(
                              height: 32.0,
                            ),
                            Row(
                              children: [
                                ButtonWidget(
                                  onPressed: () {
                                    context.read<BoardBloc>().add(UndoGame());
                                  },
                                  icon: Icons.undo,
                                ),
                                SizedBox(
                                  width: 16.0,
                                ),
                                ButtonWidget(
                                  onPressed: () {
                                    context
                                        .read<BoardBloc>()
                                        .add(StartNewGame());
                                  },
                                  icon: Icons.refresh,
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  Stack(
                    children: [
                      EmptyBoardWidget(),
                      TileBoardWidget(
                        moveAnimation: _moveAnimation,
                        scaleAnimation: _scaleAnimation,
                      ),
                    ],
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
