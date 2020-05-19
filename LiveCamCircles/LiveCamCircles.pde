
import processing.video.*;

Capture cam;

PImage logo;

void setup(){
    // size(640, 480, P2D);
    fullScreen(P2D);

    String[] cameras = Capture.list();

  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    cam = new Capture(this, 640, 480);
  } if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    printArray(cameras);

    cam = new Capture(this, cameras[2]);
    cam.start();
  }
}

void draw(){
    if (cam.available() == true) {
        cam.read();
    } else {
        return;
    }
    
    background(255);
    
    int diameter = int(map(mouseX, 0, width, 15, 100));
    surface.setTitle("diameter: " + diameter);
    PImage frame = cam.get();
    frame.resize(width/diameter, 0);
    frame.loadPixels();
    fill(0);
    noStroke();
    translate(diameter / 2, diameter / 2);
    for (int x = 0; x < frame.width; x++) {
        for (int y = 0; y < frame.height; y++) {
            int pixelvalue = frame.pixels[x + y * frame.width];
            float pixelbrightness = brightness(pixelvalue);
            float value = map(pixelbrightness, 255, 0, diameter / 5.0, diameter);
            ellipse(x * diameter, y * diameter, value, value);
        }
    }
}