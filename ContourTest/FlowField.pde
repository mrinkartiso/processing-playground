public class FlowField {
    PVector[] vectors;
    int cols, rows;
    float inc = 0.1;
    float zoff = 0;
    int scl;
    int magnitude;

    FlowField(int res, int magnitude) {
        scl = res;
        this.magnitude = magnitude;
        cols = floor(width / res) + 1;
        rows = floor(height / res) + 1;
        vectors = new PVector[cols * rows];
    }

    void update() {
        float xoff = 0;
        for (int y = 0; y < rows; y++) {
            float yoff = 0;
            for (int x = 0; x < cols; x++) {
                int index = x + y * cols;
                float angle = noise(xoff, yoff, zoff) * TWO_PI * 2;
                // float angle = noise(xoff, yoff, zoff) * TWO_PI * 4;
                PVector v = PVector.fromAngle(angle);
                v.setMag(magnitude);
                vectors[index] = v;

                xoff += inc;
            }
            yoff += inc;
        }
        zoff += 0.003;
    }

    void display() {
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