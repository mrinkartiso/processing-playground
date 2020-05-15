// Daniel Shiffman
// http://youtube.com/thecodingtrain
// http://codingtra.in
//
// Coding Challenge #24: Perlin Noise Flow  Field
// https://youtu.be/BjoM9oKOAKY

FlowField flowfield;
ArrayList<Particle> particles;

PImage image;

boolean debug = false;

color orange = color(243, 147, 37);
color anthrazit = color(74, 74, 73);
color[] colors;
int colorIndex = 0;
float colorOffset = 0;

void setup() {
  size(1200, 625, P2D);

  image = loadImage("artiso.png");

  flowfield = new FlowField(6, image);
  flowfield.update();

  colors = new color[2];
  colors[0] = anthrazit;
  colors[1] = orange;

  particles = new ArrayList<Particle>();
  
  for (int i = 0; i < 50000; i++) {
    PVector start = new PVector(random(width), random(height));

    particles.add(new Particle(start, random(2, 4)));
  }
  background(255);
}

void draw() {
    fill(255,10);
    rect(0,0,width,height);
    flowfield.update();
    
    if (debug) flowfield.display();

    // colorIndex = round(map(noise(colorOffset), 0.0, 1.0, 0.0, 0.8));
    // colorOffset += 0.004;
    
    for (Particle p : particles) {
        p.follow(flowfield);
        p.run(colors[colorIndex]);
    }
}