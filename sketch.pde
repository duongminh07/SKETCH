Object newObject;
ArrayList<Point> points;
boolean beginObject;
boolean endObject;;void setup() {
  size(1500, 800);
  background(255);
  newObject = new Object();
  beginObject = true;
  endObject = false;
}

void draw() {
  if (mousePressed) {
    line(mouseX, mouseY, pmouseX, pmouseY);
    newObject.addVertex(mouseX, mouseY);
  }
}



