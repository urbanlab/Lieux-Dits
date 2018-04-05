//TODO:
// * lancement automatique demarrage Windows
// https://www.pcastuces.com/pratique/astuces/4582.htm
// * 3 destinations prédéfinies / reconnues => 3 descriptions de trajet



//http://localhost/
//C:/inetpub/wwwroot
//https://msdn.microsoft.com/fr-fr/library/ms181052(v=vs.80).aspx
//https://gist.github.com/jgravois/5e73b56fa7756fd00b89
//http://florianschulz.info/stt/
//https://shapeshed.com/html5-speech-recognition-api/
//https://html5demo.pingfiles.fr/demo/speechRecognitionAPI.php
//http://www.local-guru.net/blog/pages/ttslib
//https://developer.mozilla.org/fr/docs/Web/API/SpeechRecognition


//TODO

import gab.opencv.*;
import processing.video.*;
import processing.video.Movie;
import java.awt.*;
import websockets.*;
import guru.ttslib.*;
import processing.sound.*;
import ddf.minim.*;

Minim minim;
AudioPlayer fileOK,Compute, AlexLaugh;

//SoundFile fileOK,Compute, AlexLaugh;

boolean ModeDebug;

Movie Bonjour, BonVoyage, OKdest, Repeat, Reprise, RoadMap, Sorry, Wait;
WebsocketServer socket;
boolean SocketFlag=false;
String Text;

Capture video;
OpenCV opencv;
int Nguys=16;
int ActiveGuys=0;
int PortDuinoPlan=0;
boolean Start;
boolean MoviePlaying=false;
Guy Guy1= new Guy();
Guy[] Guys = new Guy[Nguys];
PFont Font;
String StatusLine;
int MirrorMax=180;
int MirrorMin=20;
int MirrorStep=1;
int MirrorCurrentValue=MirrorMax;
int SensorPIR=0;
int SensorIRa=0;
int SensorIRb=0;
int SensorIRc=0;
boolean SensorIR;
int SensorUS=0;
int SensorSound=0;
boolean MirrorOn=false;
boolean FlagFaces=false;
Rectangle[] faces;
String SpeachText="?";
int AutomateSocket=0;
boolean FlagTxt=false;
String Destination="";
Boolean FlagTemp; //**************** MODIF
int TimerPresence=0;
boolean Presence=false;
PImage Carte, Silhouettes;
String sAva="";
String Link[];
Process process;
boolean DestOK=false;
boolean FlagMirrorOff=false;
boolean MoreThanOne=false;
int MirrorTimer=0;

void movieEvent(Movie m)
{
  m.read();
}

