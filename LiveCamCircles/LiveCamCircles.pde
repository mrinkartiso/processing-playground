
import processing.video.*;

Capture cam;

PImage logo;

boolean is3D = false;

void settings() {
  if (is3D)
  {
    // size(1024, 768, P3D);
    fullScreen(P3D);
  } else {
    // size(1024, 768, P2D);
    fullScreen(P2D);
  }
}

void setup(){
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
    
    int diameter = int(map(mouseX, 0, width, 15, width / 10));
    float zDynamic = map(mouseY, 0, height, 2, height / 6);
    surface.setTitle("diameter: " + diameter + " - z dynamic: " + zDynamic + " - framerate: " + frameRate);
    PImage frame = cam.get();
    frame.resize(width/diameter, 0);
    frame.loadPixels();
    fill(48);
    noStroke();
    
    if (is3D) {
      translate(width/2, height/2);
      rotateY(frameCount / 30.0);
    } else {
      translate(diameter / 2, diameter / 2);
    }
    for (int x = 0; x < frame.width; x++) {
        for (int y = 0; y < frame.height; y++) {
            int pixelvalue = frame.pixels[x + y * frame.width];
            float pixelbrightness = brightness(pixelvalue);
            float value = map(pixelbrightness, 255, 0, diameter / 5.0, diameter);
            float zTranslate = map(pixelbrightness, 255, 0, -zDynamic, zDynamic);
            if (is3D) {
              push();
              translate(x * diameter - width/2, y * diameter - height/2, zTranslate);
              box(value);
              pop();
            } else {
              ellipse(x * diameter, y * diameter, value, value);
            }
        }
    }
}