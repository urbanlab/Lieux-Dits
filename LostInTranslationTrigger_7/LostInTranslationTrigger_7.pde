import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Movie Sommeil,  Wake_up,  Wait_answer_1,Think,Explain_1, Pause,  Wait_answer_2, Explain_2, Invite_1, Wait_invite, Bug;
float Sommeil_Duree,  Wake_up_Duree,  Wait_answer_1_Duree,Think_Duree,Explain_1_Duree, Pause_Duree,  Wait_answer_2_Duree, Explain_2_Duree, Invite_1_Duree, Wait_invite_Duree, Bug_Duree;

Capture video;
OpenCV opencv;
int Nguys=16;
int ActiveGuys=0;
int PortDuinoPlan=0;
boolean Start;

Guy Guy1= new Guy();
Guy[] Guys = new Guy[Nguys];
PFont Font;
String StatusLine;
int MirrorMax=150;
int MirrorMin=20;
int MirrorStep=2;
int MirrorCurrentValue=MirrorMax;
int SensorPIR=0;
int SensorIRa=0;
int SensorIRb=0;
int SensorIRc=0;
boolean SensorIR;
boolean Presence;

int SensorUS=0;
int SensorSound=0;

boolean MirrorOn=false;

void movieEvent(Movie m)
{
//println(m.time() + " / " + m.duration() + " / " + (m.time() + movieEndDuration));  
 m.read();
}


void setup() 
{
  size(1200,600,P2D);
  
  Sommeil=new Movie(this, "Sommeil.mp4");
  Sommeil_Duree = Sommeil.duration();
  
  Wake_up=new Movie(this, "Wake_up.mp4");
  Wake_up_Duree = Wake_up.duration();
  /*
  Wait_answer_1=new Movie(this, "Wait_answer_1.mp4");
  Wait_answer_1_Duree = Wait_answer_1.duration();
  
  Think=new Movie(this, "Think.mp4");
  Think_Duree = Think.duration();
  
  Explain_1=new Movie(this, "Explain_1.mp4");
  Explain_1_Duree = Explain_1.duration();
  
  Pause=new Movie(this, "Pause.mp4");
  Pause_Duree = Pause.duration();
  
  Wait_answer_2=new Movie(this, "Wait_answer_2.mp4");
  Wait_answer_2_Duree = Wait_answer_2.duration();
  
  Explain_2=new Movie(this, "Explain_2.mp4");
  Explain_2_Duree = Explain_2.duration();
  
  Invite_1=new Movie(this, "Invite_1.mp4");
  Invite_1_Duree = Invite_1.duration();
  
  Wait_invite=new Movie(this, "Wait_invite.mp4");
  Wait_invite_Duree = Wait_invite.duration();
  
  Bug=new Movie(this, "Bug.mp4");
  Bug_Duree = Bug.duration();
  */
  
  video = new Capture(this, 640, 480);
  opencv = new OpenCV(this, 640, 480);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  video.start();
  frameRate(30);
  for(int i=0; i<Nguys; i++)
  {
    Guys[i]= new Guy();
  }
  
  Font = loadFont("ArialMT-24.vlw");
  textFont(Font);
  if (frame != null) frame.setResizable(true);
 
  //Connect(); ***************************
 
}

void draw() 
{
  background(255,255,255);
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
      //strokeWeight(1);
      stroke(255,255,255);
      rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    }
    else Guys[i].Decrease();
    if(Guys[i].Alive) ActiveGuys++;
  }

if((SensorIRa==1) || (SensorIRb==1) ||  (SensorIRc==1))SensorIR=true;

MirrorOn=false;

if(ActiveGuys>=2)MirrorOn=true; 
if((SensorIRa==1) && (SensorIRc==1)) MirrorOn=true; 
if ( (ActiveGuys>=1) && (SensorUS>0)) MirrorOn=true; 
if( (SensorIRc==1)  && (SensorUS>0)) MirrorOn=true; 
if( (SensorIRb==1)  && (SensorUS>0)) MirrorOn=true;
 
// Mirror(); ******************************

Presence=false;
if((SensorIRa==1)||(SensorIRb==1)||(SensorIRb==1)) Presence=true;
if(SensorUS>0) Presence =true;
if(ActiveGuys>=1) Presence =true;

 
 Start=false;
   if (keyPressed) 
   {
    if (key == 'a' || key == 'A') Start=true; 
   }
   if(SensorSound>220) Start=true;
   if(Start) println("START");
   else println();
   
 
 Avatar();
 
 
 fill(0,0,0);
 StatusLine="ActiveGuys="+ActiveGuys+", Mirror="+MirrorCurrentValue+", IRa="+SensorIRa+",IRb="+SensorIRb+",IRc="+SensorIRc+", US="+SensorUS+",Sound="+SensorSound;
 text(StatusLine,10,510);
}
//********************************************
void Mirror()
{
  if(MirrorOn)
  {
    if(MirrorCurrentValue > MirrorMin) MirrorCurrentValue -=MirrorStep;
  }
  else
  {
    if(MirrorCurrentValue < MirrorMax) MirrorCurrentValue +=MirrorStep;
  }
  if(MirrorCurrentValue < MirrorMin) MirrorCurrentValue=MirrorMin;
  if(MirrorCurrentValue > MirrorMax) MirrorCurrentValue=MirrorMax;
  MirrorSend(MirrorCurrentValue);
}
//****************************************************
void MirrorSend(int Consigne)
{
  String MirrorCmd;
  MirrorCmd="Mirror,"+Consigne+"\r";
  MirrorPort.write(MirrorCmd);
}
//****************************************************
void captureEvent(Capture c)
{
  c.read();
}