class Button {
  String name;
  color col;
  color colOver;
  color colBase;
  float opacityBase;
  Point position;
  int sizeX;
  int sizeY;
  color buttonBorder;

  Button(String name, color cb, color co, int pX, int pY, int sX, int sY) {
    this.name = name;
    this.colBase = cb;
    this.colOver = co;
    this.position =  new Point(pX, pY);
    this.sizeX = sX;
    this.sizeY = sY;
    buttonBorder = #BBBBBB;
  }

  void setColor(color cb, color co) {
    this.colBase = cb;
    this.colOver = co;
  }

  void drawButton() {
    update();
    fill(col);
    stroke(buttonBorder);
    strokeWeight(1);
    rect(position.getX(), position.getY(), sizeX, sizeY);   
    textSize(sizeY*0.5);
    textAlign(CENTER, CENTER);  
    fill(0);
    text(name, position.getX() + sizeX/2, position.getY() + sizeY/2);
  }

  boolean checkOver() {
    if (mouseX >= position.getX() && mouseX <= sizeX + position.getX() && 
      mouseY >= position.getY() && mouseY <= sizeY + position.getY()) {
      return true;
    } else {
      return false;
    }
  }

  boolean checkPressed() {
    if (mousePressed && checkOver()) {
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

    if (checkPressed()) {
      buttonBorder = 0;
    } else {
      buttonBorder = #BBBBBB;
    }
  }
}

