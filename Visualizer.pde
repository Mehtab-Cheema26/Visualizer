ArrayList<Spark> sparkList; 

import processing.sound.*;

FFT fft; // import fft 
Amplitude amp; // import amplitude
int bands = 256; // bands is very useful to make visualizers 
float[] spectrum = new float[bands]; // Array that has numbers from 1-bands

int xSpeed = 7; // speed of orange circles horizontally
int ySpeed = 5; // speed of orange circles vertically

int diameter; // diameter of large circle

int halfW; // half width 
int halfH; // half height

float y2Line1and2; // y2 coordinate of line 1 and 2 in line visualizer
float y2Line3and4; // y2 coordinate of line 3 and 4 in line visualizer

float m; //used to make triangles look like they are shaking
int counter = 0; //counts when the spark class is used
boolean purple = false;

SoundFile file; // allows playing of files 



//this function is initially run to setup program
void setup() {
  
  size(1500, 1200); // size of the window (width and height)
  background(0);// color of background (0 = black)
 
  sparkList = new ArrayList<Spark>(); //makes a new array list
  // Create a stream which is routed into the Amplitude analyzer
  fft = new FFT(this, bands); 
  amp = new Amplitude(this);
  
  file = new SoundFile(this, "Immigrant.mp3"); // chooses the file that will be played 
  
  // inputting the file in fft and amplitude
  fft.input(file); 
  amp.input(file); 

  //this starts the music
  file.play();
}      



//the following function keeps on happening
void draw() { 
  diameter = bands*2; 
  halfW = width/2; 
  halfH = height/2;
  background(0); 
  //make a = to the map
  float a = amp.analyze() * 50; 
  fft.analyze(spectrum); //Analyzes the spectrum
  fill(255);
  ifPurple(30); // weight
  circle(halfW, halfH, diameter); // Makes large circle in middle of screen
  
  // A loop that continues until i's value is above bands
  for(int i = 0; i < bands; i++){
    
    // Value is given to y2 coordinates of the line visualizers
    y2Line1and2 = halfH - spectrum[i] * halfH; 
    y2Line3and4 = halfH - (spectrum[i] * halfH) * -1;
  
    // Checks if the lines in line visualizer are out of the circle
    if (y2Line1and2 < halfH - bands){
      
        //since y2line3and4 are reflections of y2line1and2 their values would also change
        y2Line1and2 = halfH - bands;
        y2Line3and4 = halfH + bands;
      
        // circle is made to give the pump effect
        ifPurple(30);
        circle (halfW, halfH, (diameter) + bands/6);
        
     } // end if statement
    
    // the border color is changed to black and thickness is lower 
    strokeAndWeight(0, 0, 1, 5); 
    lineVisualizer(halfW + i, halfW + i * -1, halfH, y2Line1and2, y2Line3and4); //(x, xReflect, y1, y2, y2reflect)
    
    /* this if statement helps use a small range of spectrum instead of all and 
    it checks if spectrum[i] is between  15 and 20. It will make rectangles 
    based off of that*/
    
    if (i >= 15 && i <= 20){
      rectangles( height - spectrum[i]*height*20);
      } // end if statement
      
 
  } // end for loop
  
  
  if (counter == 5){ // this helps keep the code moving and not freeze
   counter = 0;
       
   // until r does not reach a (rounded) then keep on doing the following code
   // this for loop displays the gray circles
     for(int r = 0; r < int(a); r++){
     
       // the following is performed using the spark class
       sparkList.add(new Spark(width/4, height/2, a, false) ); 
       sparkList.add(new Spark(width - width/4, height/2, a, false) );
       sparkList.add(new Spark(width/2, height/4, a, true) );
       sparkList.add(new Spark(width/2, height - height/4, a, true) );
     
     } // end for loop
  } // end if statement
    
     for(int r = 0; r <= sparkList.size() -1; r++){ 
       Spark s = sparkList.get(r);
           
        // this removes the circle if it is out of the screen
          if(s.kill() == false){ // if it is not true it keeps on moving the circle
             s.move();
             s.display();
             } // end if statement
          else{ // if it is true, the circle is removed
             sparkList.remove(r); 
             } // end else statement
       } // end for loop
  counter ++;
  
  //for the colours of the triangles
    if (amp.analyze() < 0.40){ // if amp is less than 0.40 then circles become pink
    
      fill(251, 72, 96);
      purple = false;
    
  } // end if statement

  else { //otherwise they become purple
    
      fill(77,77,255);
      purple = true;
    
  }
  
  m = 20 * (amp.analyze()); // being repeated a lot through code so made into variable
  triangles(width/4, height/4 + m, width/5.5, height/8 + m); //(x1, y1, x2, y2)
  
  if (amp.analyze() < 0.10){ // if the amplitude is lower than 0.10, then my name will be shown
      
      fill(175);
      textSize(width/15);
      text("Made by Mehtab Cheema", bands/4 + bands/8, height - halfH/2, width - bands/4 - bands/8, height - halfH/2); // (str, x1, y1, x2, y2)  
    
  } // end if statement 
  smallCircles();
  
} // end draw


void strokeAndWeight(int r, int g, int b,int weight){ // Repeated many times so I chose to make a function 
  stroke (r, g, b); // r g b
  strokeWeight(weight);
}

void lineVisualizer(float x, float xReflect, float y1, float y2, float y2Reflect){
  
  //Following four lines were using a lot of the same formulas so I made them into a function for easy reading
  line(x, y1, x, y2);
  line(xReflect, y1, xReflect, y2);
  line(x, y1, x, y2Reflect);
  line(xReflect, y1, xReflect, y2Reflect); 

}

void triangles (float x1, float y1, float x2, float y2){
 
  // used a lot of the same formualas so I made them into a function for easy reading
  triangle(x1, y1,  x1/2, y1, x2, y2);
  triangle(width - x1, y1, width - x1/2, y1, width - x2, y2);
  triangle(x1, height - y2, x1/2, height - y2, x2, height - y1);
  triangle(width - x1, height - y2, width - x1/2, height - y2, width - x2, height - y1);

}

void smallCircles (){
  
  // 4 circles are made that have the same diameter and move around the screen
  circle(halfW + xSpeed, ySpeed * 2, bands/12); 
  circle(xSpeed * 2, halfH + ySpeed, bands/12);
  circle(halfW - xSpeed, ySpeed, bands/12);
  circle(xSpeed, halfH - ySpeed, bands/12);
  
  // if circles go outside of the visualizer then it brings them back to their original location
  if (xSpeed > width){ 
    xSpeed = 7;
    } 
  
  if (ySpeed > height) {
    ySpeed = 5;
    }
  
  xSpeed += amp.analyze() * 30; // adds to x coordinate so they can move
  ySpeed += amp.analyze() * 30; // adds to y coordinate so they can move

} 

void rectangles(float rectHeight){
  
  fill(57, 255, 14); // makes rectangles neon green
  //rectangles are made
  rect(0, height, bands/4, rectHeight); 
  rect( width - bands/4, height, bands/4, rectHeight); 

}

void ifPurple(int weight){ // repeated twice so made into function
  if (purple == true){ 
    
      strokeAndWeight(77,77,255, weight);
  
  }else { // don't need to add else if statement because booleans only have two options
      
      strokeAndWeight(251, 72, 96, weight);
  
  }
  
}
