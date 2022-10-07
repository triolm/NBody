class Vector {
    private double dx, dy;

    public Vector(double dx, double dy) {
        this.dx = dx;
        this.dy = dy;
    }

    public double getDX() {
        return this.dx;
    }

    public double getDY() {
        return this.dy;
    }

    public Vector scale(double scalar) {
        double newdx = dx * scalar;
        double newdy = dy * scalar;
        return new Vector(newdx, newdy);
    }

    public double dot(Vector v) {
        return dx * v.getDX() + dy * v.getDY();
    }

    public Vector subtract(Vector v) {
        double newDX = dx - v.getDX();
        double newDY = dy - v.getDY();
        return new Vector(newDX, newDY);
    }

    public Vector add(Vector v) {
        double newDX = dx + v.getDX();
        double newDY = dy + v.getDY();
        return new Vector(newDX, newDY);
    }

    public double length() {
        return Math.sqrt(this.dot(this));
    }

    public Vector normalize() {
        return this.scale(1 / this.length());
    }
    
    public String toString(){
      return dx + " " + dy;
    }

}
