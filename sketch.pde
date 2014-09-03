Object newObject;
ArrayList<Point> points;
Button beginObjectButton;
Button endObjectButton;
boolean beginObject;
boolean endObject;

void setup() {
  size(1500, 800) ;
  background(255);
  newObject = new Object();
  beginObject = true;
  endObject = false;
  beginObjectButton = new Button("Begin", #EEEEEE, #DDDDDD, 0.0, 0.0, 80, 40);
  endObjectButton = new Button("End", #EEEEEE, #DDDDDD, 80.0, 0.0, 80, 40);
}

void draw() {
  beginObjectButton.drawButton();
  endObjectButton.drawButton();
  if (mousePressed) {
    line(mouseX, mouseY, pmouseX, pmouseY);
    newObject.addVertex(mouseX, mouseY);
  }
}

