Object newObject;
ArrayList<Point> points;
Button beginObjectButton;
Button endObjectButton;
Button renderButton;
boolean beginObject;
boolean endObject;
int renderType;


void setup() {
  size(1200, 600) ;
  background(255);
  beginObject = true;
  endObject = false;
  points = new ArrayList();
  beginObjectButton = new Button("Begin", #EEEEEE, #DDDDDD, 0.0, 0.0, 80, 40);
  endObjectButton = new Button("End", #EEEEEE, #DDDDDD, 81.0, 0.0, 80, 40);
  renderButton = new Button("Default", #EEEEEE, #DDDDDD, 162.0, 0.0, 80, 40);
  renderType = 1;
}

void draw() {  


  if (mousePressed && newObject == null && mouseY>40) {
    stroke(0);
    line(mouseX, mouseY, pmouseX, pmouseY);

    //Controlling the number of points
    if (getDistance(mouseX, mouseY, pmouseX, pmouseY)>2) {
      Point addPoint = new Point(mouseX, mouseY);
      if (points.size() > 0) {
        points.get(points.size() - 1).addAdjacents(addPoint);
        addPoint.addAdjacents(points.get(points.size()-1));
      }     
      points.add(addPoint);
      points.get(points.size() - 1).position = points.size() - 1;
    }
  }


  if (newObject != null) {
    switch(renderType) {
    case 1: 
      {
        newObject.drawObject();  
        break;
      }
    case 2: 
      {
        newObject.drawObjectLine();
        break;
      }
    case 3:
      {
        newObject.drawTriangle();
        break;
      }
    }
  }

  //Draw buttons
  beginObjectButton.drawButton();
  endObjectButton.drawButton();
  renderButton.drawButton();
}


void mouseClicked() {
  if (renderButton.checkOver()) {
    renderType ++;
    if (renderType == 4) {
      renderType = 1;
    }
    switch(renderType) {
    case 1: 
      {
        renderButton = new Button("Default", #EEEEEE, #DDDDDD, 162.0, 0.0, 80, 40);
        break;
      }
    case 2: 
      {
        renderButton = new Button("Line", #EEEEEE, #DDDDDD, 162.0, 0.0, 80, 40);
        break;
      }
    case 3:
      {
        renderButton = new Button("Triangle", #EEEEEE, #DDDDDD, 243.0, 0.0, 80, 40);
        break;
      }
    }
  }

  //Init a fresh space
  if (beginObjectButton.checkOver()) {
    println("Init new screen");
    background(255);
    newObject = null;
    points = new ArrayList();
  }

  //Create a new object
  if (endObjectButton.checkOver() && newObject == null) {
    println("Creating a new object");
    points.get(0).addAdjacents(points.get(points.size() - 1));
    newObject = new Object(points);
  }
}

float getDistance(float x1, float y1, float x2, float y2) {
  return sqrt((x1-x2)*(x1-x2) + (y1-y2)*(y1-y2));
}

