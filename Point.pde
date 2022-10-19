class Point {
    double x,y;
    
    Point(double x, double y){
        this.x = x;
        this.y = y;
    }
    
    double getX(){
        return x;
    }
    
    double getY(){
        return y;
    }
    
    float getFlX(){
        return (float)x;
    }
    
    float getFlY(){
        return (float)y;
    }
    
    Point getMidpoint(Point other){
        return new Point(
            (this.getX() + other.getX()) / 2,
            (this.getY() + other.getY()) / 2
            );
    }
    
    double getDist(Point other){
         return Math.sqrt(Math.abs(
            Math.pow((x - other.getX()), 2) +
            Math.pow((y - other.getY()), 2)
            ));
    }
    String toString(){
        return(x + ", "  + y);
    }
}
