public class Particle {
  PVector pos;
  PVector vel;
  PVector acc;
  PVector previousPos;
  float maxSpeed;
   
  Particle(PVector start, float maxspeed) {
    maxSpeed = maxspeed;
    pos = start;
    vel = new PVector(2, 0);
    acc = new PVector(0, 0);
    previousPos = pos.copy();
  }
  void run(color particleColor) {
    update();
    edges();
    show(particleColor);
  }
  void update() {
    pos.add(vel);
    vel.add(acc);
    vel.limit(maxSpeed);
    acc.mult(0);
  }
    void applyForce(FlowField[] flowFields) {
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