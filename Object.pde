class Object {
  PImage originalDraw;
  ArrayList<Point> allPoints;
  ArrayList<Point> boundVer;
  ArrayList<Point> interiorVer;
  ArrayList<Point> tempVer;
  ArrayList<Point> pins;
  ArrayList<Point> objectNodes;
  ArrayList<Edge> objectEdges;
  Boolean[][] insidePoints;
  Boolean[][] insideInnerShell;
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
    objectEdges = new ArrayList();
    objectNodes = new ArrayList();
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

  void drawPoints(ArrayList<Point> points) {
    for (int i = 0; i < points.size (); i ++) {
      points.get(i).drawPoint();
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
    drawPoints(boundVer);
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

    drawPoints(boundVer);
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
    drawPoints(boundVer);
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
    drawPoints(boundVer);
  }

  void drawInsideGrid() {
    drawPoints(interiorVer);
    for (int i = leftMost.x -dist; i <= rightMost.x + dist; i += dist) {
      for (int j = upMost.y - dist; j < downMost.y + dist; j += dist) {
        if (insideInnerShell[i][j]&&insideInnerShell[i][j+dist]
          &&insideInnerShell[i+dist][j]&&insideInnerShell[i + dist][j +dist]) {
            objectEdges.add(new Edge(new Point(i, j), new Point(i, j + dist)));
            objectEdges.add(new Edge(new Point(i, j + dist), new Point(i + dist, j + dist)));
            objectEdges.add(new Edge(new Point(i + dist, j + dist), new Point(i + dist, j)));
            objectEdges.add(new Edge(new Point(i, j), new Point(i + dist, j)));
        }
      }
    }
  }

  void objectSubdivision() {
    objectEdges = new ArrayList();   
    drawObjectLine();
    getInsidePoints();
    getInteriorVer();
    getInsideInnerShell();
    drawGrid();
    drawInsideGrid();
    for (int i = 0; i < boundVer.size() - 2; i ++) {
      objectEdges.add(new Edge(boundVer.get(i), boundVer.get(boundVer.get(i).position + 1)));
      objectEdges.add(new Edge(interiorVer.get(i), interiorVer.get(boundVer.get(i).position + 1)));
      objectEdges.add(new Edge(interiorVer.get(i), boundVer.get(i)));
    }
    objectEdges.add(new Edge(boundVer.get(boundVer.size() - 2), boundVer.get(boundVer.size() - 1)));
    objectEdges.add(new Edge(interiorVer.get(boundVer.size() - 2), interiorVer.get(boundVer.size() - 1)));
    objectEdges.add(new Edge(interiorVer.get(boundVer.size() - 2), boundVer.get(boundVer.size() - 2)));
    
    objectEdges.add(new Edge(boundVer.get(0), boundVer.get(boundVer.size() - 1)));
    objectEdges.add(new Edge(interiorVer.get(0), interiorVer.get(boundVer.size() - 1)));
    objectEdges.add(new Edge(interiorVer.get(boundVer.size() - 1), boundVer.get(boundVer.size() - 1)));
    for (Edge e:objectEdges) {
      e.drawEdge();
    }
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
    insidePoints = new Boolean[width + 1][height + 1];
    for (int i = 0; i <= width; i ++) {
      for (int j = 0; j <= height; j ++) {
        //println(get(i, j));
        if (get(i, j) == c) {
          insidePoints[i][j] = true;
        } else {
          insidePoints[i][j] = false;
        }
      }
    }
  }
  
  void getInsideInnerShell() {
    background(255);
    fill(250);
    stroke(0);
    strokeWeight(1);
    smooth();
    beginShape();
    for (int i = 0; i < interiorVer.size (); i ++) {
      vertex(interiorVer.get(i).x, interiorVer.get(i).y);
    }
    endShape(CLOSE);
    color c = color(250, 250, 250);
    insideInnerShell = new Boolean[width + 1][height + 1];
    for (int i = 0; i <= width; i ++) {
      for (int j = 0; j <= height; j ++) {
        //println(get(i, j));
        if (get(i, j) == c) {
          insideInnerShell[i][j] = true;
        } else {
          insideInnerShell[i][j] = false;
        }
      }
    }
    background(255);
  }

  void optimizeBoundaryVertices() {
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
        float tempDist = dist(boundVer.get(start).x, boundVer.get(start).y, boundVer.get(comparePoint).x, boundVer.get(comparePoint).y);
        if (tempDist < dist) {
          //distance too small, skip the point
          comparePoint +=1;
        } else {
          if (tempDist >= dist*1.5) {
            //distance too large, create additional points
            int numberOfAddPoints = floor(tempDist/dist);
            for (int i = 1; i < numberOfAddPoints; i ++) {
              Point extraPoint = new Point (round((-boundVer.get(start).x + boundVer.get(comparePoint).x)*dist*i/tempDist + boundVer.get(start).x), round((-boundVer.get(start).y + boundVer.get(comparePoint).y) * dist*i/tempDist + boundVer.get(start).y));
              tempVer.get(tempVer.size() - 1).adjacents.add(extraPoint);
              tempVer.add(extraPoint);
              tempVer.get(tempVer.size() - 1).adjacents.add(tempVer.get(tempVer.size() - 2));
              tempVer.get(tempVer.size() - 1).position = tempVer.size() - 1;
            }
          }
          //add the point
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
    if (dist(tempVer.get(0).x, tempVer.get(0).y, tempVer.get(tempVer.size()-1).x, tempVer.get(tempVer.size()-1).y) > dist*1.5) {
      Point lastPoint = new Point(tempVer.get(tempVer.size()-1).x, tempVer.get(tempVer.size()-1).y);
      float tempDist = dist(tempVer.get(0).x, tempVer.get(0).y, tempVer.get(tempVer.size()-1).x, tempVer.get(tempVer.size()-1).y);
      int numberOfAddPoints = floor(tempDist/dist);
      for (int i = 1; i < numberOfAddPoints; i ++) {
        Point extraPoint = new Point (round((-lastPoint.x + tempVer.get(0).x)*dist*i/tempDist + lastPoint.x), round((-lastPoint.y + tempVer.get(0).y) * dist*i/tempDist + lastPoint.y));
        tempVer.get(tempVer.size() - 1).adjacents.add(extraPoint);
        tempVer.add(extraPoint);
        tempVer.get(tempVer.size() - 1).adjacents.add(tempVer.get(tempVer.size() - 2));
        tempVer.get(tempVer.size() - 1).position = tempVer.size() - 1;
      }
    }
    tempVer.get(0).adjacents.add(tempVer.get(tempVer.size() - 1));
    tempVer.get(tempVer.size() - 1).adjacents.add(tempVer.get(0));
    boundVer = tempVer;
  }

  void getInteriorVer() {
    interiorVer = new ArrayList();
    ArrayList<Point> intersects = new ArrayList();

    //get intersects 
    for (int i = 0; i < boundVer.size (); i ++) {
      Point p0 = boundVer.get(i);
      Point p1 = p0.adjacents.get(0);
      Point p2 = p0.adjacents.get(1);
      Point mp01 = new Point((p0.x + p1.x)/2, (p0.y + p1.y)/2);
      Point mp02 = new Point((p0.x + p2.x)/2, (p0.y + p2.y)/2);
      PVector v01 = new PVector(p1.x - p0.x, p1.y - p0.y); 
      PVector v02 = new PVector(p2.x - p0.x, p2.y - p0.y);
      int c1 = round(-v01.x*mp01.x - v01.y*mp01.y);
      int c2 = round(-v02.x*mp02.x - v02.y*mp02.y);
      int sectX, sectY;
      int c = round(-v01.x*p0.x - v01.y*p0.y);
      // //case
      if (v01.x == v02.x && v01.y == v02.y) {
        println("Get // case");

        if (v01.x != 0) {
          sectY = p0.y - dist*2;
          sectX = round((-c - v01.y*sectY)/v01.x);
        } else {
          sectY = p0.y;
          sectX =p0.x - dist*2;
        }
      } else {
        sectY = round(-(c1 - v01.x/v02.x*c2)/(v01.y - v01.x*v02.y/v02.x)); 
        sectX = round((-c1 - v01.y*sectY)/v01.x);
      }

      //if intersect jumps out of the screen
      if (sectX <= 0 || sectX >= width || sectY <= 0 || sectY >= height) {
        if (v01.x != 0) {
          sectY = p0.y - dist*2;
          sectX = round((-c - v01.y*sectY)/v01.x);
        } else {
          sectY = p0.y;
          sectX =p0.x - dist*2;
        }
      }
      Point tempIntersect = new Point(sectX, sectY);
      tempIntersect.position = i;
      intersects.add(tempIntersect);
    }

    Boolean[] moved = new Boolean[boundVer.size()];
    for (int i = 0; i < boundVer.size (); i ++) {
      moved[i] = false;
    }

    ArrayList<Point> tempInteriors;
    //initialize interior
    for (Point p : boundVer) {
      Point newPoint = new Point(p.x, p.y);
      newPoint.position = p.position;
      interiorVer.add(newPoint);
    } 

    tempInteriors = new ArrayList();
    for (int fraction = 1; fraction <= dist; fraction ++) {

      //move all interior points by one unit of distance
      for (Point movingPoint : boundVer) {
        if (!moved[movingPoint.position]) {
          //get intersect point
          Point movingPointInt = intersects.get(movingPoint.position);
          float tempDist = dist(movingPoint.x, movingPoint.y, movingPointInt.x, movingPointInt.y);

          //get temp interior point by fraction
          Point tempInterior = new Point(round((-movingPoint.x + movingPointInt.x) * (fraction)/tempDist) + movingPoint.x, round((-movingPoint.y + movingPointInt.y) * (fraction)/tempDist) + movingPoint.y);
          if (insidePoints[tempInterior.x][tempInterior.y] == null || !insidePoints[tempInterior.x][tempInterior.y]) {
            tempInterior = new Point(movingPoint.x*2 - tempInterior.x, movingPoint.y*2 - tempInterior.y);
          }    
          tempInterior.position = movingPoint.position;

          if (fraction == 1) {
            tempInteriors.add(tempInterior);
          } else {
            tempInteriors.get(tempInterior.position).x = tempInterior.x;
            tempInteriors.get(tempInterior.position).y = tempInterior.y;
          }
        }
      }

      //testing new points
      for (Point tInterior : tempInteriors) {
        if (!moved[tInterior.position]) {
          boolean check = true;
          Point originalPoint = boundVer.get(tInterior.position);
          Point ad1 = originalPoint.adjacents.get(0);
          Point ad2 = originalPoint.adjacents.get(1);
          Triangle movingPointTri = new Triangle(tInterior, ad1, ad2);
          Triangle testTri1 = new Triangle(ad1, tInterior, tempInteriors.get(ad1.position));
          Triangle testTri2 = new Triangle(ad2, tInterior, tempInteriors.get(ad2.position));
          //check all testing moved points
          for (Point checkInteriorPoint : tempInteriors) {
            if (movingPointTri.checkInside(checkInteriorPoint) || testTri1.checkInside(checkInteriorPoint) ||  testTri2.checkInside(checkInteriorPoint)) {
              check = false;
              moved[originalPoint.position] = true;
              moved[checkInteriorPoint.position] = true;
              break;
            }
          }

          if (check) {
            //add a new accepted point
            interiorVer.get(tInterior.position).x = tInterior.x;
            interiorVer.get(tInterior.position).y = tInterior.y;
          }
        }
      }
    }
    for (Point p : interiorVer) {
      p.drawPoint();
    }
  }

  boolean checkOver() {
    return true;
  }
}

