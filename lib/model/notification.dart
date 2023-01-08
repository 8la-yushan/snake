import 'package:flutter/material.dart';
import 'package:fluttersnake/model/snake.dart';


enum ControlType{ restart,play,pause,direction,setting}

///
class ControlNotification extends Notification {
  final ControlType controlType;
  const ControlNotification(this.controlType);
  @override
  String toString() {
    return "$runtimeType [controlType=$controlType]";
  }
}


class DirectionNotification extends ControlNotification {
  final Direction direction;
  const DirectionNotification(this.direction):super(ControlType.direction);

  @override
  String toString() {
    return "$runtimeType [controlType=$controlType,direction:$direction]";
  }
}
