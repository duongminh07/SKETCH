class Object {

  ArrayList<Point> ver;
  ArrayList<Point> pins;
  
  Object() {
    ver = new ArrayList();
    pins = new ArrayList();
  }
  
  Object(ArrayList<Point> ver) {
    this.ver = ver;
    pins = new ArrayList();
  }
  
  void addVertex(float x, float y) {
     Point p = new Point(x, y);
     ver.add(p);
  }

  void drawObject() {
    background(255);
    noFill();
    stroke(0);
    smooth();
    beginShape();
    for (int i = 0; i < ver.size(); i ++) {
     curveVertex(ver.get(i).getX(), ver.get(i).getY());
    }
    endShape(CLOSE);
    println("Object size: " + ver.size());
  }
  
  boolean checkOver() {
    return true;
  }
}

