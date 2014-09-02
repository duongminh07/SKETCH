class Button {
  String name;
  int colorR;
  int colorG;
  int colorB;
  float opacity;
  Point position;
  int sizeX;
  int sizeY;
  
  Button(String name, int cR, int cG, int cB, float op, Float pX, Float pY, int sX, int sY) {
    this.name = name;
    this.colorR = cR;
    this.colorG = cG;
    this.colorB = cB;
    this opacity = op;
    this.position =  new Point(pX, pY);
    this.sizeX = sX;
    this.sizeY = sY;
  }
  
  
}
