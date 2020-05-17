public class ContourFlowField {
    PVector[] vectors;
    float[] imagePixels;
    int cols, rows;
    float inc = 0.1;
    float zoff = 0;
    int scl;

    ContourFlowField(int res, ArrayList<Path> contours) {
        scl = res;
        cols = floor(width / res) + 1;
        rows = floor(height / res) + 1;
        vectors = new PVector[cols * rows];
        // for(int i = 0; i < cols * rows; i++) {
        //     vectors[i] = new PVector();
        // }
        
        for (Path contour : contours) {
            PVector[] points = contour.getPoints();
            // println("PATH");
            // println(points);
            int numberOfPoints = points.length;
            println("POINTS");
            for (int i = 0; i < numberOfPoints; i += 1) {
                PVector start = points[i];
                PVector end = points[(i + 1) % numberOfPoints];
                PVector force = PVector.sub(end, start);

                int x = floor(start.x / res);
                int y = floor(start.y / res);
                int index = x + y * cols;
                // println("start: ", start, " - end: ", end, " - index: ", index);
                
                if (vectors[index] == null) {
                    vectors[index] = force;
                } else {
                    vectors[index] = vectors[index].add(force); 
                }
            }
        }

        
    }

    void update() {
        float xoff = 0;
        for (int y = 0; y < rows; y++) {
            float yoff = 0;
            for (int x = 0; x < cols; x++) {
                int index = x + y * cols;

                float angle = (noise(xoff, yoff, zoff) * PI * 4) * imagePixels[index] + (PI / 2) * noise(zoff);
                // float angle = (noise(xoff, yoff, zoff) * PI - PI / 2) * imagePixels[index] + (PI / 2) * noise(zoff);

                PVector v = PVector.fromAngle(angle);
                v.setMag(6);
                vectors[index] = v;

                xoff += inc;
            }
            yoff += inc;
        }
        zoff += 0.004;
    }

    void display() {
        for (int y = 0; y < rows; y++) {
            for (int x = 0; x < cols; x++) {
                int index = x + y * cols;
                PVector v = vectors[index];

                if (v == null) continue;

                stroke(0, 0, 0);
                strokeWeight(1);
                pushMatrix();
                translate(x * scl, y * scl + height);
                rotate(v.heading());
                line(0, 0, scl, 0);
                popMatrix();
            }
        }
    }

    int gray(int value) {
        return max((value >> 16) & 0xff, (value >> 8) & 0xff, value & 0xff);
    }
}