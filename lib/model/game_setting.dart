import 'package:flutter/material.dart';


class GameSetting {

  Color themeColor = Colors.black;


  double speed = 300;


  double cellRadius = 5;


  Color snakeColor = Colors.white;


  Color foodColor = Colors.lightGreenAccent;

  GameSetting._();

  static final GameSetting _default = GameSetting._();

  factory GameSetting() => _default;

  @override
  String toString() {
    return "themeColor=$themeColor,speed=$speed,snakeColor=$snakeColor,foodColor=$foodColor";
  }
}
