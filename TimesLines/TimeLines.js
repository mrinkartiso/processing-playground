const maxI = 300;
let n = 2;
let radius = 400;
let a = 0;
let aIncrement = 8;
let rotation = 0;
let margin = 50;
let translateX, translateY;

function setup() {
  createCanvas(2 * (radius + margin), 2 * (radius + margin));
  
  frameRate(20);

  
  radius = height / 2 - margin;
  translateX = width / 2;
  translateY = height / 2;
}

function draw() {
  background(0);
  translate(translateX, translateY);
    
  let currentI = 1;
  stroke(180, 180, 180, a);
  noFill();
  circle(0, 0, 2*radius);
  
  let degreePerStep = 360.0 / maxI;
  let startAngle, endAngle;
  for (; currentI < maxI; currentI++) {
    startAngle = radians(currentI * degreePerStep + rotation);
    endAngle = radians(n * currentI * degreePerStep + rotation);
    line(-cos(startAngle) * radius, -sin(startAngle) * radius, -cos(endAngle) * radius, -sin(endAngle) * radius); 
   
    rotation += 0.0002;
  }
  
  if (a < 500) {
    a += aIncrement;
    
    if (a <= -50) {
      n++;
      aIncrement *= -1;
    }
  } else {
    aIncrement *= -1;
    a += aIncrement;
  }
}