void webSocketServerEvent(String msg) //************** MODIF
{
  print("MSG=");
  println(msg);
  if(msg.indexOf("rigol")>-1)Laugh();
  if(msg.indexOf("drôle")>-1)Laugh();
  if(msg.indexOf("marrant")>-1)Laugh();
  if(msg.indexOf("amus")>-1)Laugh();
  if(msg.indexOf("rire")>-1)Laugh();
  if(msg.indexOf("Alexa")>-1)Laugh();
  
  if(FlagTxt) SpeachText=msg;
  else SpeachText="?";
  
  if(msg.indexOf("allez vous")>-1)SpeachText="?";
  if(msg.indexOf("allez-vous")>-1)SpeachText="?";
  if(msg.indexOf("aller vous")>-1)SpeachText="?";
  if(msg.indexOf("trajet")>-1)SpeachText="?";
  if(msg.indexOf("vous")>-1)SpeachText="?";
  if(msg.indexOf("ou non")>-1)SpeachText="?";
  
  if(msg.indexOf("jean macé")>-1) DestOK=true;
  if(msg.indexOf("Jean Macé")>-1) DestOK=true;
  if(msg.indexOf("Macé")>-1) DestOK=true;
  if(msg.indexOf("masser")>-1) DestOK=true;
  if(msg.indexOf("massé")>-1) DestOK=true;
  
}
//**********************************************************************
void setup() 
{
 
  launch("TASKKILL /IM chrome.exe");
  
  //size(800, 600, P2D);
  fullScreen(P2D);
  //size(1080, 1920,P2D);
  surface.setAlwaysOnTop(false);
  
  ModeDebug=false;
  minim = new Minim(this);
  
  
  fileOK = minim.loadFile("beepOK.mp3");
  Compute= minim.loadFile("sensors.mp3");
  AlexLaugh=minim.loadFile("AlexLaugh.mp3");
  
  //fileOK = new SoundFile(this, "beepOK.mp3");
  //Compute=new SoundFile(this, "Sensors.mp3");
  //AlexLaugh= new SoundFile(this, "AlexLaugh.mp3");
  
  delay(500);
  
  
  Carte = loadImage("TrajetJeanMace.jpg");
  Silhouettes= loadImage("silhouettes.jpg");
 
  Bonjour= new Movie(this,"Bonjour.mp4");
  BonVoyage= new Movie(this,"BonVoyage.mp4");
  OKdest= new Movie(this,"OKdest.mp4");
  Repeat= new Movie(this,"Repeat.mp4");
  Reprise= new Movie(this,"Reprise.mp4");
  RoadMap= new Movie(this,"RoadMap.mp4");
  Sorry= new Movie(this,"Sorry.mp4");
  Wait= new Movie(this,"Wait.mp4");
  
  
  
  String[] cameras = Capture.list();

  if (cameras.length == 0) 
  {
    println("There are no cameras available for capture.");
    exit();
  } else 
  {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) 
    {
      println(cameras[i]);
    }
  }

  video = new Capture(this, 640, 480, 30);
  video.start();
  opencv = new OpenCV(this, 640, 480);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  
 

  if (!ModeDebug) 
  {
    noCursor();
  } 

  frameRate(100);
  for (int i=0; i<Nguys; i++)
  {
    Guys[i]= new Guy();
  }
  Font = loadFont("ArialMT-24.vlw");
  textFont(Font);
  Connect();
  
  Link = new String[] { "C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe", "http://localhost/" };
  socket = new WebsocketServer(this, 1337, "/p5websocket");
  LaunchChrome();
  Beep();
  
}
//***********************************************************************
void draw() 
{
  
  background(0);
  
  if(ModeDebug) background(0, 0, 0);
  FacesDetect();
  if(!ModeDebug) background(0, 0, 0);


  ReadSensorSerial();
  if ((SensorIRa==1) || (SensorIRb==1) ||  (SensorIRc==1)) SensorIR=true;
  
  MoreThanOne=false;
  if (ActiveGuys>=3) MoreThanOne =true; 
  //if ((ActiveGuys>=1)  && (SensorIRc==1)) MoreThanOne=true;
  if ((SensorIRa==1) && (SensorIRc==1)) MoreThanOne=true; 
  //if ( (SensorIRb==1)  && (SensorUS>0)) MoreThanOne=true; 
  if ( (SensorIRc==1)  && (SensorUS>0)) MoreThanOne=true; 
  
  if(MoreThanOne) MirrorTimer+=2;
  if(MirrorTimer>300) MirrorTimer=300;
  else MirrorTimer--;
  if (MirrorTimer < 0)MirrorTimer=0;
  
  if(MirrorTimer > 0) MirrorOn=true; 
  else MirrorOn=false;
  Mirror();
  
   //************************************************************ MODIF
  FlagTemp=false;
  if ((SensorIRa==1)||(SensorIRb==1)||(SensorIRb==1)) FlagTemp=true;
  if (SensorUS>0) FlagTemp =true;
  if (ActiveGuys>=1) FlagTemp =true;

  if(FlagTemp)
  {
    TimerPresence=0;
    Presence=true;
  }
  else
  {
    if(TimerPresence<3000) TimerPresence++;
    if(TimerPresence > 100) Presence=false;
  }
  
  Avatar();
  
  //println(frameRate);
  //if (ModeDebug)
  {
    //fill(255, 255, 255);
    fill(255,0,0);
    StatusLine="Ava="+sAva+", ActiveGuys="+ActiveGuys+", Mirror="+MirrorCurrentValue+", IRa="+SensorIRa+",IRb="+SensorIRb+",IRc="+SensorIRc+", US="+SensorUS+",Mir="+MirrorOn+",MirTime="+MirrorTimer;
    text(StatusLine, 15, 1860);
    //text(StatusLine, 10, 30);
    //text(SpeachText,10,1860);
  }
  
}
//*******************************************************************************
void LaunchChrome()
{
   String windowsCmd = "C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe http://localhost/";
    try 
      {
       process = Runtime.getRuntime().exec(windowsCmd); 
      }
      catch(IOException e) 
      {
        println("runExternalCommand: IOException:" + e);
      }
}