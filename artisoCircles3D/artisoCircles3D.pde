import com.hamoid.*;

PImage logo;
PShape cylinder;
PShader colorShader;

boolean renderVideo = false;
String videoName = "Capture_artiso_logo.mp4";
VideoExport videoExport;

void setup(){
    size(1200, 624, P3D);
    logo = loadImage("artiso.png");
    logo.loadPixels();
    cylinder = createCylinder(8, 20, 32);

    if (renderVideo) {
        videoExport = new VideoExport(this, videoName);
    }
}

void draw(){
    background(100);
    lights();

    float camerax = map(mouseX, 0, width, 1, width);
    float cameraz = map(mouseY, 0, height, 1, 1500);
    surface.setTitle("CameraX: " + camerax + " - CameraZ: " + cameraz + " - Framerate: " + frameRate);
    // cameraX width/2.0
    // cameraZ (height/2.0) / tan(PI*30.0 / 180.0)
    camera(camerax, height/2.0, cameraz, width/2.0, height/2.0, 0, 0, 1, 0);
 
    rotateX(.3);

    int diameter = 20;

    for (int x = 0; x < width; x+=20) {
        for (int y = 0; y < height; y+=diameter) {
            push();
            int pixelvalue = logo.pixels[x + y * logo.width];
            float scale = map(brightness(pixelvalue), 190, 40, 1, map(sin(radians(frameCount)), -1, 1, 2, 10));
            
            
            scale(1, 1, scale);
            translate(x, y);
            shape(cylinder);
            pop();
        }
    }

    if (renderVideo) {
        videoExport.saveFrame();
    }
}

void keyPressed() {
    if (renderVideo && key == 's') {
        videoExport.startMovie();
    }

    if (renderVideo && key == 'q') {
        videoExport.endMovie();
        exit();
    }
}

// this is mostly the old code, with added shapes
PShape createCylinder(float r, float h, int sides) {
  push();
  translate(0, h/2);
  PShape cylinder = createShape(GROUP);
   
  float angle = 360 / sides;
  float halfHeight = h / 2;
 
  // draw top of the tube
  PShape top = createShape();
  top.beginShape();
//   top.noStroke();
  top.fill(100, 100, 200);
  for (int i = 0; i < sides; i++) {
    float x = cos( radians( i * angle ) ) * r;
    float y = sin( radians( i * angle ) ) * r;
    top.vertex( x, y, -halfHeight);
  }
  top.endShape(CLOSE);
  cylinder.addChild(top);
 
  // draw bottom of the tube
  PShape bottom = createShape();
  bottom.beginShape();
//   bottom.noStroke();
  bottom.fill(100, 100, 200);
  for (int i = 0; i < sides; i++) {
    float x = cos( radians( i * angle ) ) * r;
    float y = sin( radians( i * angle ) ) * r;
    bottom.vertex( x, y, halfHeight);
  }
  bottom.endShape(CLOSE);
  cylinder.addChild(bottom);
 
  // draw sides
  PShape middle = createShape();
  middle.beginShape(TRIANGLE_STRIP);
  middle.noStroke();
  middle.fill(100, 100, 200);
  for (int i = 0; i < sides + 1; i++) {
    float x = cos( radians( i * angle ) ) * r;
    float y = sin( radians( i * angle ) ) * r;
    middle.vertex( x, y, halfHeight);
    middle.vertex( x, y, -halfHeight);
  }
  middle.endShape(CLOSE);
  cylinder.addChild(middle);
  pop();
  return cylinder;
}
