import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../const/colors.dart';
import '../managers/board_bloc/board_bloc.dart';

class ScoreBoard extends StatelessWidget {
  ScoreBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //TODO: connect the state notifier with the score widget
        Score(
          label: 'Score',
          score: context.read<BoardBloc>().state.board.score.toString(),
        ),
        SizedBox(
          width: 8.0,
        ),
        Score(
          label: 'Best',
          score: context.read<BoardBloc>().state.board.best.toString(),
        )
      ],
    );
  }
}

class Score extends StatelessWidget {
  Score({super.key, required this.label, required this.score, this.padding});

  final String label;
  final String score;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: scoreColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(fontSize: 18.0, color: color2),
          ),
          Text(
            score,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          )
        ],
      ),
    );
  }
}
