//gravitational constant
final static double G = 6.6743e-11d;

//scales a double by the scale defined in NBody.pde
double scale(double n) {
    return(n/scale);
}

//scales a point using formula above
Point scale(Point p) {
    return new Point(scale(p.getX()), scale(p.getY()));
}

//makes all positions relative to one planet
static void setAllOrigins(Planet o, Planet[] planets) {
    for (Planet p : planets) {
        //the planet I'm setting the others' orgins to has to be moved last
        if (p != o) {
            p.setOriginTo(o);
        }
    }
    o.setOriginTo(o);
}



//abstract planet class does not include draw
abstract class Planet {

    double mass, radius;
    Point pos;
    Vector velocity;
    ArrayList<Point> trail;

    public Planet(Point startPos, double mass, double radius, Vector startVelocity) {
        this.pos = startPos;
        this.trail = new ArrayList<Point>();
        this.mass = mass;
        this.velocity = startVelocity;
        this.radius = radius;
    }

    //getters
    Point getPos() {
        return pos;
    }

    double getX() {
        return pos.getX();
    }

    double getY() {
        return pos.getY();
    }

    double getMass() {
        return mass;
    }

    ArrayList<Point> getTrail() {
        return trail;
    }

    double getDistance(Planet other) {
        return(pos.getDist(other.getPos()));
    }

    //math functions
    double getForce(Planet other) {
        //dist between two planets
        double dist = getDistance(other);
        //G(m1m2 / r^2)
        return G * ((mass*other.getMass())/Math.pow(dist, 2));
    }

    Vector getGravFrom(Planet other) {
        //normal vector to sun
        return new Vector(other.getX() - pos.getX(), other.getY() - pos.getY()).normalize()
            //F / m = a
            .scale(getForce(other)/mass);
    }

    void calculateVelocity(Planet other) {
        velocity = velocity.add(getGravFrom(other));
    }

    void move() {
        pos = new Point(
            pos.getX() +  velocity.getDX(),
            pos.getY() +  velocity.getDY()
            );
    }

    //draws movement vector
    void drawVector() {
        Point p = scale(pos);
        Vector v = velocity.scale(vectorLineScale);
        float dx = (float)v.getDX();
        float dy = (float)v.getDY();

        stroke(255, 255, 255);
        strokeWeight(3);
        line(p.getFlX(), p.getFlY(), p.getFlX()+dx, p.getFlY()+dy);
    }

    //adds a dot to the trail
    void addFrame() {
        trail.add(pos);
    }

    //makes porition relative to another planet
    void setOriginTo(Planet p) {
        pos = new Point(pos.getX()  - p.getX(), pos.getY() - p.getY());
    }

    //L4's y is the height of an equalateral triangle, and l5's Y is -1 * L4's y
    double calculateL4Y(Planet small) {
        return (Math.sqrt(3) / 2) * getDistance(small);
    }

    //calculates raduis of hill sphere which is the distance from earth to l1 and l2
    double calculateL1X(Planet small) {
        double quotient = small.getMass() / (3 * mass);
        return getDistance(small) * Math.cbrt(quotient);
    }

    //this is called my child classes who set the color
    void drawTrail() {
        for (int i = 0; i < trail.size(); i++) {
            Point p = scale(trail.get(i));
            circle(p.getFlX(), p.getFlY(), 4f);
        }
    };

    //image planets and color planets are drawn differently
    abstract void draw();
}


class ColorPlanet extends Planet {
    color c;
    public ColorPlanet(Point startPos, double mass, double radius,
        Vector startVelocity, color clr) {
        super(startPos, mass, radius, startVelocity);
        this.c = clr;
    }

    void draw() {
        fill(c);
        noStroke();
        Point p = scale(pos);
        circle(p.getFlX(), p.getFlY(), (float)Math.pow(radius, 1/4f));
    }

    //draw trail with color
    void drawTrail() {
        fill(c);
        noStroke();
        super.drawTrail();
    }
}

class ImagePlanet extends Planet {
    PImage img;
    color trailColor;

    public ImagePlanet(Point startPos, double mass, double radius,
        Vector startVelocity, PImage img, color trailColor) {
        super(startPos, mass, radius, startVelocity);
        this.trailColor = trailColor;
        this.img = img;

        //resize image
        this.img.resize((int)Math.pow(radius, 1/4f), (int)Math.pow(radius, 1/4f));
    }

    void draw() {
        Point p = scale(pos);
        image(img, p.getFlX(), p.getFlY());
    }

    //draw trail with color
    void drawTrail() {
        fill(trailColor);
        noStroke();
        super.drawTrail();
    }
}
