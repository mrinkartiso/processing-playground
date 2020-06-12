
PImage logo;

void setup(){
    size(1200, 625, P2D);
    logo = loadImage("artiso.png");
    // logo.filter(GRAY);

    // logo.resize(logo.width / 6, 0);
    logo.loadPixels();

    background(255);
}

int currentCount = 0;

void draw(){
    int diameter = 10;
    int numberOfPoints = 10000;
    int totalCount = 0;

    for (int count = 0; count < 10 && currentCount < numberOfPoints;) {
        int x = int(random(logo.width));
        int y = int(random(logo.height));

        int pixelvalue = logo.pixels[x + y * logo.width];
        float pixelbrightness = brightness(pixelvalue);


        totalCount++;
        if (abs(randomGaussian() * 60) < pixelbrightness) {
            continue;
        }

        fill(100, 100);
        noStroke();
        ellipse(x, y, diameter, diameter);


        currentCount++;
        count++;
    }
}