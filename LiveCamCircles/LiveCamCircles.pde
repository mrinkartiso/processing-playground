
import processing.video.*;

Capture cam;

PImage logo;

void setup(){
    size(640, 480, P2D);

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

    cam = new Capture(this, cameras[5]);
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
    
    int diameter = int( map(mouseX, 0, width, 5, 50));
    cam.loadPixels();
    fill(0);
    stroke(0);
    for (int x = diameter/2; x < width; x+=diameter) {
        for (int y = diameter/2; y < height; y+=diameter) {
            int pixelvalue = cam.pixels[x + y * cam.width];
            float pixelbrightness = brightness(pixelvalue);
            float value = map(pixelbrightness, 190, 40, 0, diameter);
            ellipse(x, y, value, value);
        }
    }
}