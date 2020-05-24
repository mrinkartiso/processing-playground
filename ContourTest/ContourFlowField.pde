import gab.opencv.*;

public class ContourFlowField extends FlowField {
    float[] imagePixels;
    float inc = 0.1;
    float zoff = 0;
    int magnitude;

    ContourFlowField(PApplet applet, int res, int magnitude) {
        scl = res;
        this.magnitude = magnitude;
        cols = floor(width / res) + 1;
        rows = floor(height / res) + 1;
        vectors = new PVector[cols * rows];
        // for(int i = 0; i < cols * rows; i++) {
        //     vectors[i] = new PVector();
        // }

        opencv = new OpenCV(applet, src);

        opencv.gray();
        opencv.threshold(70);
        opencv.invert();
        dst = opencv.getOutput();
    
        ArrayList<Contour> contours = opencv.findContours();
        println("found " + contours.size() + " contours");

        paths = new ArrayList<Path>(contours.size());
        for (Contour contour : contours) {
            ArrayList<PVector> points = contour.getPoints();
            PVector[] pointArray = new PVector[points.size()];
            points.toArray(pointArray);
            Path path = new Path(pointArray, 10);
            paths.add(path);
        }
        
        for (Path contour : paths) {

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

    public void update() {
    }

    public void display() {
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