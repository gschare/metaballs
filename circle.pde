static final int STROKE_WEIGHT = 4;
static final int MAX_SPEED = 2;
static float MIN_RADIUS_FACTOR = 0.0625;
static float MAX_RADIUS_FACTOR = 0.2;

class Circle {
    PVector position;
    float radius;
    PVector velocity;

    Circle(float x, float y) {
        position = new PVector(x,y);
        velocity = PVector.random2D();
        velocity.mult(random(1, MAX_SPEED));
        radius = random(height*MIN_RADIUS_FACTOR, height*MAX_RADIUS_FACTOR);
    }

    void update() {
        position.add(velocity);
        if (position.x - radius < 0 || position.x + radius > width) {
            velocity.x *= -1;
        }
        if (position.y - radius < 0 || position.y + radius > height) {
            velocity.y *= -1;
        }
    }

    void show() {
        noFill();
        stroke(0, 255, 0);
        strokeWeight(STROKE_WEIGHT);
        ellipse(position.x, position.y, radius*2, radius*2);
    }

}
