

 int SOMMEIL = 0;
 int WAKE_UP = 1;
 int WAIT_ANSWER_1 = 2;
 int THINK =3;
 int EXPLAIN_1 = 4;
 int PAUSE = 5;
 int WAIT_ANSWER_2 = 6;
 int EXPLAIN_2 =7;
 int INVITE_1 =8;
 int WAIT_INVITE_1 =9;
 int INVITE_2 =10;
 int WAIT_INVITE_2 =11;
 int BUG =12;

int Ava=SOMMEIL;
int Previous=-1;
boolean Change=false;
float Timer=0.0;

void Avatar()
{
  //TODO: conditions raz si plus personne
  
  if(Timer<30000) Timer++;

  switch(Ava)
  {
    
    case 0: //SOMMEIL *
            
            if(Change) Sommeil.loop();
            image(Sommeil,0,0);
            if(ActiveGuys==0) Timer=0;
            if(Timer > 50) 
            {
              Sommeil.stop();
              Ava=WAKE_UP;
            }
    break;
    
    case 1: //WAKE_UP *
            Wake_up.play();
            image(Wake_up,0,0);
            if((Wake_up.time()+Wake_up_Duree )>=Wake_up.duration())
            {
              Wake_up.stop();
              Ava=WAIT_ANSWER_1;
            }
    break;
    /*
    case 2: //WAIT_ANSWER_1 *
            if(Change) Wait_answer_1.loop();
            if(Start) Ava= THINK;
    break;
    case 3: //THINK *
            Think.play();
            if((Think.time()+Think_Duree )>=Think.duration())
            {
              Think.stop();
              Ava=EXPLAIN_1;
            }
    break;
    case 4: //EXPLAIN_1 *
            Explain_1.play();
            
            if((Timer > 1000) && MirrorOn) 
            {
              Explain_1.stop();
              Ava=PAUSE;
            }
            if((Explain_1.time()+Explain_1_Duree )>=Explain_1.duration())
            {
              Explain_1.stop();
              Ava=SOMMEIL;
            }
    break;
    case 5: //PAUSE *
            Pause.play();
            if((Pause.time()+Pause_Duree )>=Pause.duration())
            {
              Pause.stop();
              if(!MirrorOn) Ava=WAIT_ANSWER_2;
              //if((SensorUS==0) ) Ava=WAIT_ANSWER_2;
              else Ava=INVITE_1;
            }
    break;
    case 6: //WAIT_ANSWER_2 *
            if(Change) Wait_answer_2.loop();
            if(Start) Ava=EXPLAIN_2 ;
    break;
    case 7: //EXPLAIN_2 *
            Explain_2.play();
            
            if((Explain_2.time()+Explain_2_Duree )>=Explain_2.duration())
            {
              Explain_2.stop();
              Ava=SOMMEIL;
            }
    break;
    case 8: //INVITE_1 *
            Invite_1.play();
            
            if((Invite_1.time()+Invite_1_Duree ) >= Invite_1.duration())
            {
              Invite_1.stop();
              Ava=WAIT_INVITE_1;
            }
    break;
    case 9: //WAIT_INVITE_1 *
             Wait_invite.play();
            
            if((Wait_invite.time()+Wait_invite_Duree )>=Wait_invite.duration())
            {
              Wait_invite.stop();
              Ava=BUG;
            }
    break;
    case 10: //INVITE_2
    break;
    case 11: //WAIT_INVITE_2
    break;
    case 13: //BUG *
            if(Change) Bug.loop();
            if(!Presence) Ava= SOMMEIL;
    break;
    */
  }
  
  if(Ava != Previous) 
  {
    Change=true;
    Timer=0;
  }
  else Change=false;
  Previous=Ava;
  
}