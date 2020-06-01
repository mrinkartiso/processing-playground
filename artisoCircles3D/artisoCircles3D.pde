
PImage logo;
PShape can;
float angle;
PShader colorShader;

void setup(){
    size(1200, 625, P3D);
    logo = loadImage("artiso.png");
    logo.loadPixels();
    can = createCylinder(8, 20, 32);
    
    // camera(70.0, 35.0, 220.0, width/2, height/2, 0.0, 0.0, 1.0, 0.0);
    
    // float fov = PI/3.0;
    // float cameraZ = (height/2.0) / tan(fov/2.0);
    // perspective(fov, float(width)/float(height), cameraZ/10.0, cameraZ*10.0);
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
            shape(can);
            pop();
        }
    }

    translate(width/2, height/2);
    noStroke();
    fill(0, 0, 255);
    scale(1, 1, map(sin(radians(frameCount)), -1, 1, 1, 3));
    // rotateY(angle);
    
    
    
    angle += 0.01;
    
    // image(cam, 0, 0, width, height);

    // int( map(mouseX, 0, width, 5, 50));
    // logo.loadPixels();
    // fill(0);
    // stroke(0);
    // for (int x = diameter/2; x < width; x+=diameter) {
    //     for (int y = diameter/2; y < height; y+=diameter) {
    //         int pixelvalue = logo.pixels[x + y * logo.width];
    //         float pixelbrightness = brightness(pixelvalue);
    //         float value = map(pixelbrightness, 190, 40, 0, diameter);
    //         ellipse(x, y, value, value);
    //     }
    // }
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
