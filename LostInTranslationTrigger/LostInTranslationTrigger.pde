import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;
int Nguys=16;
int ActiveGuys=0;

Guy Guy1= new Guy();
Guy[] Guys = new Guy[Nguys];

void setup() 
{
  //size(640,480);
  size(1200,600);
  video = new Capture(this, 640, 480);
  opencv = new OpenCV(this, 640, 480);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  video.start();
  frameRate(30);
  for(int i=0; i<Nguys; i++)
  {
    Guys[i]= new Guy();
  }
}

void draw() 
{
  opencv.loadImage(video);
  image(video, 0, 0 );
  Rectangle[] faces = opencv.detect();
  
  ActiveGuys=0;
  for (int i = 0; i < Nguys ; i++) 
  {
    if(faces.length >i) 
    {
      Guys[i].Compute(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
      noFill();
      strokeWeight(1);
      stroke(255,255,255);
      rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    }
    else Guys[i].Decrease();
    if(Guys[i].Alive) ActiveGuys++;
  }
  
 println(ActiveGuys);
}

void captureEvent(Capture c)
{
  c.read();
}