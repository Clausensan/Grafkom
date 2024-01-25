int x, y;
int w = 150;
int h = 20;
int dx = 5;
int dy = 5;
int score = 0;
int life = 3;
int level = 1;

int numObjects = 5;
float[] objectX = new float[numObjects];
float[] objectY = new float[numObjects];
float objectWidth = 50;
float objectHeight = 20;
boolean[] objectExists = new boolean[numObjects];

int[] lastAppearTime = new int[numObjects];
int respawnInterval = 3000;

int particleCount = 50;
float[] particleX = new float[particleCount];
float[] particleY = new float[particleCount];

void setup() {
  size(800, 800);
  x = width / 2;
  y = height / 2;

  for (int i = 0; i < numObjects; i++) {
    objectX[i] = random(width - objectWidth);
    objectY[i] = random(height / 2);
    objectExists[i] = true;
  }

  initializeObstacles(level);
}

void draw() {
  background(0);

  drawParticles();  // Tambah pemanggilan fungsi untuk menggambar partikel

  drawObjects();
  drawPaddle();
  drawBall();
  drawScore();
  drawLife();

  checkCollision();
  checkLevelUp();

  updatePaddle();
  updateBall();
}

void drawParticles() {
  fill(255, 150);  // Warna partikel (putih dengan transparansi)
  for (int i = 0; i < particleCount; i++) {
    ellipse(particleX[i], particleY[i], 5, 5);
  }
}

void emitParticles(float emitterX, float emitterY, int particleColor, int particleAlpha) {
  for (int i = 0; i < particleCount; i++) {
    particleX[i] = emitterX;
    particleY[i] = emitterY;

    float angle = random(TWO_PI);
    float speed = random(1, 5);

    float particleDX = cos(angle) * speed;
    float particleDY = sin(angle) * speed;

    particleX[i] += particleDX * 10;
    particleY[i] += particleDY * 10;

    fill(particleColor, particleAlpha);
    ellipse(particleX[i], particleY[i], 5, 5);
  }
}

void drawPaddle() {
  fill(255);
  float paddleX = constrain(mouseX - w / 2, 0, width - w);
  rect(paddleX, height - 50, w, h);
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
  text("Level: " + level, 650, 80);
}

void drawObjects() {
  fill(150, 150, 255);
  for (int i = 0; i < numObjects; i++) {
    if (objectExists[i]) {
      rect(objectX[i], objectY[i], objectWidth, objectHeight);
      checkRespawn(i);
    }
  }
}

void checkRespawn(int index) {
  int currentTime = millis();
  if (!objectExists[index] && currentTime - lastAppearTime[index] > respawnInterval) {
    objectX[index] = random(width - objectWidth);
    objectY[index] = random(height / 2);
    objectExists[index] = true;
    lastAppearTime[index] = currentTime;
  }
}

void checkCollision() {
  if (x > width - 20 || x < 20) {
    dx = -dx;
  }

  if (y < 20) {
    dy = -dy;
  }

  for (int i = 0; i < numObjects; i++) {
    if (objectExists[i] && x > objectX[i] && x < objectX[i] + objectWidth && y > objectY[i] && y < objectY[i] + objectHeight) {
      emitParticles(objectX[i] + objectWidth / 2, objectY[i] + objectHeight / 2, 255, 150);
      objectExists[i] = false;
      score++;
      dy = -dy;
    }
    checkRespawn(i);
  }

  if (y + 10 > height - 50 && y < height - 50 && x > mouseX - w / 2 && x < mouseX + w / 2) {
    dy = -dy;
  }

  if (y > height) {
    emitParticles(x, y, 255, 150);
    life--;
    reset();
  }

  if (life <= 0) {
    fill(255);
    textSize(48);
    text("GAME OVER", width / 2 - 150, height / 2);
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
  x = width / 2;
  y = height / 2;

  for (int i = 0; i < numObjects; i++) {
    objectX[i] = random(width - objectWidth);
    objectY[i] = random(height / 2);
    objectExists[i] = true;
  }

  if (score > 0) {
    score--;
  }
}

void resetGame() {
  life = 3;
  score = 0;
  level = 1;

  for (int i = 0; i < numObjects; i++) {
    objectX[i] = random(width - objectWidth);
    objectY[i] = random(height / 2);
    objectExists[i] = true;
  }

  initializeObstacles(level);
  
  loop();
}

void keyPressed() {
  if (key == ' ') {
    resetGame();
    loop();
  }
}

void initializeObstacles(int level) {
  for (int i = 0; i < numObjects * level; i++) {
    if (i < numObjects) {
      objectX[i] = random(width - objectWidth);
      objectY[i] = random(height / 2);
      objectExists[i] = true;
    }
  }
}

void checkLevelUp() {
  if (score >= level * 10) {
    emitParticles(width / 2, height / 2, 0, 255);
    level++;
    initializeObstacles(level);
  }
}
