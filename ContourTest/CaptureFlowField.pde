import processing.video.*;
import gab.opencv.*;
import java.awt.*;

public class CaptureFlowField extends FlowField {
    float[] imagePixels;
    float inc = 0.1;
    float zoff = 0;
    int magnitude;

    float widthFactor, heightFactor;

    OpenCV opencv;

    Capture cam;
    PImage frame;
    PApplet applet;

    CaptureFlowField(PApplet applet, int res) {
        this.applet = applet;
        scl = res;
        cols = floor(width / res) + 1;
        rows = floor(height / res) + 1;
        vectors = new PVector[cols * rows];
        println("CaptureFlowField ", cols, " x ", rows);
        
        for(int i = 0; i < cols * rows; i++) {
            vectors[i] = new PVector();
        }

        String[] cameras = Capture.list();

        if (cameras == null) {
            println("Failed to retrieve the list of available cameras, will try the default...");
            cam = new Capture(applet, 640, 480);
        } if (cameras.length == 0) {
            println("There are no cameras available for capture.");
            exit();
        } else {
            println("Available cameras:");
            printArray(cameras);
    
            cam = new Capture(applet, cameras[2]);
            cam.start();
        }
    }

    public void update() {
        // if (frame != null) image(frame, 0, 0);

        if (cam.available() == true) {
            cam.read();

            if (opencv == null) {
                opencv = new OpenCV(applet, cam.width, cam.height);
                widthFactor = float(width) / cam.width;
                heightFactor = float(height) / cam.height;
            }

            opencv.loadImage(cam);
            opencv.gray();
            opencv.threshold();
            opencv.erode();
            opencv.erode();
            opencv.dilate();
            opencv.dilate();
            // opencv.invert();
            frame = opencv.getSnapshot();
            // frame = frame.get();
            // frame.resize(width, 0);    

            // opencv.findCannyEdges(20,75);
            // frame = opencv.getSnapshot();

            ArrayList<Contour> contours = opencv.findContours();
            // println("found " + contours.size() + " contours");

            // push();
            // stroke(255, 0, 0);
            // for (Contour contour : contours) {
            //     contour.draw();
            // }
            // pop();

            for (Contour contour : contours) {
                ArrayList<PVector> points = contour.getPoints();
                ArrayList<ArrayList<PVector>> bucketPoints = new ArrayList<ArrayList<PVector>>(cols * rows);
                for (int index = 0; index < cols * rows; index++) {
                    bucketPoints.add(new ArrayList<PVector>());
                }

                int numberOfPoints = points.size();

                for (int i = 0; i < numberOfPoints; i += 1) {
                    PVector start = points.get(i);
                    
                    int x = floor(start.x / scl * widthFactor);
                    int y = floor(start.y / scl * heightFactor);
                    int index = x + y * cols;
                    
                    bucketPoints.get(index).add(start);
                }

                for (int index = 0; index < cols * rows; index++) {
                    ArrayList<PVector> bucket = bucketPoints.get(index);
                    if (bucket == null || bucket.size() == 0) {
                        vectors[index] = null;
                        continue;
                    }

                    PVector start = bucket.get(0);
                    PVector end = bucket.get(bucket.size() - 1);
                    PVector force = PVector.sub(end, start);

                    if (vectors[index] == null) {
                        vectors[index] = force;
                    } else {
                        vectors[index] = vectors[index].add(force); 
                    }
                }
            }

            for (PVector v: vectors){
                if (v != null) v.setMag(10);
            }
        }
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