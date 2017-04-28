float max_distance;



int alpha = 5;
int mag = 100;
int size = 10;

void setup() {
  size(640, 360); 
  //noStroke();
  max_distance = dist(0, 0, width, height);
}

void drawCircle(int number, int parentX, int parentY, int parentTheta){
  float newTheta = 0;
  if(number % 2 == 0) {
    newTheta = float(parentTheta + alpha); 
  } else {
    newTheta = float(parentTheta - alpha); 
  }
  
  float newX = parentX + mag*cos(radians(newTheta));
  float newY = parentY + mag*sin(radians(newTheta));
  stroke(100,100,100);
  line(parentX,parentY,newX, newY);
  
  ellipse(newX, newY, size, size);
  
}



void draw() {
  background(0);

  int size = 10;
  int parentX = 50;
  int parentY = 50;
  int parentTheta = 0;
  ellipse(parentX, parentY, size, size);
  
  drawCircle(11,parentX,parentY,parentTheta);
  
  
   
}