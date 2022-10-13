final static double G = 6.6743e-11d;

static double scale(double n) {
    return(n/scale);
}

static void setAllOrigins(Planet o, Planet[] planets) {
    for (Planet p : planets) {
        if (p != o) {
            p.setOriginTo(o);
        }
    }
    o.setOriginTo(o);
}

static double calculateMassCenter(double m1, double x1, double m2, double x2) {
    return ((m1 * x1) + (m2 * x2)) / (m1 + m2);
}


//abstract planet class does not include draw
abstract class Planet {
    double x, y, mass, radius;
    Vector velocity;
    ArrayList<Double> trailX;
    ArrayList<Double> trailY;

    public Planet(double startX, double startY, double mass, double radius, Vector startVelocity) {
        this.x = startX;
        this.trailX = new ArrayList<Double>();
        this.y = startY;
        this.trailY = new ArrayList<Double>();
        this.mass = mass;
        this.velocity = startVelocity;
        this.radius = radius;
    }

    //getters
    double getX() {
        return x;
    }
    double getY() {
        return y;
    }
    double getMass() {
        return mass;
    }

    double getDistance(Planet other) {
        return Math.sqrt(Math.abs(
            Math.pow((x - other.getX()), 2) +
            Math.pow((y - other.getY()), 2)
            ));
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
        return new Vector(other.getX() - x, other.getY() - y).normalize()
            //F / m = a
            .scale(getForce(other)/mass);
    }

    void calculateVelocity(Planet other) {
        velocity = velocity.add(getGravFrom(other));
    }

    void move() {
        x += velocity.getDX();
        y += velocity.getDY();
    }

    void drawVector() {
        float nx = (float)scale(x);
        float ny =  (float)scale(y);
        Vector v = velocity.scale(vectorLineScale);
        float dx = (float)v.getDX();
        float dy = (float)v.getDY();

        stroke(255, 255, 255);
        strokeWeight(3);
        line(nx, ny, nx+dx, ny+dy);
    }

    void addFrame() {
        trailX.add(scale(x));
        trailY.add(scale(y));
    }

    void setOriginTo(Planet p) {
        this.x -= p.getX();
        this.y -= p.getY();
    }

    //double calculateL4X(Planet small) {
    //  double quotient = (mass - small.getMass()) / (mass + small.getMass());
    //  return (getDistance(small)/2) * quotient;
    //}

    //double calculateL4Y(Planet small) {
    //  return (Math.pow(3, 1/2)/2) * getDistance(small);
    //}

    double calculateL1X(Planet small) {
        double quotient = small.getMass() / (3 * mass);
        return getDistance(small) * Math.cbrt(quotient);
    }

    abstract void drawTrail();

    abstract void draw();
}


class ColorPlanet extends Planet {
    color c;
    public ColorPlanet(double startX, double startY, double mass, double radius,
        Vector startVelocity, color clr) {
        super(startX, startY, mass, radius, startVelocity);
        this.c = clr;
    }

    void draw() {
        fill(c);
        noStroke();
        float nx = (float)scale(x);
        float ny =  (float)scale(y);
        circle(nx, ny, (float)Math.pow(radius, 1/4f));
    }

    void drawTrail() {
        fill(c);
        noStroke();
        for (int i = 0; i < trailX.size(); i++) {
            circle((float)(trailX.get(i).doubleValue()), (float)(trailY.get(i).doubleValue()), 4f);
        }
    }
}

class ImagePlanet extends Planet {
    PImage img;
    color trailColor;

    public ImagePlanet(double startX, double startY, double mass, double radius,
        Vector startVelocity, PImage img, color trailColor) {
        super(startX, startY, mass, radius, startVelocity);
        this.trailColor = trailColor;
        this.img = img;

        //resize image
        this.img.resize((int)Math.pow(radius, 1/4f), (int)Math.pow(radius, 1/4f));
    }

    void draw() {
        float nx = (float)scale(x);
        float ny =  (float)scale(y);
        image(img, nx, ny);
    }

    void drawTrail() {
        fill(trailColor);
        noStroke();
        for (int i = 0; i < trailX.size(); i++) {
            circle((float)(trailX.get(i).doubleValue()), (float)(trailY.get(i).doubleValue()), 4f);
        }
    }
}
