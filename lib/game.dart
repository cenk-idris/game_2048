import 'package:angs_2048/blocs/board_bloc/board_bloc.dart';
import 'package:angs_2048/blocs/board_bloc/board_event.dart';
import 'package:angs_2048/blocs/board_bloc/board_state.dart';
import 'package:angs_2048/components/button.dart';
import 'package:angs_2048/components/empty_board.dart';
import 'package:angs_2048/components/score_board.dart';
import 'package:angs_2048/components/tile_board.dart';
import 'package:angs_2048/const/colors.dart';
import 'package:angs_2048/models/board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';

class Game extends StatelessWidget {
  Game({super.key});

  final FocusNode _focusNode = FocusNode();

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
                                  onPressed: () {},
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
                      TileBoardWidget(),
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
