GoodApple a1;
int w; 
int h;


int SnakeMoveX = 0;
int SnakeMoveY = 0;
int SnakeX = 0;
int SnakeY = 0;
int []snakesX=new int[100];
int []snakesY=new int[100];
int N ; 

float speed=100;
int foodX ;
int foodY ;
boolean eatFood=true;


void setup() {
  speed = 100;
  eatFood=true;
  w =30 ;
  h =30;
  N=1;
  size(600, 600);
  background(255);  
  SnakeX = 5; 
  SnakeY = 5;  
  a1 = new GoodApple();
}

void draw() {
  if (speed%5==0) {
    background(255);



    for (int i =0; i<h; i++) {
      line(20*i, 0, i*20, height);
    }
    for (int j = 0; j <w; j++) {   
      line(0, j*20, width, j*20);
    }
    
    a1.drawGApple();
    drawSnake();    
    snakeMove();
    eatApple(); 
  }  
  speed++;
}    
void drawSnake() {
  fill(0);
  for (int i = 0; i < N; i++) {    
    rect(snakesX[i] * 20, snakesY[i] * 20, 20, 20);
  }  
  for (int i = N; i > 0; i--) {
    snakesX[i] = snakesX[i-1]; 
    snakesY[i] = snakesY[i-1];
  }
}

void snakeMove() {
  SnakeX=SnakeX+SnakeMoveX;
  SnakeY=SnakeY+SnakeMoveY;

  snakesX[0] = SnakeX;  
  snakesY[0] = SnakeY;
}

void keyPressed() {
  if (keyCode == UP) { //up down with x=0 
    if (snakesY[0] != snakesY[0]-5) {
      SnakeMoveY = -1; 
      SnakeMoveX = 0;
    }
  } else if (keyCode == DOWN) {
    if (snakesY[0] != snakesY[0]+5) { 
      SnakeMoveY = 1; 
      SnakeMoveX = 0;
    }
  } else if (keyCode == LEFT) { 
    if (snakesX[0] != snakesX[0]-5) {//right left with y=0
      SnakeMoveX = -1; 
      SnakeMoveY = 0;
    }
  } else if (keyCode == RIGHT) { 
    if (snakesX[0] != snakesX[0]+5) {
      SnakeMoveX = 1; 
      SnakeMoveY = 0;
    }
  }
}

void eatApple() {
  if ( SnakeX == a1.foodX && SnakeY == a1.foodY ) {
    a1.eatFood = true;    
    N++;
  }
}