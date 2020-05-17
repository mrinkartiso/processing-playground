import gab.opencv.*;


PImage src, dst;
OpenCV opencv;

ArrayList<Contour> contours;
ArrayList<Contour> polygons;


void setup(){
    
    src = loadImage("artiso.png"); 
    size(1200, 625, P2D);

    opencv = new OpenCV(this, src);

    opencv.gray();
    opencv.threshold(70);
    dst = opencv.getOutput();
  
    contours = opencv.findContours();
    println("found " + contours.size() + " contours");

    background(255);
}

void draw() {
    noLoop();
    scale(0.5);
    image(src, 0, 0);
    image(dst, src.width, 0);
  
    noFill();
    strokeWeight(3);
    
    for (Contour contour : contours) {
      stroke(0, 255, 0);
      contour.draw();
      println(contour.getPoints());

      println(contour.getPolygonApproximationFactor());
      
      stroke(255, 0, 0);
      beginShape();
      for (PVector point : contour.getPolygonApproximation().getPoints()) {
        vertex(point.x, point.y);
      }
      endShape();
    }
}
