class Button {
  String name;
  color col;
  color colOver;
  color colBase;
  float opacityBase;
  Point position;
  int sizeX;
  int sizeY;

  Button(String name, color cb, color co, Float pX, Float pY, int sX, int sY) {
    this.name = name;
    this.colBase = cb;
    this.colOver = co;
    this.position =  new Point(pX, pY);
    this.sizeX = sX;
    this.sizeY = sY;
  }

  void setColor(color cb, color co) {
    this.colBase = cb;
    this.colOver = co;
  }

  void drawButton() {
    update();
    fill(col);
    stroke(0);
    rect(position.getX(), position.getY(), sizeX, sizeY);   
    textSize(sizeY*0.5);
    textAlign(CENTER, CENTER);  
    fill(0);
    text(name, position.getX() + sizeX/2, position.getY() + sizeY/2);
  }

  boolean checkOver() {
    if (mouseX >= position.getX() && mouseX <= sizeX + position.getX() && 
      mouseY >= position.getY() && mouseY <= sizeY + position.getY()) {
      println("Begin button hovered " + mouseX + " " + mouseY);
      return true;
    } else {
      return false;
    }
  }
  
  void update() {
    if (checkOver()) {
      this.col = colOver;
    } else {
      this.col = colBase;
    }
  }
}

