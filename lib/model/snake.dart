
class Point {
  final int row;
  final int column;

  Point(this.row, this.column);

  Point.clone(Point point) : this(point.row, point.column);


  bool get valid => row >= 0 && column >= 0;


  static Point neighbor(Point point, Direction direction) {
    assert(point != null);
    assert(direction != null);
    int r = point.row;
    int c = point.column;
    switch (direction) {
      case Direction.left:
        --c;
        break;
      case Direction.up:
        --r;
        break;
      case Direction.right:
        ++c;
        break;
      case Direction.down:
        ++r;
        break;
    }
    return Point(r, c);
  }

  @override
  bool operator ==(other) {
    return (other is Point) &&
        other != null &&
        other.row == this.row &&
        other.column == this.column;
  }

  @override
  int get hashCode {
    return this.row.hashCode ^ this.column.hashCode;
  }

  @override
  String toString() {
    return "row:$row,column:$column";
  }


}


enum Direction { left, up, right, down }


enum GameState{stop,play,pause}


class Snake {
  final List<Point> _points = [];
  Direction _direction;

  bool _valid=true;


  Snake({List<Point> points, Direction direction = Direction.left}) {
    assert(points != null && points.length > 0);
    assert(direction != null);
    this._points.addAll(points);
    this._direction = direction;
  }


  int get length => _points.length;

  bool get valid => _valid;


  Direction get direction => _direction;

  set direction(Direction direction) {
    assert(direction != null);
    this._direction = direction;
  }


  bool contains( Point point ){
    return _points.contains(point);
  }


  Point forward() {
    Point _point = Point.neighbor(_points[0], _direction);
    //对即将要走的点进行验证
    _valid = _point.valid && !_points.contains(_point);
    _points
      ..removeLast()
      ..insert(0, _point);
    return _point;
  }


  void eat(Point point) {
    _points.insert(0, point);
  }

  bool isHead(Point point) {
    return _points.first == point;
  }
}
