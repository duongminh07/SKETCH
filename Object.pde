class Object {
  PImage originalDraw;
  ArrayList<Point> allPoints;
  ArrayList<Point> boundVer;
  ArrayList<Point> interiorVer;
  ArrayList<Point> tempVer;
  ArrayList<Point> pins;
  Boolean[][] insidePoints;
  Boolean[][] edges;
  Point leftMost;
  Point rightMost;
  Point upMost;
  Point downMost;
  int dist;

  Object() {
    boundVer = new ArrayList();
    allPoints = new ArrayList();
    pins = new ArrayList();
    dist = 15;
  }

  Object(ArrayList<Point> boundVer, ArrayList<Point> allPoints, PImage image) {
    this.boundVer = boundVer;
    this.allPoints = allPoints;
    this.originalDraw = image;
    pins = new ArrayList();
    dist = 15;
  }

  void addBoundVertex(int x, int y) {
    Point p = new Point(x, y);
    boundVer.add(p);
  }

  void drawPoints() {
    for (int i = 0; i < boundVer.size (); i ++) {
      boundVer.get(i).drawPoint();
    }
  }

  void drawOriginal() {
    background(255);
    stroke(1);
    strokeWeight(1);
    for (Point p : allPoints) {
      point(p.x, p.y);
    }
  }

  void drawObject() {
    background(255);
    fill(250);    
    smooth();
    strokeWeight(1);
    stroke(0);
    beginShape();
    curveVertex(boundVer.get(0).x, boundVer.get(0).y);
    for (int i = 0; i < boundVer.size (); i ++) {
      curveVertex(boundVer.get(i).x, boundVer.get(i).y);
    }
    curveVertex(boundVer.get(boundVer.size() - 1).x, boundVer.get(boundVer.size()-1).y);
    endShape(CLOSE);
    drawPoints();
  }
  
  void mapTexture() {
    background(255);
    noFill();   
    smooth();
    strokeWeight(1);
    stroke(0);
    beginShape();
    curveVertex(boundVer.get(0).x, boundVer.get(0).y);
    for (int i = 0; i < boundVer.size (); i ++) {
      curveVertex(boundVer.get(i).x, boundVer.get(i).y);
    }
    curveVertex(boundVer.get(boundVer.size() - 1).x, boundVer.get(boundVer.size()-1).y);
    endShape(CLOSE);
    
    textureMode(IMAGE);
    beginShape();
    texture(originalDraw);
    vertex(0, 40, 0, 0);
    vertex(width, 40, width, 0);
    vertex(width, height, width, height - 40);
    vertex(0, height, 0, height - 40);
    endShape();
    
    drawPoints();
  }

  void drawObjectLine() {
    background(255);
    fill(250);
    stroke(0);
    strokeWeight(1);
    smooth();
    beginShape();
    for (int i = 0; i < boundVer.size (); i ++) {
      vertex(boundVer.get(i).x, boundVer.get(i).y);
    }
    endShape(CLOSE);
    drawPoints();
  }

  void drawGrid() {
    getMost();
    for (int i = leftMost.x - dist; i <= rightMost.x + dist; i += dist) {
      stroke(200);
      strokeWeight(1);
      line(i, upMost.y - dist, i, downMost.y + dist);
    }
    for (int i = upMost.y - dist; i <= downMost.y + dist; i +=dist) {
      stroke(200);
      strokeWeight(1);
      line(leftMost.x - dist, i, rightMost.x + dist, i);
    }
    drawPoints();
  }

  void drawInsideGrid() {
    for (int i = leftMost.x -dist; i <= rightMost.x + dist; i += dist) {
      for (int j = upMost.y - dist; j < downMost.y + dist; j += dist) {
        if (insidePoints[i][j]&&insidePoints[i][j+dist]
          &&insidePoints[i+dist][j]&&insidePoints[i + dist][j +dist]) {
          fill(#f20000);
          strokeWeight(1);
          stroke(200);
          rect(i, j, dist, dist);
        }
      }
    }
  }

  void objectSubdivision() {
    drawObjectLine();
    getInsidePoints();
    drawGrid();
    drawInsideGrid();
  }

  void getMost() {
    leftMost = new Point(width, 0);
    rightMost = new Point(0, 0);
    upMost = new Point(0, height);
    downMost = new Point(0, 0);

    for (int i = 0; i < boundVer.size (); i ++) {
      Point temp = boundVer.get(i);
      if (temp.x < leftMost.x) {
        leftMost = temp;
      }
      if (temp.x > rightMost.x) {
        rightMost = temp;
      }
      if (temp.y > downMost.y) {
        downMost = temp;
      }
      if (temp.y < upMost.y) {
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

  void getInsidePoints() {
    color c = color(250, 250, 250);
    getMost();
    insidePoints = new Boolean[width + 1][height + 1];
    for (int i = 1; i <= width; i ++) {
      for (int j = 1; j <= height; j ++) {
        //println(get(i, j));
        if (get(i, j) == c) {
          insidePoints[i][j] = true;
        } else {
          insidePoints[i][j] = false;
        }
      }
    }
  }

  void reduceBoundaryVertices() {
    tempVer = new ArrayList();
    println("Original size: " + boundVer.size());
    int start = 0;
    tempVer.add(boundVer.get(0));
    tempVer.get(0).adjacents.clear();
    tempVer.get(0).position = 0;
    while (start < boundVer.size () - 1) {
      int comparePoint = start + 1;
      while (true) {
        if (comparePoint >= boundVer.size() - 1) break;
        if (dist(boundVer.get(start).x, boundVer.get(start).y, boundVer.get(comparePoint).x, boundVer.get(comparePoint).y) < dist) {
          comparePoint +=1;
        } else {
          tempVer.get(tempVer.size() - 1).adjacents.add(boundVer.get(comparePoint));
          tempVer.add(boundVer.get(comparePoint));
          tempVer.get(tempVer.size() - 1).adjacents.clear();
          tempVer.get(tempVer.size() - 1).adjacents.add(tempVer.get(tempVer.size() - 2));
          tempVer.get(tempVer.size() - 1).position = tempVer.size() - 1;
          start = comparePoint;
          break;
        }
      }
      if (comparePoint >= boundVer.size() - 1) break;
    }
    tempVer.get(0).adjacents.add(tempVer.get(tempVer.size() - 1));
    tempVer.get(tempVer.size() - 1).adjacents.add(tempVer.get(0));
    boundVer = tempVer;
  }
  
  void getInteriorVer() {
    interiorVer = new ArrayList();
    for (int i = 0; i < boundVer.size(); i ++) {
      Point p0 = boundVer.get(i);
      Point p1 = p0.adjacents.get(0);
      Point p2 = p0.adjacents.get(1);
      Point mp01 = new Point((p0.x + p1.x)/2, (p0.y + p1.y)/2);
      Point mp02 = new Point((p0.x + p2.x)/2, (p0.y + p2.y)/2);
      PVector v01 = new PVector(p1.x - p0.x, p1.y - p0.y); 
      PVector v02 = new PVector(p2.x - p0.x, p2.y - p0.y);
      int c1 = round(-v01.x*mp01.x - v01.y*mp01.y);
      int c2 = round(-v02.x*mp02.x - v02.y*mp02.y);
      int sectY = round(-(c1 - v01.x/v02.x*c2)/(v01.y - v01.x*v02.y/v02.x)); 
      int sectX = round((-c1 - v01.y*sectY)/v01.x);
      if (sectX < 0 || sectX > width || sectY < 0 || sectY > height) {
        int c = round(-v01.x*p0.x - v01.y*p0.y);
        sectY = p0.y - dist*2;
        sectX = round((-c - v01.y*sectY)/v01.x);
      }
      //println(sectX + " " + round((-c2 - v02.y*sectY)/v02.x) + " " + p0.position);
      strokeWeight(1);
      line(p0.x, p0.y, sectX, sectY);
      float tempDist = dist(p0.x, p0.y, sectX, sectY);
      Point tempInterior = new Point(round((-p0.x + sectX) * (dist)/tempDist) + p0.x, round((-p0.y + sectY) * (dist)/tempDist) + p0.y);
      if (insidePoints[tempInterior.x][tempInterior.y] == null || !insidePoints[tempInterior.x][tempInterior.y]) {
        tempInterior = new Point(p0.x*2 - tempInterior.x, p0.y*2 - tempInterior.y);
      }
      interiorVer.add(tempInterior);
    }
    for (Point p:interiorVer) {
      p.drawPoint();
    }
  }

  boolean checkOver() {
    return true;
  }
}

