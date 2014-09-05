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
  
  //Draw buttons
  beginObjectButton.drawButton();
  endObjectButton.drawButton();
  if (mousePressed && newObject == null && mouseY>40) {
    stroke(0);
    line(mouseX, mouseY, pmouseX, pmouseY);
    
    //Controlling the number of points
    if (getDistance(mouseX,mouseY, pmouseX, pmouseY)>2)
      points.add(new Point((float)mouseX, (float)mouseY));
  }
  
  //Create a new object
  if (endObjectButton.checkPressed() && newObject == null) {
    newObject = new Object(points);
    newObject.drawObject();
  }
  
  //Init a fresh space
  if (beginObjectButton.checkPressed()) {
    background(255);
    newObject = null;
    points = new ArrayList();
  }
}

float getDistance(float x1, float y1, float x2, float y2) {
  return sqrt((x1-x2)*(x1-x2) + (y1-y2)*(y1-y2));
}

