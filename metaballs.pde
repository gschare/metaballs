static int N = 10;
static int PIXEL_RATIO = 1;
static int THRESHOLD = 1;
int cols, rows;
Circle[] circles = new Circle[N];
float[][] field;

void setup() {
    size(848, 480);
    frameRate(15);
    float x_offset = MAX_RADIUS_FACTOR * height;
    float y_offset = MAX_RADIUS_FACTOR * width;
    cols = 1 + width / PIXEL_RATIO;
    rows = 1 + height / PIXEL_RATIO;
    field = new float[cols][rows];

    colorMode(HSB, 360, 100, 100);

    for (int i=0; i<circles.length; i++) {
        circles[i] = new Circle(random(x_offset, width-x_offset), random(y_offset, height-y_offset));
    }
}

float f(float x, float y) {
    float sum = 0;
    for (Circle c: circles) {
        float x0 = c.position.x;
        float y0 = c.position.y;
        sum += sq(c.radius) / (sq(x - x0) + sq(y - y0));
    }
    return sum;
}

int getState(int a, int b, int c, int d) {
    return a*8 + b*4 + c*2 + d*1;
}

int toThreshold(float sum) {
    return sum < THRESHOLD ? 0 : 1;
}

void vline(PVector v1, PVector v2) {
    line(v1.x, v1.y, v2.x, v2.y);
}

float averageHue(float x, float y) {
    float sum = 0;
    float weights = 0;
    for (Circle c: circles) {
        float weight = 100 * MAX_RADIUS_FACTOR * (height / dist(x, y, c.position.x, c.position.y));
        sum += c.hue * weight;
        weights += weight;
    }
    return sum / weights;
}

float minDistToCircle(float x, float y) {
    float min_distance = Float.MAX_VALUE;
    for (Circle c: circles) {
        float distance = dist(x, y, c.position.x, c.position.y);
        if (distance <= min_distance) {
            min_distance = distance;
        }
    }
    return min_distance;
}

Circle getClosestCircle(float x, float y) {
    Circle closest = circles[0];
    float min_distance = Float.MAX_VALUE;
    for (Circle c: circles) {
        float distance = dist(x, y, c.position.x, c.position.y);
        if (distance <= min_distance) {
            closest = c;
            min_distance = distance;
        }
    }
    return closest;
}

void draw() {
    background(51);
/*
    for (int i=0; i<cols; i++) {
        for (int j=0; j<rows; j++) {
            float x = i * PIXEL_RATIO;
            float y = j * PIXEL_RATIO;
            field[i][j] = f(x,y); 
        }
    }
    */
    loadPixels();
    for (int x=0; x<width; x++) {
        for (int y=0; y<height; y++) {
            int index = x + y*width;
            float sum = 0;
            float weights = 0;
            for (Circle c: circles) {
                float d = dist(x, y, c.position.x, c.position.y);
                weights += c.radius / d;
                sum += c.hue * c.radius / d;
            }
            sum /= weights;
            pixels[index] = color(sum, 50, constrain(60*f(x,y), 0, 100));
        }
    }
    updatePixels();

/*
    // this is shit because we're just filling in every pixel which destroys performance like before and has some weird behavior I don't understand
    // what I really need is a super fast algorithm to detect the blobs OR one to detect the contours.
    // It is silly to just fill everything in this way -- it defeats the purpose and I don't have the control I want. The control is really the key here -- if I could treat these as shapes, then I can do anything.
    loadPixels();
    for (int x=0; x<width; x++) {
        for (int y=0; y<height; y++) {
            int i = floor(x / PIXEL_RATIO);
            int j = floor(y / PIXEL_RATIO);
            int index = x + y*width;
            float hue = averageHue(x,y);
            float distance = minDistToCircle(x,y);
            
            if (distance <= height*MIN_RADIUS_FACTOR) {
                hue = getClosestCircle(x,y).hue;
            }
            float saturation = 100;// *MAX_RADIUS_FACTOR*(height/distance);
            pixels[index] = color(hue, saturation, 100*field[i][j]);
        }
    }
    updatePixels();
*/
/*
    for (int i=0; i<cols-1; i++) {
        for (int j=0; j<rows-1; j++) {
            // interpolation
            float x = i * PIXEL_RATIO;
            float y = j * PIXEL_RATIO;

            int c1 = toThreshold(field[i][j]);
            int c2 = toThreshold(field[i+1][j]);
            int c3 = toThreshold(field[i+1][j+1]);
            int c4 = toThreshold(field[i][j+1]);

            int state = getState(c1,c2,c3,c4);

            float a_val = field[i][j]; 
            float b_val = field[i+1][j]; 
            float c_val = field[i+1][j+1]; 
            float d_val = field[i][j+1]; 

            float amt;

            PVector a = new PVector();
            amt = (1 - a_val) / (b_val - a_val);
            a.x = lerp(x, x + PIXEL_RATIO, amt);
            a.y = y;

            PVector b = new PVector();
            amt = (1 - b_val) / (c_val - b_val);
            b.x = x + PIXEL_RATIO;
            b.y = lerp(y, y + PIXEL_RATIO, amt);

            PVector c = new PVector();
            amt = (1 - d_val) / (c_val - d_val);
            c.x = lerp(x, x + PIXEL_RATIO, amt);
            c.y = y + PIXEL_RATIO;

            PVector d = new PVector();
            amt = (1 - a_val) / (d_val - a_val);
            d.x = x;
            d.y = lerp(y, y + PIXEL_RATIO, amt);

            stroke(0, 0, 100);
            strokeWeight(1);
            draw_contours(state, a, b, c, d);
        }
    }
*/

    for (Circle c: circles) {
        c.update();
        //c.show();
    }

    saveFrame("gif/#####.png");
}

void draw_contours(int state, PVector a, PVector b, PVector c, PVector d) {
    switch (state) {
        case 1:  
            vline(c, d);
            break;
        case 2:  
            vline(b, c);
            break;
        case 3:  
            vline(b, d);
            break;
        case 4:  
            vline(a, b);
            break;
        case 5:  
            vline(a, d);
            vline(b, c);
            break;
        case 6:  
            vline(a, c);
            break;
        case 7:  
            vline(a, d);
            break;
        case 8:  
            vline(a, d);
            break;
        case 9:  
            vline(a, c);
            break;
        case 10: 
            vline(a, b);
            vline(c, d);
            break;
        case 11: 
            vline(a, b);
            break;
        case 12: 
            vline(b, d);
            break;
        case 13: 
            vline(b, c);
            break;
        case 14: 
            vline(c, d);
            break;
    }
}
