import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttersnake/game_setting.dart';

import 'control_board.dart';
import 'model/game_setting.dart';
import 'model/notification.dart';
import 'model/snake.dart';

class GameBoard extends StatefulWidget {

  final int initLength;

  final Size boardSize;

  GameBoard({this.boardSize, this.initLength = 10});

  @override
  _GameBoardState createState() => _GameBoardState();
}

enum CellType { none, snake, food }

class _GameBoardState extends State<GameBoard> {
  static GameSetting gameSetting = GameSetting();


  static final double cellSize = 20;


  static final double cellSpace = 2;


  static final double cellWidth = cellSize - cellSpace * 2;


  static final double controlBoardHeight = 100;


  final random = Random();

  GameState gameState = GameState.stop;

  List<List<CellType>> boards = [];
  Timer timer;


  Snake snake;


  Point food;


  int rows;


  int columns;

  _initBoards() {
    rows = (widget.boardSize.height - controlBoardHeight) ~/ cellSize;
    columns = widget.boardSize.width ~/ cellSize;
    print("rows:$rows,columns:$columns,size : ${widget.boardSize}");
    boards?.clear();
    for (int i = 0; i < rows; i++) {
      boards.add(List.generate(columns, (i) => CellType.none));
    }
  }

  _initSnake() {
    //初始化蛇
    int len = widget.initLength > columns ? columns : widget.initLength;
    int start = (columns - len) ~/ 2;
    List<Point> points = List.generate(len, (i) => Point(rows ~/ 2, start + i));
    snake = Snake(points: points);
  }

  reset() {
    setState(() {
      food = null;
      timer?.cancel();
      _initBoards();
      _initSnake();
    });
  }

  start() {
    if (gameState == GameState.play) {
      return;
    }
    _setGameState(GameState.play);
    timer = Timer.periodic(
        Duration(milliseconds: gameSetting.speed.toInt()), (t) => storyBoost());
  }

  pause() {
    _cancelTimer();
    _setGameState(GameState.pause);
  }

  stop() {
    _cancelTimer();
    _setGameState(GameState.stop);
  }

  _setGameState(GameState state) {
    setState(() {
      gameState = state;
    });
  }

  _cancelTimer() {
    if (timer != null && timer.isActive) {
      timer.cancel();
    }
    timer = null;
  }

  @override
  void initState() {
    super.initState();
    reset();
  }

  CellData _getCellDate(Point point) {
    CellType ct = (snake.contains(point))
        ? CellType.snake
        : boards[point.row][point.column];
    bool snakeHead = false;
    if (ct == CellType.snake) {
      snakeHead = snake.isHead(point);
    }

    Color color;
    switch (ct) {
      case CellType.none:
        color = Colors.white.withOpacity(0.2);
        break;
      case CellType.snake:
        color = gameSetting.snakeColor.withOpacity(0.8);
        break;
      case CellType.food:
        color = gameSetting.foodColor.withOpacity(0.8);
        break;
    }
    return CellData(color: color, cellType: ct, snakeHead: snakeHead);
  }

  static final Map<CellType, Color> cellColorMap = {
    CellType.none: Colors.white.withOpacity(0.1),
    CellType.snake: gameSetting.foodColor.withOpacity(0.6),
    CellType.food: gameSetting.foodColor.withOpacity(0.8),
  };


  void storyBoost() {
    setState(() {
      Point point = snake.forward();

      if (!snake.valid || !validPoint(point)) {
        gameOver();
      } else if (point == food) {
        print("eat");

        snake.eat(point);
        clearFood();

        print("eat ${snake.length}");
      }

      if (food == null) {
        feed();
      }
    });
  }

  void gameOver() {
    print("game over!");
    stop();
    showDialog(
      context: this.context,
      builder: (context) {
        return Container(
          alignment: Alignment.center,
          child: Text(
            "Game Over",
            key: GlobalKey(),
            style: TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.bold,
              color: Colors.red.withOpacity(0.8),
              decoration: TextDecoration.none,
            ),
          ),
        );
      },
    ).then((v) {
      reset();
    });
  }

  void clearFood() {
    assert(food != null);
    boards[food.row][food.column] = CellType.none;
    food = null;
  }

  bool validPoint(Point point) {
    return point.valid && point.row < rows && point.column < columns;
  }

  void feed() {
    while (true) {
      int row = random.nextInt(rows);
      int col = random.nextInt(columns);

      if (boards[row][col] == CellType.none &&
          !snake.contains(Point(row, col))) {
        boards[row][col] = CellType.food;
        food = Point(row, col);
        break;
      }
    }
  }

  printBoard() {
    boards.forEach((row) {
      StringBuffer sb = StringBuffer();
      row.forEach((i) => sb.write(i.index));
      print(sb);
    });
  }

  void onChangeSetting() {
    setState(() {});
  }

  void showSetting() {
    showDialog(
        context: this.context,
        builder: (ctx) {
          return GameSettingWidget(
              gameSetting: gameSetting, onChange: onChangeSetting);
        });
  }

  bool onControl(ControlNotification notification) {
    print(notification);
    switch (notification.controlType) {
      case ControlType.restart:
        reset();
        break;
      case ControlType.play:
        start();
        break;
      case ControlType.pause:
        pause();
        break;
      case ControlType.setting:
        showSetting();
        break;
      case ControlType.direction:
        if (gameState == GameState.play) {

          Direction newDirection =
              ((notification as DirectionNotification).direction);
          if (newDirection == Direction.left &&
                  snake.direction != Direction.right ||
              newDirection == Direction.up &&
                  snake.direction != Direction.down ||
              newDirection == Direction.right &&
                  snake.direction != Direction.left ||
              newDirection == Direction.down &&
                  snake.direction != Direction.up) {
            snake.direction = newDirection;
          }
        }
        break;
    }
    return false;
  }

  Widget createCell(int row, int col) {
    CellData cellData = _getCellDate(Point(row, col));
    return Container(
      width: cellWidth,
      height: cellWidth,
      decoration: BoxDecoration(
        color: cellData.color,
        borderRadius: BorderRadius.all(Radius.circular(gameSetting.cellRadius)),
      ),
      child: cellData.snakeHead
          ? Icon(
              Icons.radio_button_checked,
              size: cellWidth,
              color: gameSetting.themeColor,
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Flex> rowList = [];
    for (int _row = 0; _row < rows; _row++) {
      List<Container> list = [];
      for (int _col = 0; _col < columns; _col++) {
        list.add(createCell(_row, _col));
      }

      rowList.add(Flex(
        children: list,
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
      ));
    }

    double verPadding =
        (widget.boardSize.height - controlBoardHeight - rows * cellSize) / 2;
    double horPadding = (widget.boardSize.width - columns * cellSize) / 2;

    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            color: gameSetting.themeColor,
            child: Column(
              children: rowList,
              //direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            ),
          ),
        ),
        Container(
          height: 100,
          color: gameSetting.themeColor,
          child: NotificationListener<ControlNotification>(
            onNotification: onControl,
            child: ControlBoard(score: snake?.length, state: gameState),
          ),
        ),
      ],
    );
  }
}

class CellData {
  final CellType cellType;
  final Color color;
  final bool snakeHead;

  const CellData({this.color, this.cellType, this.snakeHead});
}
