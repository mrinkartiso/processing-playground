    // Daniel Shiffman
    // http://youtube.com/thecodingtrain
    // http://codingtra.in
    //
    // Coding Challenge #24: Perlin Noise Flow  Field
    // https://youtu.be/BjoM9oKOAKY

    public class FlowField {
        PVector[] vectors;
        float[] imagePixels;
        int cols, rows;
        float inc = 0.1;
        float zoff = 0;
        int scl;

        FlowField(int res, PImage image) {
            scl = res;
            cols = floor(width / res) + 1;
            rows = floor(height / res) + 1;
            vectors = new PVector[cols * rows];


            image.filter(GRAY);
            image.resize(cols, rows);
            imagePixels = new float[cols * rows];
            image.loadPixels();

            int minG = 1000;
            int maxG = 0;
            float minM = 1000;
            float maxM = 0;

            for (int y = 0; y < rows; y++) {
                for (int x = 0; x < cols; x++) {
                    int index = x + y * cols;
                    int gray = gray(image.pixels[index]);
                    float mag = map(gray, 48, 180, 0.6 * PI, 0);
                    imagePixels[index] = mag;
                    // println(imagePixels[index]);
                    if (gray < minG) minG = gray;
                    if (gray > maxG) maxG = gray;
                    if (mag < minM) minM = mag;
                    if (mag > maxM) maxM = mag;
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

        int gray(int value) {
            return max((value >> 16) & 0xff, (value >> 8) & 0xff, value & 0xff);
        }
    }