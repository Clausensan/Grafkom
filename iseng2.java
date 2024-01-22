int x, y;
int w = 200;
int h = 200;
int dx = 5;
int dy = 5;
int score = 0;
int life = 3;

void setup() {
 size(800, 800);
 x = width/2;
 y = height/2;
}

void draw() {
 background(0);
  
 drawPaddle();
 drawBall();
 drawScore();
 drawLife();
  
 checkCollision();
  
 updatePaddle();
 updateBall();
}

void drawPaddle() {
 fill(255);
 rect(mouseX-w/2, height-50, w, h);
}

void drawBall() {
 fill(255);
 ellipse(x, y, 20, 20);
}

void drawScore() {
 fill(255);
 textSize(24);
 text("Score: " + score, 20, 50);
}

void drawLife() {
 fill(255);
 textSize(24);
 text("Life: " + life, 650, 50);
}

void checkCollision() {
 if (x > width-20 || x < 20) {
    dx = -dx;
 }
  
 if (y > height-70 || y < 20) {
    dy = -dy;
 }
  
 if (dist(mouseX, height-50, x, y) < 30) {
    dx = -dx;
    dy = -dy;
    score++;
 }
  
 if (x > width || x < 0 || y > height || y < 0) {
    life--;
    reset();
 }
  
 if (life <= 0) {
    fill(255);
    textSize(48);
    text("GAME OVER", width/2-150, height/2);
    noLoop();
 }
}

void updatePaddle() {
  
}

void updateBall() {
 x += dx;
 y += dy;
}

void reset() {
 x = width/2;
 y = height/2;
  
 if (score > 0) {
    score--;
 }
}

void keyPressed() {
 if (key == ' ') {
    loop();
 }
}