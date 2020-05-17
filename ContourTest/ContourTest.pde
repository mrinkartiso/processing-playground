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
    opencv.invert();
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

   
    push();
    translate(width, height);
    ArrayList<Path> paths = new ArrayList<Path>(contours.size());
    for (Contour contour : contours) {
        // println("CONTOUR");
        ArrayList<PVector> points = contour.getPoints();
        // println(points);
        PVector[] pointArray = new PVector[points.size()];
        points.toArray(pointArray);
        Path path = new Path(pointArray, 10);
        path.display();
        paths.add(path);
    }
    pop();

    ContourFlowField contourFlowField = new ContourFlowField(10, paths);
    contourFlowField.display();
}
