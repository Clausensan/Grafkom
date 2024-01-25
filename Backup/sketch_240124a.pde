int x, y;
int w = 200;
int h = 200;
int dx = 5;
int dy = 5;
int score = 0;
int life = 3;
int level = 1;

int numObjects = 5;  // Jumlah objek
float[] objectX = new float[numObjects];
float[] objectY = new float[numObjects];
float objectWidth = 50;
float objectHeight = 20;
boolean[] objectExists = new boolean[numObjects];

int[] lastAppearTime = new int[numObjects];
int respawnInterval = 3000;  // Interval dalam milidetik (contoh: 3000ms = 3 detik)

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

  drawObjects();  // Tambah pemanggilan fungsi baru untuk menggambar objek

  drawPaddle();
  drawBall();
  drawScore();
  drawLife();

  checkCollision();
  checkLevelUp();  // Tambah pemanggilan fungsi untuk memeriksa kenaikan level

  updatePaddle();
  updateBall();
}

void drawPaddle() {
  fill(255);
  rect(mouseX - w / 2, height - 50, w, h);
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
  text("Level: " + level, 650, 80);  // Tampilkan level
}

void drawObjects() {
  fill(150, 150, 255);  // Warna objek
  for (int i = 0; i < numObjects; i++) {
    if (objectExists[i]) {
      rect(objectX[i], objectY[i], objectWidth, objectHeight);
      checkRespawn(i);  // Memeriksa apakah objek perlu muncul kembali
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

  if (y > height - 70 || y < 20) {
    dy = -dy;
  }

  for (int i = 0; i < numObjects; i++) {
    if (objectExists[i] && x > objectX[i] && x < objectX[i] + objectWidth && y > objectY[i] && y < objectY[i] + objectHeight) {
      objectExists[i] = false;  // Menghapus objek
      score++;
      dy = -dy;  // Memantulkan bola
    }
    checkRespawn(i);  // Tambahkan pemanggilan untuk muncul kembali objek
  }

  if (dist(mouseX, height - 50, x, y) < 30) {
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

void keyPressed() {
  if (key == ' ') {
    loop();
  }
}

void initializeObstacles(int level) {
  for (int i = 0; i < numObjects * level; i++) {
    // Pastikan i tidak melebihi panjang array (numObjects)
    if (i < numObjects) {
      objectX[i] = random(width - objectWidth);
      objectY[i] = random(height / 2);
      objectExists[i] = true;
    }
  }
}

void checkLevelUp() {
  if (score >= level * 10) {  // Misalnya, naik level setiap 10 skor
    level++;
    initializeObstacles(level);  // Atur ulang rintangan berdasarkan level baru
  }
}
