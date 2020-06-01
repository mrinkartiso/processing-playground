class Path {

  // A Path is an arraylist of points (PVector objects)
  PVector[] points;
  // A path has a radius, i.e how far is it ok for the boid to wander off
  float radius;

  Path(PVector[] points) {
    // Arbitrary radius of 20
    radius = 20;
    this.points = points;
  }

  Path(PVector[] points, float radius) {
    // Arbitrary radius of 20
    this.radius = radius;
    this.points = points;
  }

  PVector[] getPoints() {
      return points;
  }

  PVector getStart() {
     return points[0];
  }

  PVector getEnd() {
     return points[points.length-1];
  }


  // Draw the path
  void display() {
    // Draw thick line for radius
    stroke(175);
    strokeWeight(radius*2);
    noFill();
    beginShape();
    for (PVector v : points) {
      vertex(v.x, v.y);
    }
    endShape();
    // Draw thin line for center of path
    stroke(0);
    strokeWeight(1);
    noFill();
    beginShape();
    for (PVector v : points) {
      vertex(v.x, v.y);
    }
    endShape();
  }
}