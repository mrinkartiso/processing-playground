public abstract class FlowField {
    PVector[] vectors;
    int cols, rows;
    int scl;

    abstract void update();
    abstract void display();
    public PVector getForce(float posX, float posY) {
        int x = floor(posX / scl);
        int y = floor(posY / scl);
        int index = x + y * cols;

        return vectors[index];
    }
}