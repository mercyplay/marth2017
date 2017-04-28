class Slider {
  private final static int MIN_MAP = 10;
  private final static int MAX_MAP = 200;

  private int swidth, sheight;    // width and height of bar
  private float xpos, ypos;       // x and y position of bar
  private float spos, newspos;    // x position of slider
  private float sposMin, sposMax; // max and min values of slider
  private int loose;              // how loose/heavy, 1 : follows mouse exactly, higher means it is slower
  private boolean over;           // is the mouse over the slider?
  private boolean locked;
  private float ratio;

  Slider (float xp, float yp, int sw, int sh, int l) {
    this.swidth = sw;
    this.sheight = sh;
    int widthtoheight = sw - sh;
    this.ratio = (float)sw / (float)widthtoheight;
    this.xpos = xp;
    this.ypos = yp-sheight/2;
    this.spos = xpos + swidth/2 - sheight/2;
    this.newspos = spos;
    this.sposMin = xpos;
    this.sposMax = xpos + swidth - sheight;
    this.loose = l;
  }

  void update() {
    
    //System.out.println("I AM IN UPDATE");
    
    if (overEvent()) {
      this.over = true;
    } else {
      this.over = false;
    }
    if (mousePressed && over) {
      //System.out.println("mousePressed && over");
      this.locked = true;
    }
    if (!mousePressed) {
      //System.out.println("!mousePressed");
      this.locked = false;
    }
    if (locked) {
      //System.out.println("locked");
      this.newspos = constrain(mouseX - this.sheight / 2, this.sposMin, this.sposMax);
    }
    if (abs(newspos - spos) > 1) {
      this.spos = spos + (newspos-spos)/loose;
    }
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
       mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    noStroke();
    fill(204);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
      fill(0, 0, 0);
    } else {
      fill(102, 102, 102);
    }
    rect(spos, ypos, sheight, sheight);
    stroke(1);
  }

  int getValue() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    
    //System.out.println("Pos: " + spos * ratio);
    
    int value = (int) (spos * ratio);
    
    return (int) map(value, 0, width, MIN_MAP, MAX_MAP);
  }
}