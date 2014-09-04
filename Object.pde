class Object {

  ArrayList<Point> ver;
  
  Object() {
    ver = new ArrayList();
  }
  
  Object(ArrayList<Point> ver) {
    this.ver = ver;
  }
  
  void addVertex(float x, float y) {
     Point p = new Point(x, y);
     ver.add(p);
  }

  void drawObject() {
    noFill();
    stroke(0);
    beginShape();
    for (int i = 0; i < ver.size(); i ++) {
      curveVertex(ver.get(i).getX(), ver.get(i).getY());
    }
    endShape(CLOSE);
  }
}

