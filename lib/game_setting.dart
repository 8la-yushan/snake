import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttersnake/model/game_setting.dart';

class GameSettingWidget extends StatefulWidget {

  final GameSetting gameSetting;


  final void Function() onChange;

  const GameSettingWidget({this.gameSetting, this.onChange});

  _dispatch(BuildContext context) {
    onChange();
  }

  @override
  _GameSettingWidgetState createState() => _GameSettingWidgetState();
}

class _GameSettingWidgetState extends State<GameSettingWidget> {
  void _dispatch(BuildContext context) {
    if (widget.onChange != null) {
      setState(() {
        widget.onChange();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final GameSetting gameSetting = widget.gameSetting;
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("主题颜色"),
            ColorSelector(colorMap["board"], gameSetting.themeColor, (c) {
              gameSetting.themeColor = c;
              _dispatch(context);
            }),
            Padding(
              padding: EdgeInsets.all(15),
            ),
            Text("蛇颜色"),
            ColorSelector(colorMap["snake"], gameSetting.snakeColor, (c) {
              gameSetting.snakeColor = c;
              _dispatch(context);
            }),
            Padding(
              padding: EdgeInsets.all(15),
            ),
            Text("食物颜色"),
            ColorSelector(colorMap["food"], gameSetting.foodColor, (c) {
              gameSetting.foodColor = c;
              _dispatch(context);
            }),
            Padding(
              padding: EdgeInsets.all(15),
            ),
            Text("游戏速度"),
            Slider(
              min: 100,
              max: 1000,
              divisions: 9,
              value: gameSetting.speed,
              label: "${gameSetting.speed}",
              onChanged: (v) {
                gameSetting.speed = v;
                _dispatch(context);
              },
            ),
            Text("网格圆角程度"),
            Row(
              children: <Widget>[
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: gameSetting.themeColor,
                    borderRadius: BorderRadius.all(Radius.circular(gameSetting.cellRadius)),
                  ),
                ),
                Slider(
                  min: 0,
                  max: 10,
                  divisions: 10,
                  value: gameSetting.cellRadius,
                  label: "${gameSetting.cellRadius}",
                  onChanged: (v) {
                    gameSetting.cellRadius = v;
                    _dispatch(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}

final Map<String, List<Color>> colorMap = {
  "board": [
    Colors.black,
    Colors.brown.shade900,
    Colors.deepOrange.shade900,
    Colors.red.shade900,
    Colors.pink.shade900,
    Colors.purple.shade900,
    Colors.blue.shade900,
    Colors.green.shade900,
    Colors.yellow.shade900,
  ],
  "snake": [
    Colors.black,
    Colors.brown.shade500,
    Colors.orange,
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.white,
  ],
  "food": [
    Colors.black,
    Colors.brown,
    Colors.orange,
    Colors.red,
    Colors.pinkAccent,
    Colors.deepPurpleAccent,
    Colors.lightBlue,
    Colors.lightGreenAccent,
    Colors.yellow,
    Colors.white,
  ]
};

class ColorSelector extends StatelessWidget {
  final List<Color> colors;
  final Color color;
  final void Function(Color color) onChange;

  const ColorSelector(this.colors, this.color, this.onChange);

  @override
  Widget build(BuildContext context) {
    var fixWhite =
    <T>(Color c, T isWhite, T other) => c == Colors.white ? isWhite : other;

    return Container(
      child: Row(
        children: colors
            .map((c) =>
            InkWell(
              onTap: () => onChange(c),
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 5, 10, 0),
                decoration: BoxDecoration(
                  color: c,
                  border: fixWhite(c, Border.all(color: Colors.blue), null),
                ),
                width: 20,
                height: 20,
                child: c == color
                    ? Icon(
                  Icons.check,
                  color: fixWhite(c, Colors.blue, null),
                )
                    : null,
              ),
            ))
            .toList(),
      ),
    );
  }
}
