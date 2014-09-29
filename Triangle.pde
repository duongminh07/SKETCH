class Triangle {
  Point a, b, c;
  PVector AB, BA, BC, CB, AC, CA;
  float angleA;
  float angleB;
  float angleC;

  Triangle(Point a, Point b, Point c) {
    this.a = a;
    this.b = b;
    this.c = c;
    AB = new PVector(b.x - a.x, b.y - a.y, 0);
    BA = new PVector(-AB.x, -AB.y, 0);
    BC = new PVector(c.x - b.x, c.y - b.y, 0);
    CB = new PVector(-BC.x, -BC.y, 0);
    AC = new PVector(c.x - a.x, c.y - a.y, 0);
    CA = new PVector(-AC.x, -AC.y, 0);
    pushMatrix();
    translate(a.x, a.y);
    angleA = PVector.angleBetween(AB, AC);
    popMatrix();
    pushMatrix();
    translate(b.x, b.y);
    angleB = PVector.angleBetween(BA, BC);
    popMatrix();
    pushMatrix();
    translate(c.x, c.y);
    angleC = PVector.angleBetween(CA, CB);
    popMatrix();
  }

  boolean checkInside(Point p) {
    boolean result = false;
    PVector AP = new PVector(p.x - a.x, p.y - a.y, 0);
    PVector BP = new PVector(p.x - b.x, p.y - b.y, 0);
    PVector CP = new PVector(p.x - c.x, p.y - c.y, 0);

    if (checkInsideTwoVectors(AP, AB, AC) 
      && checkInsideTwoVectors(BP, BC, BA) 
      && checkInsideTwoVectors(CP, CA, CB)) 
      result = true;

    return result;
  }

  boolean checkInsideTwoVectors(PVector v, PVector v1, PVector v2) {
    if (degrees(PVector.angleBetween(v, v2)) >= degrees(PVector.angleBetween(v1, v2)) 
      || degrees(PVector.angleBetween(v, v1)) >= degrees(PVector.angleBetween(v1, v2)) ) 
      return false;
    else return true;
  }

  void drawTriangle () {
    noFill();
    stroke(0);
    triangle(a.x, a.y, b.x, b.y, c.x, c.y);
  }
}

