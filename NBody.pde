Planet[] planets;
PImage mercury,venus,earth,mars;
public double vectorLineScale;
int frame;
int trailInterval;

void setup(){
  size(1600,900);
  imageMode(CENTER);
  frame = 0;
  
  // Actual Solar System ----
  {
    vectorLineScale = 1/2e2d;
    trailInterval = 10;
    planets = new Planet[4];
  
    //sun
    planets[3] = new ImagePlanet(0,0,1.9891e30d, 6.9551e8d, new Vector(0,0),loadImage("./assets/sun.png"), color(255,255,100));
    //venus
    planets[0] = new ImagePlanet(0,-1.0742e11d,4.867e24d, 6.05e6d, new Vector(-35000 ,0),loadImage("./assets/venus.png"), color(255,200,100));
    //earth
    planets[1] = new ImagePlanet(0,-1.5e11d,5.972e24d, 6.371e6d, new Vector(-30000 ,0),loadImage("./assets/earth.png"), color(100,100,255));
    //mars
    planets[2] = new ImagePlanet(0, -2.1547e11d,6.39e23d, 3.3895e6d, new Vector(-24000 ,0),loadImage("./assets/mars.png"), color(255,100,100));
  }
  
  // Interesting Outcome ----
  //{
  //  vectorLineScale = 1/2e1d;
  //  trailInterval = 20;
  //  planets = new Planet[4];
    
  //  //mercury
  //  planets[0] = new ImagePlanet(1.5e11d,-1e11d, 3.25e23d * 1e3, 2.44e6d, new Vector(500, -700),loadImage("./assets/mercury.png"),color(200,200,200));
  //  //venus
  //  planets[1] = new ImagePlanet(1.5e11,-.5e11d, 4.867e24d * 1e3, 6.05e6d, new Vector(-100 ,0),loadImage("./assets/venus.png"),color(255,175,150));
  //  //earth
  //  planets[2] = new ImagePlanet(1.5e11, 1e11d, 5.972e24d * 1e3,  6.371e6d, new Vector(-1000,-500),loadImage("./assets/earth.png"),color(100,100,255));
  //  //mars
  //  planets[3] = new ImagePlanet(1.5e11, .5e11d, 6.39e23d * 1e3, 3.3895e6d, new Vector(-200,0),loadImage("./assets/mars.png"),color(255,100,100));
  //}

}

void draw(){
  
  frame = frame == trailInterval? 0 : frame + 1;
  
  background(10,10,40);
  for(int i = 0; i < 150000; i ++){
    
    //calculate velocity on all planets
    for(Planet p : planets){
       for(Planet p2 : planets){
         if(p != p2){
           p.calculateVelocity(p2);
         }
       }
    }
    //move all planets
    for(Planet p : planets){
      p.move();
    }
  }
  
  //center at 0,0
  translate(width/2f, height/2f);
  
  //draw
  for(Planet p : planets){
      p.drawTrail();
   }
   
  for(Planet p : planets){
      p.draw();
   }
   
   for(Planet p : planets){
      p.drawVector();
   }
    
  //add dot to trail every x frames
  if(frame == 0){
    for(Planet p : planets){
        p.addFrame();
     }
  }
  
}
