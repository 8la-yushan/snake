import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'model/notification.dart';
import 'model/snake.dart';

class ControlBoard extends StatelessWidget {
  final int score;
  final GameState state;

  const ControlBoard({this.score,this.state});


  _dispatchDirection(BuildContext context, Direction direction) {
    DirectionNotification(direction).dispatch(context);
  }

  _dispatchControl(BuildContext context, ControlType controlType) {
    ControlNotification(controlType).dispatch(context);
  }


  Widget buildDirection(BuildContext context) {
    return Container(
      width: 130,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 40,
              ),
              ControlButton(
                child: Icon(Icons.keyboard_arrow_up),
                onTap: () => _dispatchDirection(context, Direction.up),
              ),
              SizedBox(
                width: 40,
              ),
            ],
          ),
          Row(
            children: [
              ControlButton(
                child: Icon(Icons.keyboard_arrow_left),
                onTap: () => _dispatchDirection(context, Direction.left),
              ),
              ControlButton(
                child: Icon(Icons.keyboard_arrow_down),
                onTap: () => _dispatchDirection(context, Direction.down),
              ),
              ControlButton(
                child: Icon(Icons.keyboard_arrow_right),
                onTap: () => _dispatchDirection(context, Direction.right),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 10),
          ),
          ControlButton(
            child: Icon(Icons.replay),
            onTap: () {
              _dispatchControl(context, ControlType.restart);
            },
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
          ),
          ControlButton(
            child: Icon( state == GameState.pause || state==GameState.stop ? Icons.play_arrow:Icons.pause),
            onTap: () {
              _dispatchControl(
                  context, state != GameState.play ? ControlType.play : ControlType.pause);
            },
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
          ),
          ControlButton(
            child: Icon(Icons.settings),
            onTap: () {
              _dispatchControl(context, ControlType.setting);
            },
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Container(
                width: 60,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                alignment: Alignment.center,
                child: Text(
                  "$score",
                  style: TextStyle(
                      color: Colors.white.withAlpha(100), fontSize: 24),
                ),
              ),
            ),
          ),
          buildDirection(context),
        ],
      ),
    );
  }

}

class ControlButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final Widget child;

  const ControlButton({this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 40,
        height: 40,
        //constraints: BoxConstraints(minWidth: 40, maxWidth: 40,maxHeight: 40),

          child:
              (FractionalTranslation(translation: Offset(-1, 0), child: child)),
        );
  }
}
