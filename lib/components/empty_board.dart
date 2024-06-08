import 'dart:math';

import 'package:angs_2048/const/colors.dart';
import 'package:flutter/material.dart';

class EmptyBoardWidget extends StatelessWidget {
  EmptyBoardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Decides the max size the board can be,
    // based on the shortest size of the screen
    final size = max(
        290.0,
        min((MediaQuery.of(context).size.shortestSide * 0.90).floorToDouble(),
            460.0));

    // Decide the size of the tile
    // based on the size of the board minus
    // the space between each tile
    final sizePerTile = (size / 4).floorToDouble();
    final tileSize = sizePerTile - 12.0 - (12.0 / 4);
    final boardSize = sizePerTile * 4;

    return Container(
      width: boardSize,
      height: boardSize,
      decoration: BoxDecoration(
        color: boardColor,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Stack(
        children: [
          for (int row = 0; row < 4; row++)
            for (int col = 0; col < 4; col++)
              Positioned(
                top: row * tileSize + (row + 1) * 12.0,
                left: col * tileSize + (col + 1) * 12.0,
                child: Container(
                  width: tileSize,
                  height: tileSize,
                  decoration: BoxDecoration(
                    color: emptyTileColor,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
              )
        ],
      ),
    );
  }
}
