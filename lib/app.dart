import 'package:angs_2048/game.dart';
import 'package:flutter/material.dart';

class GameApp extends MaterialApp {
  GameApp({super.key}) : super(home: Game(), title: '2048');
}
