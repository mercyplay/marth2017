import java.awt.Point;
import java.util.ArrayList;

/*
 * NOTE : I am afraid of draw() being executed in a locked
 * speed thread that will even be called before the painting
 * of all the points has been compleated, and ArrayList<> is
 * not thread safe.
 */
 
/*
 * TODO : we have to decide on where the origin node will be.
 * If it is the botton left corner it makes it hard on us because
 * we have to shift our math to accomidate it. Up is negative, right
 * is positive. Where is our orgin for 'theta', is it negative 'y-axis'
 * or is it the positive 'x-axis' like the 'basicDrawCirle' has it
 * implemented.
 */


ArrayList<CollatzPoint> points;
final int HEIGHT = 20;
int heightRemaning = 20;

void setup() {
  // set the size of the display
  size(1280, 720);
  // lock hte framerate, which will determine how fast the tree grows
  frameRate(10);
  // set the origin of the scetch to be the botton right side
  translate(0, 100);

  /*
   * set the initial point to 1, that we will later branch up
   */
  points = new ArrayList();
  points.add(new CollatzPoint(1, new Point(10, 10), 1, false, null));
  ellipse(20, -20, 20, 20);
}

void draw() {
  generate(points, heightRemaning);
}

public void generate(ArrayList<CollatzPoint> points, int heightRemaning) {
  /*
   * Testing
   */

  /*
   * End testing
   */

  System.out.println("before loop");
  if (heightRemaning > 0) {
    System.out.println("in loop");

    /*
       * If we still need to continue drawing the tree
     */

    translate(0, 100);
    fill(255, 0, 0);

    ArrayList<CollatzPoint> newPoints = new ArrayList();

    for (CollatzPoint val : points) {
      /*
     * There is always going to be an even branch
       */

      // add the even point
      CollatzPoint newPoint = new CollatzPoint(val.value * 2, generateNewPoint(val.position, true), 10, true, 
        val);
      newPoints.add(newPoint);
      System.out.println(newPoint.value + " is left node: " + newPoint.isLeftNode);

      ellipse((float) newPoint.position.getX(), (float) newPoint.position.getY(), 20, 20);

      /*
     * See if there is an odd branch
       */
      float possiblePoint = (float) (((float) val.value - 1.0) / 3.0);

      if (possiblePoint == (int) possiblePoint && (int) possiblePoint != 0 && (int) possiblePoint != 1) {
        newPoint = new CollatzPoint((int) possiblePoint, generateNewPoint(val.position, false), 10, false, 
          val);
        newPoints.add(newPoint);

        ellipse((float) newPoint.position.getX(), (float) newPoint.position.getY(), 20, 20);
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

    // if (heightRemaning > 0) {
    // // System.out.println("heightRemaning: " + heightRemaning);
    // generate(newPoints, --heightRemaning);
    // }

    System.out.println("leaving loop");
  }

  System.out.println("left loop");
}

public Point generateNewPoint(Point parent, Boolean isLeftNode) {
  if (isLeftNode) {
    System.out.println("parent.getX() + 20: " + (parent.getX() + 20));
    System.out.println("parent.getY() + 20: " + (parent.getY() + 20));
    // TODO curve down
    return new Point((int) (parent.getX() + 20), (int) (parent.getY() + 20));
  } else {
    System.out.println("parent.getX() + 20: " + (parent.getX() + 20));
    System.out.println("parent.getY() - 20: " + (parent.getY() - 20));
    // TODO curve up
    return new Point((int) (parent.getX() + 20), (int) (parent.getY() - 20));
  }
}

/*
     * Node class that contains all the information about a point
 */

public class CollatzPoint {
  public CollatzPoint parent;

  public int value;
  public Point position;
  public double theta;
  // if 'isLeftNode' == 'true' that means it is an even number and should curve down 
  public boolean isLeftNode;

  public CollatzPoint(int value, Point position, double theta, boolean isLeftNode, CollatzPoint parrent) {
    this.value = value;
    this.position = position;
    this.theta = theta;
    this.isLeftNode = isLeftNode;

    this.parent = parent;
  }
}