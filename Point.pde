class Point{
  Float x;
  Float y;
  ArrayList<Point> adjacents;
  int position;
  
  Point(Float x, Float y) {
    this.x = x;
    this.y = y;
    adjacents = new ArrayList();
  }
  
  Point (int x, int y) {
    this.x = (float)x;
    this.y = (float)y;
    adjacents = new ArrayList();
  }
  
  Float getX() {
    return this.x;
  }
  
  Float getY() {
    return this.y;
  }
  
  void addAdjacents(Point p) {
    adjacents.add(p);
  }
}
