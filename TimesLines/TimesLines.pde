int maxI = 300;
int n = 2000;
int radius = 1000;
int a = 0;
int aIncrement = 5;
float rotation = 0;
int margin = 50;
float translateX, translateY;
float rotationSpeed = 0.0002;

void settings() {
  size(2 * (radius + margin), 2 * (radius + margin), P2D);
  // fullScreen();
}

void setup() {
  frameRate(30);
  
  radius = height / 2 - margin;
  translateX = width / 2;
  translateY = height / 2;
  println(radius);
  println(translateX);
  println(translateY);
}

void draw() {
  background(0);
  translate(translateX, translateY);
    
  float currentI = 1;
  stroke(180, 180, 180, a);
  noFill();
  circle(0, 0, 2*radius);
  
  float degreePerStep = 360.0 / maxI;
  float startAngle, endAngle;
  for (; currentI < maxI; currentI++) {
    startAngle = radians(currentI * degreePerStep + rotation);
    endAngle = radians(n * currentI * degreePerStep + rotation);
    line(-cos(startAngle) * radius, -sin(startAngle) * radius, -cos(endAngle) * radius, -sin(endAngle) * radius); 
   
    rotation += rotationSpeed;
  }
  
  if (a < 500) {
    a += aIncrement;
    
    if (a <= -50) {
      n++;
      aIncrement *= -1;

      rotationSpeed = random(-0.0003, 0.0003);
    }
  } else {
    aIncrement *= -1;
    a += aIncrement;
  }
}
