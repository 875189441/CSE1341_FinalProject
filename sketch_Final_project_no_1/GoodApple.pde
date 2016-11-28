class GoodApple {

  color c;
  int foodX=-1;
  int foodY=-1;
  boolean eatFood=true;
  int SnakeX = 0;
  int SnakeY = 0;
  int N;


  GoodApple() {
    foodX = -1;
    foodY = -1;
    c = color(240, 86, 140);
  }
  void drawGApple() {
    fill(c);
    if (eatFood) {
      foodX = int( random(0, 30));
      foodY = int( random(0, 30));
    }  
    rect(foodX * 20, foodY * 20, 20, 20);
    eatFood = false;
  }
}