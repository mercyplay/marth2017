  import java.awt.Point;
  import java.util.ArrayList;
  
  /*
   * NOTE : I am afraid of draw() being executed in a locked speed thread that
   * will even be called before the painting of all the points has been
   * compleated, and ArrayList<> is not thread safe.
   */

  /*
   * TODO : we have to decide on where the origin node will be. If it is the
   * botton left corner it makes it hard on us because we have to shift our
   * math to accomidate it. Up is negative, right is positive. Where is our
   * orgin for 'theta', is it negative 'y-axis' or is it the positive 'x-axis'
   * like the 'basicDrawCirle' has it implemented.
   */

  ////// NEW TESTING
  public final static int MIN_ALPHA = 0;
  public  final static int MAX_ALPHA = 360;
  public HScrollbar hs1;
  public boolean startDrawing;
  ////// END NEW TESTING

  ArrayList<CollatzPoint> points;
  public final int HEIGHT = 30;
  public int heightRemaning = 25;
  public int alpha = 20;
  public int mag = 30;
  public int size = 3;

  public void setup() {
    // set the size of the display
    size(1280, 720);
    // lock hte framerate, which will determine how fast the tree grows
    frameRate(2);

    ////// NEW TESTING
    hs1 = new HScrollbar(0, 8, width, 16, 1);
    ////// END NEW TESTING

    // set the origin of the sketch to be the botton right side
    translate(600, 400);

    /*
     * set the initial point to 1, that we will later branch up
     */
    points = new ArrayList();
    points.add(new CollatzPoint(1, new Point(10, 10), 0, false, null));
    ellipse(10, 10, size, size);
  }

  // TODO make the tree only grow when the button is pressed

  public void mousePressed() {
    // the mouse has to be bellow the slider clusters
    if (mouseY > 20) {

      // reset the whole shebang
      // points = new ArrayList();
      // points.add(new CollatzPoint(1, new Point(10, 10), 0, false,
      // null));
      // ellipse(10, 10, size, size);

      alpha = hs1.getAlpha();
      startDrawing = true;
      System.out.println("I AM GOING TO DRAW NOW!!!!!");
    }
  }

  public void draw() {
    hs1.update();
    hs1.display();
    
    // we need a tick counter

    if (startDrawing) {
      // System.out.println("we would begin printing here");
      generate(points, heightRemaning);
    } else {
      // System.out.println("slider position has not been selected");
    }
  }

  /*
   * Draw one new node
   */
  void drawCircle(CollatzPoint parentPoint, CollatzPoint currPoint) {

    strokeWeight(size + 2);
    stroke(255, 255, 255);
    line(parentPoint.getX(), parentPoint.getY(), currPoint.getX(), currPoint.getY());

    strokeWeight(size);
    stroke(map(heightRemaning, 0, this.HEIGHT, 255, 0), map(heightRemaning, 0, this.HEIGHT, 0, 255),
        map(heightRemaning, 0, this.HEIGHT, 0, 255));
    line(parentPoint.getX(), parentPoint.getY(), currPoint.getX(), currPoint.getY());
    noStroke();
    fill(map(heightRemaning, 0, this.HEIGHT, 255, 0), map(heightRemaning, 0, this.HEIGHT, 0, 255),
        map(heightRemaning, 0, this.HEIGHT, 0, 255));
    ellipse(currPoint.getX(), currPoint.getY(), size, size);
  }

  public void generate(ArrayList<CollatzPoint> points, int heightRemaning) {
    /*
     * Testing
     */

    /*
     * End testing
     */

    if (heightRemaning > 0) {

      /*
       * If we still need to continue drawing the tree
       */

      translate(600, 400);
      fill(255, 0, 0);

      ArrayList<CollatzPoint> newPoints = new ArrayList();

      for (CollatzPoint val : points) {
        /*
         * There is always going to be an even branch
         */

        // add the even point
        CollatzPoint newPoint = generateNewCollatzPoint(val, true, val.value * 2);
        newPoints.add(newPoint);
        System.out.println(newPoint.value + " is left node: " + newPoint.isLeftNode);

        drawCircle(val, newPoint);

        /*
         * See if there is an odd branch
         */
        float possiblePoint = (float) (((float) val.value - 1.0) / 3.0);

        if (possiblePoint == (int) possiblePoint && (int) possiblePoint != 0 && (int) possiblePoint != 1) {
          newPoint = generateNewCollatzPoint(val, false, (int) possiblePoint);
          newPoints.add(newPoint);
          drawCircle(val, newPoint);

          System.out.println(newPoint.value + " is left node: " + newPoint.isLeftNode);
        }
      }

      /*
       * Because we are going to call this function every time we repaint
       * we do not want it to be recursive in nature
       */

      this.points = newPoints;
      --this.heightRemaning;

      System.out.println("heightRemaning: " + heightRemaning);
      System.out.println("leaving loop");
    }
  }

  /*
   * Generate a new collatz point
   */

  public CollatzPoint generateNewCollatzPoint(CollatzPoint parentPoint, Boolean isLeftNode, int value) {
    float newTheta = 0;
    if (isLeftNode) {
      newTheta = (float) (parentPoint.theta + alpha);
    } else {
      newTheta = (float) (parentPoint.theta - alpha);
    }

    double newX = parentPoint.position.getX() + mag * cos(radians(newTheta));
    double newY = parentPoint.position.getY() + mag * sin(radians(newTheta));

    return new CollatzPoint(value, new Point((int) newX, (int) newY), (int) newTheta, true, parentPoint);
  }

  /*
   * Node class that contains all the information about a collatz point
   */

  public class CollatzPoint {
    public CollatzPoint parent;

    public int value;
    public Point position;
    public int theta;
    // if 'isLeftNode' == 'true' that means it is an even number and should
    // curve down
    public boolean isLeftNode;

    public CollatzPoint(int value, Point position, int theta, boolean isLeftNode, CollatzPoint parent) {
      this.value = value;
      this.position = position;
      this.theta = theta;
      this.isLeftNode = isLeftNode;

      this.parent = parent;
    }

    public float getX() {
      return (float) position.getX();
    }

    public float getY() {
      return (float) position.getY();
    }
  }