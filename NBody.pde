Planet[] planets;
PImage mercury, venus, earth, mars;
public double vectorLineScale;
int frame;
int trailInterval;
//static double scale = 1e7d;
static double scale = 6e8d;

void setup() {
    size(1600, 900);
    imageMode(CENTER);
    frame = -1;


    vectorLineScale = 1/2e2d;
    trailInterval = 1;
    double earthVel = -30000/ 2;

    planets = new Planet[4];
    //sun
    planets[0] = new ImagePlanet(new Point(2, 2), 1.9891e30d, 6.9551e8d / 1e7, new Vector(0, 0), loadImage("./assets/sun.png"), color(255, 255, 100));
    //earth
    planets[1] = new ImagePlanet(new Point(1.4934e11d, 0), 5.972e24d, 6.371e6d, new Vector(0, earthVel), loadImage("./assets/earth.png"), color(100, 100, 255));
    //planets[1] = new ImagePlanet(1.4934e11d, 0, planets[0].getMass() / 4, 6.371e6d, new Vector(0, earthVel), loadImage("./assets/earth.png"), color(100, 100, 255));

    Vector v1 = new Vector(Math.sqrt(3), 1)
        .normalize().scale(earthVel);

    Vector v2 = new Vector(-Math.sqrt(3), 1)
        .normalize().scale(earthVel);

    planets[2] = new ColorPlanet(new Point(planets[1].getX() / 2, -planets[0].calculateL4Y(planets[1])),
        6200, 1e3, v1, color(255, 0, 0));

    planets[3] = new ColorPlanet(new Point(planets[1].getX() / 2, planets[0].calculateL4Y(planets[1])),
        6200, 1e3, v2, color(255, 0, 0));


    //L1 and 2
    //double angV =  Math.atan(earthVel / planets[1].getX());
    //double l1dist = planets[0].calculateL1X(planets[1]);

    //planets[2] = new ColorPlanet(planets[1].getX() + l1dist, 0, 6200, 1e3, new Vector(0, Math.tan(angV) * (planets[1].getX() + l1dist)), color(255, 0, 0));
    //planets[3] = new ColorPlanet(planets[1].getX() - l1dist, 0, 6200, 1e3, new Vector(0, Math.tan(angV) * (planets[1].getX() - l1dist)), color(255, 0, 0));
}

void draw() {

    frame = frame == trailInterval? 0 : frame + 1;

    background(10, 10, 40);
    for (int i = 0; i < 50000; i ++) {

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

    translate(width/2, height/2);
    setAllOrigins(planets[0], planets);

    //draw frame
    for (Planet p : planets) {
        p.drawTrail();
        if (frame == 0) {
            p.addFrame();
        }
    }

    for (Planet p : planets) {
        p.draw();
        p.drawVector();
    }
}

void keyPressed() {
    if (key == 'e') {
        ArrayList<Point> trail = planets[1].getTrail();

        double dist1 = 0;
        Point p1 = trail.get(0);
        Point p2 = p1;

        double distp3 = Double.MAX_VALUE;
        Point p3 = p1;
        for (Point i : trail) {
            for (Point ii : trail) {
                if (i.getDist(ii) > dist1) {
                    dist1 = i.getDist(ii);
                    p1 = i;
                    p2 = ii;
                }
            }
        }

        Point midpoint = new Point(
            (p1.getX() + p2.getX()) / 2,
            (p1.getY() + p2.getY()) / 2
            );

        for (Point i : trail) {
            double dist = i.getDist(midpoint);
            if (dist < distp3) {
                distp3 = dist;
                p3 = i;
            }
        }

        double focus = Math.sqrt(Math.pow(midpoint.getDist(p1), 2) - Math.pow(midpoint.getDist(p3), 2));
        double ecc = focus / midpoint.getDist(p1);

        println(ecc);
    }
}

double getEccentricity() {
    ArrayList<Point> trail = planets[1].getTrail();

    double dist1 = 0;
    Point p1 = trail.get(0);
    Point p2 = p1;

    double distp3 = Double.MAX_VALUE;
    Point p3 = p1;
    for (Point i : trail) {
        for (Point ii : trail) {
            if (i.getDist(ii) > dist1) {
                dist1 = i.getDist(ii);
                p1 = i;
                p2 = ii;
            }
        }
    }

    Point midpoint = p1.getMidpoint(p2);

    p3 = getClosest(midpoint, trail);

    double focus = Math.sqrt(Math.pow(midpoint.getDist(p1), 2) - Math.pow(midpoint.getDist(p3), 2));

    double ecc = focus / midpoint.getDist(p1);

    return ecc;
}

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
