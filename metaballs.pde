Circle[] circles = new Circle[10];

void setup() {
    size(848, 480);
    float offset = MAX_RADIUS_FACTOR * height;

    for (int i=0; i<circles.length; i++) {
        circles[i] = new Circle(random(offset, width-offset), random(offset, height-offset));
    }
}


void draw() {
    background(0);
    for (Circle circle: circles) {
        circle.update();
        circle.show();
    }

}
