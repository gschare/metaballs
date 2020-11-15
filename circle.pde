static final int STROKE_WEIGHT = 4; 
static final float MIN_SPEED = 0.5;
static final float MAX_SPEED = 2;
static float MIN_RADIUS_FACTOR = 0.05;
static float MAX_RADIUS_FACTOR = 0.15;

class Circle {
    PVector position;
    float radius;
    PVector velocity;
    float hue;
    float saturation;

    Circle(float x, float y) {
        position = new PVector(x,y);
        velocity = PVector.random2D();
        velocity.mult(random(MIN_SPEED, MAX_SPEED));
        radius = random(height*MIN_RADIUS_FACTOR, height*MAX_RADIUS_FACTOR);
        hue = random(240, 280);
        saturation = 0;
    }

    void update() {
        position.add(velocity);
        if (position.x - radius < 0 || position.x + radius > width) {
            velocity.x *= -1;
        }
        if (position.y - radius < 0 || position.y + radius > height) {
            velocity.y *= -1;
        }
        saturation = (((velocity.x + velocity.y) / 2) / MAX_SPEED) * 100;
    }

    void show() {
        stroke(120, 100, 100);
        strokeWeight(STROKE_WEIGHT);
        ellipse(position.x, position.y, radius*2, radius*2);
    }

}
