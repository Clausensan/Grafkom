int x, y;
int w = 150;  // Ubah nilai lebar paddle
int h = 20;   // Ubah nilai tinggi paddle
float dx = 5;
float dy = 5;  // Mengubah dy menjadi float untuk kecepatan yang dapat diubah
int score = 0;
int life = 3;
int level = 1;
int highScore = 0;


int numObjects = 5;  // Jumlah objek
float[] objectX = new float[numObjects];
float[] objectY = new float[numObjects];
float objectWidth = 50;
float objectHeight = 20;
boolean[] objectExists = new boolean[numObjects];

int[] lastAppearTime = new int[numObjects];
int respawnInterval = 3000;  // Interval dalam milidetik (contoh: 3000ms = 3 detik)

int gameState = 0;  // 0: Main Menu, 1: Game, 2: Game Over
boolean gameStarted = false;

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

  if (gameState == 0) {
    drawMainMenu();
  } else if (gameState == 1) {
    if (!gameStarted) {
      resetGame();
      gameStarted = true;
    }
    drawGame();
  } else if (gameState == 2) {
    drawGameOver();
  }
}

void drawMainMenu() {
  fill(255);
  textSize(48);
  text("Press SPACE to Start", width / 2 - 210, height / 2);
}

void drawGame() {
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

void drawPaddle() {
  fill(255);
  rect(mouseX - w / 2, height - 50, w, h);
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
    life--;
    if (life <= 0) {
      gameState = 2;  // Game over
    } else {
      reset();
    }
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
  if (score > highScore) {
    highScore = score;
  }
  
  life = 3;
  score = 0;
  level = 1;
  dx = 5;  // Kembalikan kecepatan bola ke nilai awal

  for (int i = 0; i < numObjects; i++) {
    objectX[i] = random(width - objectWidth);
    objectY[i] = random(height / 2);
    objectExists[i] = true;
  }

  initializeObstacles(level);

  loop();
}

void keyPressed() {
  if (key == ' ' && gameState == 0) {
    gameState = 1;
  } else if (key == ' ' && gameState == 1) {
    resetGame();
    loop();
  } else if (key == ' ' && gameState == 2) {
    gameState = 0;
    gameStarted = false;
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
    level++;
    dx += 0.5;  // Tambahkan kecepatan setiap naik level
    initializeObstacles(level);
  }
}

void drawGameOver() {
  fill(255);
  textSize(48);
  text("GAME OVER", width / 2 - 128, height / 2);
  textSize(24);
  text("Score: " + score, width / 2 - 48, height / 2 + 50);
  text("High Score: " + highScore, width / 2 - 80, height / 2 + 80);
  text("Press SPACE to Play Again", width / 2 - 128, height / 2 + 110);
}
