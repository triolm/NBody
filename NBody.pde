Planet[] planets;
PImage mercury, venus, earth, mars;
public double vectorLineScale;
int frame;
int trailInterval;
static double scale = 1e7d;
//static double scale = 6e8d;

void setup() {
    size(1600, 900);
    imageMode(CENTER);
    frame = -1;

    // Actual Solar System ----
    {
        vectorLineScale = 1/2e2d;
        trailInterval = 10;
        planets = new Planet[4];

        //sun
        planets[0] = new ImagePlanet(2, 2, 1.9891e30d, 6.9551e8d, new Vector(0, 0), loadImage("./assets/sun.png"), color(255, 255, 100));
        //earth
        planets[1] = new ImagePlanet(1.4934e11d, 0, 5.972e24d, 6.371e6d, new Vector(0, -30000), loadImage("./assets/earth.png"), color(100, 100, 255));

        double angV =  Math.atan
            planets[2] = new ColorPlanet(planets[1].getX() + planets[0].calculateL1X(planets[1]), 0, 6200, 1e3, new Vector(0, -30307), color(255, 0, 0));
        planets[3] = new ColorPlanet(planets[1].getX() - planets[0].calculateL1X(planets[1]), 0, 6200, 1e3, new Vector(0, -29707.5), color(255, 0, 0));


        //planets[2] = new ImagePlanet(0,-1.0742e11d,4.867e24d, 6.05e6d, new Vector(-35000 ,0),loadImage("./assets/venus.png"), color(255,200,100));
        //planets[3] = new ImagePlanet(0, -2.1547e11d,6.39e23d, 3.3895e6d, new Vector(-24000 ,0),loadImage("./assets/mars.png"), color(255,100,100));
    }
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

    //center at 0,0
    //translate(width/2 -(float)scale(planets[1].getX()),height/2 - (float)scale(planets[1].getY()));
    translate(width/2, height/2);
    setAllOrigins(planets[1], planets);

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
