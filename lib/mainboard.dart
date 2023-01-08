import 'package:flutter/material.dart';
import 'package:fluttersnake/model/game_setting.dart';

import 'game_board.dart';

class MainBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size boardSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: GameSetting().themeColor,
      body: SafeArea(
        child: Builder(builder: (c) {
          return GameBoard(boardSize: boardSize);
        }),
      ),
    );
  }
}
