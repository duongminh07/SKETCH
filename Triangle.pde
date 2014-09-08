class Triangle {
  Point a, b, c;
  PVector vectorAB, vectorBA, vectorBC, vectorCB, vectorAC, vectorCA;
  float angleA;
  float angleB;
  float angleC;

  Triangle(Point a, Point b, Point c) {
    this.a = a;
    this.b = b;
    this.c = c;
    vectorAB = new PVector(b.x - a.x, b.y - a.y);
    vectorBA = new PVector(-vectorAB.x, -vectorAB.y);
    vectorBC = new PVector(c.x - b.x, c.y - c.y);
    vectorCB = new PVector(-vectorBC.x, -vectorBC.y);
    vectorAC = new PVector(c.x - a.x, c.y - a.y);
    vectorCA = new PVector(-vectorAC.x, -vectorAC.y);
    pushMatrix();
    translate(a.x, a.y);
    angleA = PVector.angleBetween(vectorAB, vectorAC);
    println(degrees(angleA) + " " + vectorAB.x + " " + vectorAB.y + " " + vectorAC.x + " " + vectorAC.y);
    popMatrix();
    pushMatrix();
    translate(b.x, b.y);
    angleB = PVector.angleBetween(vectorBA, vectorBC);
    println(degrees(angleB) + " " + b.x + " " + b.y);
    popMatrix();
    pushMatrix();
    translate(c.x, c.y);
    angleC = PVector.angleBetween(vectorCA, vectorCB);
    println(degrees(angleC) + " " + c.x + " " + c.y);
    popMatrix();
  }

  boolean checkInside(Point p) {
    boolean result = false;
    PVector pA = new PVector(a.x - p.x, a.y - p.y);
    PVector pB = new PVector(b.x - p.x, b.y - p.y);
    PVector pC = new PVector(c.x - p.x, c.y - p.y);

    if (checkInsideTwoVectors(pA, vectorAB, vectorAC) 
      && checkInsideTwoVectors(pB, vectorBC, vectorBA) 
      && checkInsideTwoVectors(pC, vectorCA, vectorCB)) 
      result = true;

    return result;
  }

  boolean checkInsideTwoVectors(PVector v, PVector v1, PVector v2) {
    if (degrees(PVector.angleBetween(v, v2)) > degrees(PVector.angleBetween(v1, v2)) 
      || degrees(PVector.angleBetween(v, v1)) > degrees(PVector.angleBetween(v1, v2)) ) 
      return false;
    else return true;
  }

  void drawTriangle () {
    fill(#EEEEEE);
    stroke(0);
    triangle(a.x, a.y, b.x, b.y, c.x, c.y);
  }
}

