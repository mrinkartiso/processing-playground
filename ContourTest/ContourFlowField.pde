public class ContourFlowField {
    PVector[] vectors;
    float[] imagePixels;
    int cols, rows;
    float inc = 0.1;
    float zoff = 0;
    int scl;
    int magnitude;

    ContourFlowField(int res, ArrayList<Path> contours, int magnitude) {
        scl = res;
        this.magnitude = magnitude;
        cols = floor(width / res) + 1;
        rows = floor(height / res) + 1;
        vectors = new PVector[cols * rows];
        // for(int i = 0; i < cols * rows; i++) {
        //     vectors[i] = new PVector();
        // }
        
        for (Path contour : contours) {

            ArrayList<ArrayList<PVector>> bucketPoints = new ArrayList<ArrayList<PVector>>(cols * rows);
            for (int index = 0; index < cols * rows; index++) {
                bucketPoints.add(new ArrayList<PVector>());
            }

            PVector[] points = contour.getPoints();
            // println("PATH");
            // println(points);
            int numberOfPoints = points.length;

            for (int i = 0; i < numberOfPoints; i += 1) {
                PVector start = points[i];
                
                int x = floor(start.x / res);
                int y = floor(start.y / res);
                int index = x + y * cols;
                
                
                bucketPoints.get(index).add(start);
            }

            for (int index = 0; index < cols * rows; index++) {
                ArrayList<PVector> bucket = bucketPoints.get(index);
                if (bucket == null || bucket.size() == 0) continue;

                PVector start = bucket.get(0);
                PVector end = bucket.get(bucket.size() - 1);
                PVector force = PVector.sub(end, start);
                // println(bucket);
                // println("start: ", start, " - end: ", end, " - force: ", force, " - index: ", index);

                if (vectors[index] == null) {
                    vectors[index] = force;
                } else {
                    vectors[index] = vectors[index].add(force); 
                }
            }
        }

        for (PVector v: vectors){
            if (v != null) v.setMag(4);
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
                v.setMag(magnitude);
                vectors[index] = v;

                xoff += inc;
            }
            yoff += inc;
        }
        zoff += 0.004;
    }

    void display() {
        stroke(255, 0, 0);
        strokeWeight(1);
        for (int y = 0; y < rows; y++) {
            for (int x = 0; x < cols; x++) {
                int index = x + y * cols;
                PVector v = vectors[index];

                if (v == null) continue;

                pushMatrix();
                translate(x * scl, y * scl);
               
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