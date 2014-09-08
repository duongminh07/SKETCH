class Object {

  ArrayList<Point> ver;
  ArrayList<Point> pins;
  ArrayList<Triangle> triangles;
  Point leftMost;
  Point rightMost;
  Point upMost;
  Point downMost;

  Object() {
    ver = new ArrayList();
    pins = new ArrayList();
    triangles = new ArrayList();
  }

  Object(ArrayList<Point> ver) {
    this.ver = ver;
    pins = new ArrayList();
    triangles = new ArrayList();
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
    for (int i = 0; i < ver.size (); i ++) {
      curveVertex(ver.get(i).getX(), ver.get(i).getY());
    }
    endShape(CLOSE);
  }

  void drawObjectLine() {
    background(255);
    noFill();
    stroke(0);
    smooth();
    beginShape();
    for (int i = 1; i < ver.size (); i ++) {
      line(ver.get(i).x, ver.get(i).y, ver.get(i - 1).x, ver.get(i-1).y);
    }
    line(ver.get(0).x, ver.get(0).y, ver.get(ver.size()-1).x, ver.get(ver.size() - 1).y);
    endShape();
  }
  
  void drawTriangle() {
    ArrayList<Point> tempVer = ver;
    if (triangles.size() == 0 ) {
      formTriangle(tempVer);
    }
    for (Triangle tri:triangles) {
      tri.drawTriangle();
    } 
  }

  void getMost() {
    leftMost = new Point(width, 0);
    rightMost = new Point(0, 0);
    upMost = new Point(0, height);
    downMost = new Point(0, 0);

    for (int i = 0; i < ver.size (); i ++) {
      Point temp = ver.get(i);
      if (temp.x < leftMost.x) {
        leftMost = temp;
      }
      if (temp.x > rightMost.x) {
        rightMost = temp;
      }
      if (temp.y < downMost.y) {
        downMost = temp;
      }
      if (temp.y > upMost.y) {
        upMost = temp;
      }
    }
  }

  Point getLeftMost(ArrayList<Point> subVer) {
    Point result = new Point(width, 0);
    for (Point p : subVer) {
      if (p.x < result.x) {
        result = p;
      }
    }
    return result;
  }

  void formTriangle(ArrayList<Point> targetVer) {
    Point leftMost = getLeftMost(targetVer);
    Triangle test = new Triangle(leftMost, leftMost.adjacents.get(0), leftMost.adjacents.get(1));
    ArrayList<Point> insidePoints = new ArrayList();
    for (Point p:targetVer) {
      if (!test.checkInside(p)) {
        insidePoints.add(p);
      }
    }
    if (insidePoints.size() == 0) {
      triangles.add(test);
      targetVer.remove(leftMost);
      Point p0 = leftMost.adjacents.get(0);
      Point p1 = leftMost.adjacents.get(1);
      targetVer.remove(p0);
      targetVer.remove(p1);
      p0.adjacents.remove(leftMost);
      p1.adjacents.remove(leftMost);
      p0.adjacents.add(p1);
      p1.adjacents.add(p0);
      targetVer.add(p0);
      targetVer.add(p1);      
      formTriangle(targetVer);
    } else {
      Point leftMostInside = getLeftMost(insidePoints);
      targetVer.remove(leftMost);
      leftMost.adjacents.remove(1);
      leftMost.adjacents.add(leftMostInside);
      targetVer.add(leftMost);
      formTriangle(targetVer);
    }
  }

  boolean checkOver() {
    return true;
  }
}

