import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import processing.video.*;
import processing.sound.*;

Minim minim;
Movie mov;
Capture cam;

AudioOutput out;
int index = 0;
PImage Movie;
Oscil      wave;
Frequency  currentFreq;
int currentX, currentY;
int rectW = 140;


void setup() {
  size(1000,460);
  frameRate(20);
  background(0);
  String[] cameras = Capture.list();
  
  println("Available cameras:");
  printArray(cameras);
  //cam = new Capture(this, cameras[0]);
  
  //film
  mov = new Movie(this, "01010.mp4");
  mov.loop();
  
  minim = new Minim(this);
  out = minim.getLineOut();
  
  currentFreq = Frequency.ofPitch("A4");
  wave = new Oscil( 500, 1, Waves.SINE );
  
  wave.patch( out );
  
  noFill();
  stroke( 0, 0, 0 );
  
  //cam.start();
  
}

void movieEvent(Movie m) {
  m.read();
}
  
void draw() {
  
    if (mov.available() == true) {
    mov.read();
    //mov.read();
  }
  image(mov, 0, 0, width , height);
  filter(POSTERIZE, 4);
  filter(INVERT);
  filter(THRESHOLD);
  image(mov, 0, 0, width/3 , height/3);
  circle(currentX, currentY, rectW);
  
  int sum = 0;
 mov.loadPixels();
  
  //complication
  
    for(int x = currentX; x<currentX+rectW; x++){
    for(int y = currentY; y<currentY+rectW; y++){
      int index = x + mov.width*y;
      sum += brightness(mov.pixels[100]);
    }

  }
  sum /= sq(rectW);
  
  
  currentFreq = Frequency.ofHertz(sum);
  
  //text on screen

  
    if(sum > 0){
  textSize(32);
  stroke(0,0,0);
  text(sum, 500, 30); 
    }
    
        if(sum < 50){
  textSize(32);
  stroke(0,0,0);
  text("dark", 10, 30); 
    }
    
        if(sum > 150){
  textSize(32);
  text("light", 10, 30); 
    }
    
  stroke(0,0,0);
  fill(255, 255, 255);
  
  wave.setFrequency( currentFreq );
  currentX +=rectW;
  if(currentX> width){
    currentX = 0;
    currentY += rectW;
  }
  
  if(currentY >= height){
    currentY =0;
  }
  
  
}
