class Point {
  int x;
  int y;
  ArrayList<Point> adjacents;
  int position;

  Point (int x, int y) {
    this.x = x;
    this.y = y;
    adjacents = new ArrayList();
  }

  int getX() {
    return this.x;
  }

  int getY() {
    return this.y;
  }

  void addAdjacents(Point p) {
    adjacents.add(p);
  }

  void updatePoint(int x, int y) {
    this.x = x;
    this.y = y;
  }

  boolean hover() {
    if (mouseX > x - 3 && mouseX < x + 3 && mouseY > y - 3 && mouseY < y + 3) {
      println("Hovering over point (" + x + ", " + y + ")");
      return true;
    } else return false;
  }

  void drawPoint() {
    strokeWeight(5);
    if (hover()) {
      stroke(#FFFF00);
    } else {
      stroke(#FF0000);
    }
    point(x, y);
  }
}

