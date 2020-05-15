void setup(){
    size(1200, 625, P2D);

    background(255);
}

void draw() {
    noLoop();
    PImage image = loadImage("artiso.png");
    image(image, 0, 0);
}