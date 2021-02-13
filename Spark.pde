class Spark{ //is a blueprint
  
  float x;
  float y;
  float r;
  float velocity;
  float rotation;
  boolean moveH; //moveH is short for move horizontally
  int red; // red
  int g; // green
  int b; // blue
  
  Spark(float tx, float ty, float tv, boolean horizontal){ //these are just temporary for when we create it
    
    // changes the outer variables to variables that can be used throughout this tab
    x = tx; // used to change X
    y = ty; // used to change y
    r = 10; 
    velocity = tv;
    moveH = horizontal;
    red = 255;
    g = 255;
    b = 255;
    rotation = random(0, 2*PI);
   
  }//end constructor
  
  void display(){
    
    fill(r, g, b);
    ellipse(x,y,velocity,velocity); // makes it bigger or smaller based on amplitude
  
  } //move display
  
  void move(){
    red -= 10; // everytime the circle moves, it gets closer to turning dark making it look like it has vanished
    g -= 20; 
    b -= 10;
    
    // following if statement decides whether to move balls vertically or horizontally so they do not collide
    // movement depends on amplitude
    
        if (moveH == true){ 
          x += velocity * cos(rotation ); 
        }
        else{
      y += velocity * sin(rotation );
      }
    }//end move
  
  boolean kill(){//decides whether the circle has become dark enough to not be seen and when it has the circle is removed 
     if(g <= 10){ // g is used because it has the largest value
      return true; // if it is true then it removes the circle in the main tab
    }
    else{
      return false; 
    }
    
  }//end kill
  
  
}//end ball
