Object newObject;
ArrayList<Point> points;
ArrayList<Point> allPoints;
ArrayList<Point> selectedPoints;
Button beginObjectButton;
Button endObjectButton;
Button renderButton;
Button drawModeButton;
boolean beginObject;
boolean endObject;
int renderType;
float zoom;
int drawMode;


void setup() {
  size(1200, 600) ;
  background(255);
  beginObject = true;
  endObject = false;
  points = new ArrayList();
  allPoints = new ArrayList();
  selectedPoints = new ArrayList();
  beginObjectButton = new Button("Begin", #EEEEEE, #DDDDDD, 0, 0, 80, 40);
  endObjectButton = new Button("End", #EEEEEE, #DDDDDD, 81, 0, 80, 40);
  renderButton = new Button("Original", #EEEEEE, #DDDDDD, 162, 0, 80, 40);
  drawModeButton = new Button("Boundary", #EEEEEE, #DDDDDD, 243, 0, 120, 40); 
  renderType = 1;
  zoom = 1;
  drawMode = 1;
}

void draw() {  
  scale(zoom);
  if (mousePressed && newObject == null && mouseY>40) {
    stroke(0);
    line(mouseX, mouseY, pmouseX, pmouseY);
    //Controlling the number of points
    if (dist(mouseX, mouseY, pmouseX, pmouseY)>2 && drawMode == 1) {
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
        newObject.drawOriginal();
        break;
      }
    case 2: 
      {
        newObject.drawObject();  
        drawSelectedPoint();
        break;
      }
    case 3: 
      {
        newObject.drawObjectLine();
        newObject.getInsidePoints();
        newObject.getInteriorVer();
        drawSelectedPoint();        
        break;
      }
    case 4: 
      {
        newObject.objectSubdivision();
        drawSelectedPoint();
        break;
      }
    case 5: 
      {
        newObject.mapTexture();
        drawSelectedPoint();
        break;
      }
    }
  }



  //Draw buttons
  beginObjectButton.drawButton();
  endObjectButton.drawButton();
  renderButton.drawButton();
  drawModeButton.drawButton();
}

void mousePressed() {
  
  //select points
  if (newObject != null) {
    for (Point p : newObject.boundVer) {
      if (p.hover()) {
        if (keyPressed && keyCode == CONTROL) {
          if (!selectedPoints.contains(p)) {
            selectedPoints.add(p);
            println("Add point (" + p.x + ", " + p.y + ") to selected points");
          } else {
            selectedPoints.remove(p);
            println("Remove point (" + p.x + ", " + p.y + ") from selected points");
          }
        } else {
          selectedPoints = new ArrayList();
          selectedPoints.add(p);
        }
      }
    }
  }
}


void mouseClicked() {


  //render button
  if (renderButton.checkOver()) {
    renderType ++;
    if (renderType == 6) {
      renderType = 1;
    }
    switch(renderType) {
    case 1: 
      {
        renderButton = new Button("Original", #EEEEEE, #DDDDDD, 162, 0, 80, 40);
        break;
      }
    case 2: 
      {
        renderButton = new Button("Curve", #EEEEEE, #DDDDDD, 162, 0, 80, 40);
        break;
      }
    case 3: 
      {
        renderButton = new Button("Line", #EEEEEE, #DDDDDD, 162, 0, 80, 40);
        break;
      }
    case 4: 
      {
        renderButton = new Button("Grid", #EEEEEE, #DDDDDD, 162, 0, 80, 40);
        break;
      }
    case 5: 
      {
        renderButton = new Button("Texture", #EEEEEE, #DDDDDD, 162, 0, 80, 40);
        break;
      }
    }
  }

  //drawMode button
  if (drawModeButton.checkOver()) {
    drawMode ++;
    if (drawMode == 3) {
      drawMode = 1;
    }
    switch(drawMode) {
    case 1: 
      {
        drawModeButton = new Button("Boundary", #EEEEEE, #DDDDDD, 243, 0, 120, 40);
        break;
      }
    case 2: 
      {
        drawModeButton = new Button("Interior", #EEEEEE, #DDDDDD, 243, 0, 120, 40);
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
    allPoints = new ArrayList();
  }

  //Create a new object
  if (endObjectButton.checkOver() && newObject == null && points.size() > 0) {
    println("Creating a new object");
    PImage image = get(0, 40, width, height - 40);
    points.get(0).addAdjacents(points.get(points.size() - 1));

    //get all points
    for (int i = 0; i < width; i ++) {
      for (int j = 40; j < height; j ++) {
        color c = color(255, 255, 255);
        if (get(i, j) != c) allPoints.add(new Point(i, j));
      }
    }

    //set up object
    newObject = new Object(points, allPoints, image);
    newObject.reduceBoundaryVertices();
    newObject.drawObjectLine();  
    newObject.getInsidePoints();
    background(255);
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  //zoom += e*0.3;
}

void mouseDragged() {
  if (newObject != null) {
    for (Point p : selectedPoints) {
      p.updatePoint(p.x + mouseX - pmouseX, p.y + mouseY - pmouseY);
    }
  }
}

void drawSelectedPoint() {
  for (Point p : selectedPoints) {
    stroke(#ffff00);
    strokeWeight(3);
    point(p.x, p.y);
  }
}

