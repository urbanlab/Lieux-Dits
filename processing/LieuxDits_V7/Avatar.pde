int AvatarPosX;
int AvatarPosY;
int AvatarW, AvatarH;

private static final int INIT = 0;
private static final int WAKE_UP = 1;
private static final int WAIT_DEST = 2;
private static final int ASK_AGAIN =3;
private static final int CALCUL_DEST = 4;
private static final int SAY_DEST = 5;
private static final int ROAD_MAP = 6;
private static final int SAY_NOT_EASY =7;
private static final int WAIT_HELP =8;
private static final int BON_VOYAGE =9;
private static final int REPRISE =10;
private static final int WAIT =11;


int Ava=INIT;
int Previous=-1;
boolean Change=false;
float Timer=0.0;

void Silhouettes()
{
  image(Silhouettes,600, 1500,1200, 350);
}


void Beep()
{
  //fileOK.amp(1);
  fileOK.rewind();
  fileOK.play();
  
}

void Laugh()
{
  println("************ LAUGH *****************");
  //AlexLaugh.amp(1);
  AlexLaugh.rewind();
  AlexLaugh.play();
}


void Avatar()
{
  
  
  imageMode(CENTER);
  AvatarPosX=(width/2-80);
  if (ModeDebug) AvatarPosY=(height/2+200);
  else AvatarPosY=(height/2-300);
  
  
  AvatarW=1800;
  AvatarH=1300;
  int CartePosX= AvatarPosX+100;
  int CartePosY= AvatarPosY+900; 
  int CarteX=1000;
  int CarteY=500;

  if (Ava != Previous) 
  {
    Change=true;
    Timer=0;
    println(sAva);
  } 
  else Change=false;
  Previous=Ava;

  if (Timer<10000) Timer++;

  switch(Ava) //******************************************************
  {
    case INIT:
      if (Change) 
        {
           sAva="INIT";
           socket.sendMessage("Urban Lab, le dispositif Lieux Dits est prêt a connecter les voyageurs !");
           delay(6000);
           //launch("TASKKILL /IM chrome.exe /F");
           launch("TASKKILL /IM chrome.exe ");
           ActiveGuys=0;
           SpeachText="?";
           FlagTxt=false;
           Destination="";
           surface.setAlwaysOnTop(false);
           FlagMirrorOff=false;
        }
        FlagTxt=false;
        long r = (long)random(0, 100000);
        print("Random=");
        println(r);
        if(r==23) Laugh();
       
    
    if ((Timer > 150) && ( (ActiveGuys>0)||(SensorUS>0)||(SensorIRa==1)||(SensorIRb==1))) Ava=WAKE_UP;
    //println(Timer);
    
    break;
    
    case WAKE_UP:
      if(Change)
        {
          LaunchChrome();
          sAva="WAKE_UP";
          //Beep();
          //Compute.rewind();
          //Compute.play();
          //delay(500);
          Bonjour.play();
        }
        image(Bonjour, AvatarPosX, AvatarPosY,AvatarW, AvatarH);
        //Silhouettes();
         SpeachText="?";
         FlagTxt=false;
        if (Bonjour.time()>=Bonjour.duration()-2) 
        {
          Ava=WAIT_DEST;
          Bonjour.stop();
        }
    break;
    
    case WAIT_DEST:
        if(Change)
        {
          sAva="WAIT_DEST";
          Beep();
          Wait.play();
          SpeachText="?";
          DestOK=false;
          FlagTxt=true;
        }
        image(Wait, AvatarPosX, AvatarPosY,AvatarW, AvatarH);
         fill(0,0,0);
         text("Destination => Jean Macé", 300,200);
        if (Wait.time()>=Wait.duration()-0.2) 
        {
          Ava=ASK_AGAIN;
          Wait.stop();
        }
        if (SpeachText!="?")
        {
          if(DestOK)
          {
          Destination=SpeachText;
          Ava=CALCUL_DEST;
          }
          else
         {
          Ava=ASK_AGAIN;
          Wait.stop();
        }
        }
        
        
    break;
    
    case ASK_AGAIN:
      if(Change)
        {
          sAva="ASK_AGAIN";
          Repeat.play();
        }
        image(Repeat, AvatarPosX, AvatarPosY,AvatarW, AvatarH);
         fill(0,0,0);
         text("Destination => Jean Macé", 300,200);
         SpeachText="?";
         FlagTxt=false;
      if (Repeat.time()>=Repeat.duration()-0.2) 
      {
        Repeat.stop();
        
        if(!Presence )Ava=INIT;
        else Ava=WAIT_DEST; 
      }
      
    break;
    
    case CALCUL_DEST:
       if(Change)
        {
          sAva="CALCUL_DEST";
          OKdest.play();
          
        }
      image(OKdest, AvatarPosX, AvatarPosY,AvatarW, AvatarH);
      if (OKdest.time()>=OKdest.duration()-0.2) 
      {
        OKdest.stop();
        Ava=SAY_DEST; 
      }
    break;
    
    case SAY_DEST:
      if(Change)
        {
          sAva="SAY_DEST";
          socket.sendMessage(Destination);
          Wait.play();
        }
        image(Wait, AvatarPosX, AvatarPosY,AvatarW, AvatarH);
        //println(Timer);
        if (Timer > 80)
        {
          Wait.stop();
          Ava=ROAD_MAP;
          //Compute.amp(1);
          //Compute.play();
        }
    break;
    
    case ROAD_MAP:
      if(Change)
        {
          Compute.rewind();
          Compute.play();
          delay(500);
          sAva="ROAD_MAP";
          RoadMap.play();
          FlagMirrorOff=true;
        }
        
        image(RoadMap, AvatarPosX, AvatarPosY,AvatarW, AvatarH);
        if(RoadMap.time()>3.4) 
        {
          image(Carte,CartePosX, CartePosY,CarteX, CarteY);
          surface.setAlwaysOnTop(true);
        }
        if(RoadMap.time()>=RoadMap.duration()-0.2) 
        {
          Ava=WAIT;
          RoadMap.stop();
        }
        
        if((RoadMap.time()>=RoadMap.duration()-15) && (MirrorOn==true)) 
        {
          Ava=SAY_NOT_EASY;
          RoadMap.stop();
        }
    break;
    
    case SAY_NOT_EASY:
       if(Change)
        {
          sAva="SAY_NOT_EASY";
          Sorry.play();
          FlagMirrorOff=false;
        }
        image(Sorry, AvatarPosX, AvatarPosY,AvatarW, AvatarH);
        if(Sorry.time()>3.3) Silhouettes();
        
        SpeachText="?";
        FlagTxt=false;
        if(Sorry.time()>=Sorry.duration()-0.2) 
        {
          Sorry.stop();
          Ava=WAIT_HELP;
        }
    break;
    
    case WAIT_HELP:
      if(Change)
      {
        Beep();
        sAva="WAIT_HELP";
        Wait.loop();
        SpeachText="?";
        FlagTxt=true;
        
      }
      image(Wait, AvatarPosX, AvatarPosY,AvatarW, AvatarH);
      Silhouettes();
      
      if(!Presence && Timer >1000)
        {
          Wait.stop();
          Ava=INIT;
        }
      //println(Timer);
      if (Timer<5) SpeachText="?";
      
      if (SpeachText!="?") 
        {
          Destination=SpeachText;
          SpeachText="?";
          Wait.stop();
          Ava=SAY_NOT_EASY;
          int OuiPos=Destination.indexOf("oui");
          print("OUI=");
          println(OuiPos);
          int NonPos=Destination.indexOf("non");
          print("NON=");
          println(NonPos);
          //if(Destination.equals("oui")) 
          if(OuiPos > -1)
          {
            Wait.stop();
            Ava=BON_VOYAGE;
          }
          //if(Destination.equals("non"))
          if(NonPos > -1)
          {
            Wait.stop();
            Ava=REPRISE;
          }
        }
    break;
    
    case REPRISE:
      if(Change)
      {
        Beep();
        sAva="REPRISE";
        Reprise.play();
        surface.setAlwaysOnTop(true);
        FlagMirrorOff=true;
      }
      
      image(Reprise, AvatarPosX, AvatarPosY,AvatarW, AvatarH);
      if(Reprise.time()>2) image(Carte,CartePosX, CartePosY,CarteX, CarteY);
      if(Reprise.time()>=Reprise.duration()-0.2) 
        {
          Reprise.stop();
          Ava=WAIT;
        }
    break;
    
    case BON_VOYAGE:
      if(Change)
      {
        Beep();
        sAva="BON_VOYAGE";
        BonVoyage.play();
        surface.setAlwaysOnTop(true);
        FlagMirrorOff=false;
      }
      image(BonVoyage, AvatarPosX, AvatarPosY,AvatarW, AvatarH);
      if(BonVoyage.time()>1) image(Carte,CartePosX, CartePosY,CarteX, CarteY);
      
      if(BonVoyage.time()>=BonVoyage.duration()-0.2) 
        {
          BonVoyage.stop();
          Ava=WAIT;
        }
    break;
    
    case WAIT:
      if(Change)
        {
          sAva="WAIT";
          Wait.loop();
          FlagMirrorOff=false;
        }
        if(Timer<300) 
        {
          image(Wait, AvatarPosX, AvatarPosY,AvatarW, AvatarH);
          image(Carte,CartePosX, CartePosY,CarteX, CarteY);
        }
        //println(Timer);
        if(!Presence)
        {
          Wait.stop();
          Ava=INIT;
        }
    break;
  }
  
}