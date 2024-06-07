import 'package:angs_2048/components/button.dart';
import 'package:angs_2048/components/empty_board.dart';
import 'package:angs_2048/components/score_board.dart';
import 'package:angs_2048/const/colors.dart';
import 'package:flutter/material.dart';
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
          // Move the tiles on Swipe on Android and iOS
        },
        child: Scaffold(
          backgroundColor: backgroundColor,
          body: Column(
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
                              onPressed: () {},
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
                children: [EmptyBoardWidget()],
              )
            ],
          ),
        ),
      ),
    );
  }
}
