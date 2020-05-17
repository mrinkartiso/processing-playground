import gab.opencv.*;


PImage src, dst;
OpenCV opencv;

ArrayList<Contour> contours;
ArrayList<Contour> polygons;

ArrayList<Path> paths;
FlowField flowField;
ContourFlowField contourFlowField;
ArrayList<Particle> particles;

color orange = color(243, 147, 37);
color anthrazit = color(74, 74, 73);
color[] colors;

int flowFieldScale = 10;
int flowFieldMag = 1;
int contourFlowFieldMag = 10;
int numberOfParticles = 50000;

boolean debug = false;

void setup(){
    
    src = loadImage("artiso.png"); 
    size(1200, 625, P2D);

    flowField = new FlowField(flowFieldScale, flowFieldMag);

    opencv = new OpenCV(this, src);

    opencv.gray();
    opencv.threshold(70);
    opencv.invert();
    dst = opencv.getOutput();
  
    contours = opencv.findContours();
    println("found " + contours.size() + " contours");

    paths = new ArrayList<Path>(contours.size());
    for (Contour contour : contours) {
        ArrayList<PVector> points = contour.getPoints();
        PVector[] pointArray = new PVector[points.size()];
        points.toArray(pointArray);
        Path path = new Path(pointArray, 10);
        paths.add(path);
    }

    contourFlowField = new ContourFlowField(flowFieldScale, paths, contourFlowFieldMag);

    particles = new ArrayList<Particle>();
  
    for (int i = 0; i < numberOfParticles; i++) {
        PVector start = new PVector(random(width), random(height));

        particles.add(new Particle(start, random(2, 4)));
    }

    colors = new color[2];
    colors[0] = anthrazit;
    colors[1] = orange;

    background(255);
    frameRate(30);
}

void draw() {
    // scale(0.5);
    // image(src, 0, 0);
    // image(dst, src.width, 0);
  
    // noFill();
    // strokeWeight(3);

   
    // push();
    // translate(width, height);
    // for (Path path: paths) {
    //     path.display();
    // }
    // pop();

    // push();
    // translate(0, height);

    flowField.update();

    fill(255,10);
    rect(0,0,width,height);
    if (debug) {
        contourFlowField.display();
        flowField.display();
    }
    for (Particle p : particles) {
        p.follow(flowField, contourFlowField);
        p.run(colors[0]);
    }
    // pop();
}
