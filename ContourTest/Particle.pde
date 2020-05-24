public class Particle {
  PVector pos;
  PVector vel;
  PVector acc;
  PVector previousPos;
  float maxSpeed;
  int maxAge, age;
   
  Particle(float maxspeed, int maxAge) {
    this.maxSpeed = maxspeed;
    this.maxAge = maxAge;
    age = 0;
    pos = new PVector(random(width), random(height));
    vel = new PVector(random(5) - 2.5, random(5) - 2.5);
    acc = new PVector(0, 0);
    previousPos = pos.copy();
  }
  void run(color particleColor) {
    update();
    edges();
    show(particleColor);
  }
  void update() {
    age++;
    if (age > maxAge) {
      pos = new PVector(random(width), random(height));
      previousPos = pos.copy();
      age = 0;
      vel = new PVector(random(5) - 2.5, random(5) - 2.5);
    }

    pos.add(vel);
    vel.add(acc);
    vel.limit(maxSpeed);
    acc.mult(0);
  }
    void applyForce(FlowField[] flowFields) {
      acc = new PVector(0, 0);
      for (FlowField flowField : flowFields) {
        PVector force = flowField.getForce(pos.x, pos.y);
        if (force != null) acc.add(force);
      } 
    }
  void show(color particleColor) {
    stroke(particleColor, 10);
    strokeWeight(1);
    line(pos.x, pos.y, previousPos.x, previousPos.y);
    //point(pos.x, pos.y);
    updatePreviousPos();
  }
  void edges() {
    if (pos.x > width) {
      pos.x = 0;
      updatePreviousPos();
    }
    if (pos.x < 0) {
      pos.x = width;    
      updatePreviousPos();
    }
    if (pos.y > height) {
      pos.y = 0;
      updatePreviousPos();
    }
    if (pos.y < 0) {
      pos.y = height;
      updatePreviousPos();
    }
  }
  void updatePreviousPos() {
    this.previousPos.x = pos.x;
    this.previousPos.y = pos.y;
  }
  void follow(FlowField[] flowFields) {
    applyForce(flowFields);
  }
}