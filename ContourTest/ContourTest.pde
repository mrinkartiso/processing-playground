import com.hamoid.*;

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
int numberOfParticlesFactor = 15;
// int numberOfParticlesFactor = 15;
int numberOfParticles = 70000;

boolean debug = false;
boolean renderVideo = false;
String videoName = "EiffelTower.mp4";
VideoExport videoExport;

void setup(){
    // src = loadImage("EiffelTower.png"); 
    // size(980, 1400, P2D);
    src = loadImage("artiso.png"); 
    size(1200, 626, P2D);
    // println("eiffel: ", (980 * 1400) / 70000.0);
    // println("artiso: ", (1200 * 625) / 50000.0);
    numberOfParticles = floor(width * height / numberOfParticlesFactor);
    println("number of particles: ", numberOfParticles);

    

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
        PVector startPos = new PVector(random(width), random(height));

        particles.add(new Particle(startPos, random(2, 4)));
    }

    colors = new color[2];
    colors[0] = anthrazit;
    colors[1] = orange;

    background(255);
    
    if (renderVideo) {
        videoExport = new VideoExport(this, videoName);
        videoExport.startMovie();
    }
}

void draw() {
    flowField.update();

    fill(255,15);
    rect(0,0,width,height);
    if (debug) {
        // contourFlowField.display();
        flowField.display();
    }
    for (Particle p : particles) {
        p.follow(flowField, contourFlowField);
        p.run(colors[0]);
    }
    if (renderVideo) {
        videoExport.saveFrame();
    }
}
void keyPressed() {
    if (renderVideo && key == 'q') {
        videoExport.endMovie();
        exit();
    }
}
