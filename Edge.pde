class Edge {
  Point x;
  Point y;

  Edge (Point x, Point y) {
    this.x = x;
    this.y = y;
  }

  Point getX() {
    return this.x;
  }

  Point getY() {
    return this.y;
  }

  void updateEdge(Point x, Point y) {
    this.x = x;
    this.y = y;
  }

  void drawEdge() {
    strokeWeight(5);
    stroke(#FF0000);
    point(x.x, x.y);
    point(y.x, y.y);
    strokeWeight(1);
    stroke(#00FF00);
    line(x.x, x.y, y.x, y.y);
  }
}

