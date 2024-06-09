import 'dart:ffi';
import 'dart:math';

import 'package:angs_2048/const/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/board_bloc/board_bloc.dart';

class TileBoardWidget extends StatelessWidget {
  TileBoardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final board = BlocProvider.of<BoardBloc>(context).state.board;
    final size = max(
        290.0,
        min((MediaQuery.of(context).size.shortestSide * 0.90).floorToDouble(),
            460.0));

    //Decide the size of the tile based on the size of the board minus the space between each tile.
    final sizePerTile = (size / 4).floorToDouble();
    final tileSize = sizePerTile - 12.0 - (12.0 / 4);
    final boardSize = sizePerTile * 4;

    return SizedBox(
      width: boardSize,
      height: boardSize,
      child: Stack(
        children: [
          ...List.generate(board.tiles.length, (i) {
            final tile = board.tiles[i];
            return Positioned(
              key: ValueKey(tile.id),
              top: tile.getTop(tileSize),
              left: tile.getLeft(tileSize),
              child: Container(
                width: tileSize,
                height: tileSize,
                decoration: BoxDecoration(
                  color: tileColors[tile.value],
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Center(
                  child: Text(
                    '${tile.value}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                        color: tile.value < 8 ? textColor : textColorWhite),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
