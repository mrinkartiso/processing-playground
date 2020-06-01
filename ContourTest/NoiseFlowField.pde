public class NoiseFlowField extends FlowField {
    float zoff = 0;
    int magnitude;

    NoiseFlowField(int res, int magnitude) {
        scl = res;
        this.magnitude = magnitude;
        cols = floor(width / res) + 1;
        rows = floor(height / res) + 1;
        vectors = new PVector[cols * rows];
        println("NoiseFlowField ", cols, " x ", rows);
    }

    public void update() {
        for (int y = 0; y < rows; y++) {
            for (int x = 0; x < cols; x++) {
                int index = x + y * cols;
                float angle = noise(x * 0.025, y * 0.025, zoff) * TWO_PI * 2;
                // float angle = noise(xoff, yoff, zoff) * TWO_PI;
                // float angle = noise(xoff, yoff, zoff) * TWO_PI * 4;
                PVector v = PVector.fromAngle(angle);
                v.setMag(magnitude);
                vectors[index] = v;
            }
        }
        zoff += 0.002;
    }

    public void display() {
        for (int y = 0; y < rows; y++) {
            for (int x = 0; x < cols; x++) {
                int index = x + y * cols;
                PVector v = vectors[index];

                stroke(0, 0, 0);
                strokeWeight(1);
                pushMatrix();
                translate(x * scl, y * scl);
                rotate(v.heading());
                line(0, 0, scl, 0);
                popMatrix();
            }
        }
    }
}