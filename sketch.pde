Object newObject;
ArrayList<Point> points;
Button beginObjectButton;
Button endObjectButton;
boolean beginObject;
boolean endObject;

void setup() {
  size(1500, 800) ;
  background(255);
  beginObject = true;
  endObject = false;
  points = new ArrayList();
  beginObjectButton = new Button("Begin", #EEEEEE, #DDDDDD, 0.0, 0.0, 80, 40);
  endObjectButton = new Button("End", #EEEEEE, #DDDDDD, 81.0, 0.0, 80, 40);
}

void draw() {
  beginObjectButton.drawButton();
  endObjectButton.drawButton();
  if (mousePressed && newObject == null) {
    stroke(0);
    line(mouseX, mouseY, pmouseX, pmouseY);
    points.add(new Point((float)mouseX, (float)mouseY));
  }
  if (endObjectButton.checkPressed() && newObject == null) {
    newObject = new Object(points);
    newObject.drawObject();
  }
  
  if (beginObjectButton.checkPressed()) {
    background(255);
    newObject = null;
    points = new ArrayList();
  }
}

