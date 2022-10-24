PImage mercury, venus, earth, mars;
public double vectorLineScale;
double scale;
int frame;
int trailInterval;
int stepsPerFrame;
Planet[] planets;

void setup() {
    size(1600, 900);
    imageMode(CENTER);

    //start frame count at 0
    frame = 0;

    //amount of steps applied per call of draw(), also speed of visualization
    stepsPerFrame = 30000;

    //scales of vectors and distances
    vectorLineScale = 1/2e2d;
    scale = 6e8d;

    //interval between dots in planets' trails
    trailInterval = 10;

    double earthVel = -30000 / 1.5;
    double planetMassRatio = 8;

    //sun
    Planet sun = new ImagePlanet(new Point(0, 0), 1.9891e30d, 6.9551e8d/ 1e7, new Vector(0, 0), loadImage("./assets/sun.png"), color(255, 255, 100));

    //earth with actual size
    //Planet earth = new ImagePlanet(new Point(1.4934e11d, 0), 5.972e24d, 6.371e6d, new Vector(0, earthVel), loadImage("./assets/earth.png"), color(100, 100, 255));

    //earth scaled have mass of  sun.getMass()/planetMassRatio
    Planet earth = new ImagePlanet(new Point(1.4934e11d, 0), sun.getMass() / planetMassRatio, 6.371e6d, new Vector(0, earthVel), loadImage("./assets/earth.png"), color(100, 100, 255));

    //L4 and L5 vectors
    Vector l4StartVel = new Vector(Math.sqrt(3), 1)
        .normalize().scale(earthVel);

    Vector l5StartVel = new Vector(-Math.sqrt(3), 1)
        .normalize().scale(earthVel);

    Planet L4 = new ColorPlanet(new Point(earth.getX() / 2, -sun.calculateL4Y(earth)),
        6200, 1e3, l4StartVel, color(255, 0, 0));

    Planet L5 = new ColorPlanet(new Point(earth.getX() / 2, sun.calculateL4Y(earth)),
        6200, 1e3, l5StartVel, color(255, 0, 0));

    Planet[] planets = {sun, earth, L4, L5};
    this.planets = planets;


    //L1 and 2
    //double angV =  Math.atan(earthVel / planets[1].getX());
    //double l1dist = planets[0].calculateL1X(planets[1]);

    //Planet L1 = new ColorPlanet(new Point(planets[1].getX() + l1dist, 0), 6200, 1e3, new Vector(0, Math.tan(angV) * (planets[1].getX() + l1dist)), color(255, 0, 0));
    //Planet L2 = new ColorPlanet(new Point(planets[1].getX() - l1dist, 0), 6200, 1e3, new Vector(0, Math.tan(angV) * (planets[1].getX() - l1dist)), color(255, 0, 0));
}

void draw() {

    frame += 1;

    background(10, 5, 20);

    //recalculates velocity and applies that velocity stepsPerFrame times
    for (int i = 0; i < stepsPerFrame; i ++) {

        //calculate velocity on all planets
        for (Planet p : planets) {
            for (Planet p2 : planets) {
                if (p != p2) {
                    p.calculateVelocity(p2);
                }
            }
        }
        //move all planets
        for (Planet p : planets) {
            p.move();
        }
    }

    //center visualization on sun
    translate(width/2, height/2);
    setAllOrigins(planets[0], planets);

    //draw trail and add to trail if frame%trailInterval is 0
    for (Planet p : planets) {
        p.drawTrail();
        if (frame % trailInterval == 0) {
            p.addFrame();
        }
    }

    //draw all planets
    for (Planet p : planets) {
        p.draw();
        p.drawVector();
    }
}

void keyPressed() {
    //print eccentricity and frame for data collection
    if (key == 'e') {
        println(getEccentricity() + "\t" + frame * 150000);
    }

    //restart simulation
    if (key == 'r') {
        setup();
    }
}

double getEccentricity() {
    ArrayList<Point> trail = planets[1].getTrail();

    double dist1 = 0;
    Point p1 = trail.get(0);
    Point p2 = p1;

    Point p3 = p1;

    //get the farthest two points on the ellipse
    //from these the semi-major axis can be calculated
    for (Point i : trail) {
        for (Point ii : trail) {
            if (i.getDist(ii) > dist1) {
                dist1 = i.getDist(ii);
                p1 = i;
                p2 = ii;
            }
        }
    }
    //midpoint of the farthest two points
    //the distance from p2 or p1 to the mid point is the semi-major axis
    Point midpoint = p1.getMidpoint(p2);

    //the closest point to the midpoint
    //the distance from this point to the midpoint is the semi-minor axis
    p3 = getClosest(midpoint, trail);

    //distance from focus to midpoint
    //formula: sqrt((semi-major)^2 - (semi-minor)^2)
    double focus = Math.sqrt(Math.pow(midpoint.getDist(p1), 2) - Math.pow(midpoint.getDist(p3), 2));

    //eccentricity = distance from focus to midpoint / semi-major axis
    double ecc = focus / midpoint.getDist(p1);

    return ecc;
}

//find the nearest point in an arraylist to another point
Point getClosest(Point p, ArrayList<Point> points) {
    Point closest = points.get(0);
    double minDist = Double.MAX_VALUE;
    for (Point i : points) {
        double dist = i.getDist(p);
        if (dist < minDist) {
            minDist = dist;
            closest = i;
        }
    }
    return closest;
}
