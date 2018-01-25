
/***************************************************************************/
#include "RGBdriver.h"

#define CR 0x0D
#define LF 0x0A
#define SPLITTERS 10 // nombre de délimiteurs MAX pris en compte
#define SPLIT ','

#define CLK 2//pins definitions for the driver        
#define DIO 3

RGBdriver Driver(CLK, DIO);
char RecievedChar;
String ReceivedString = "";
String Subs[SPLITTERS];
int SplitIndex[SPLITTERS];
bool Command = false;
int ConsigneLeds = 254;


//**********************************************************************
void setup()
{
  Serial.begin(115200);
  DriveLeds(0);
}
//**********************************************************************
void loop()
{
  if (Command)
  {
    if (Subs[0] == "Mirror")
    {
      ConsigneLeds = Subs[1].toInt();
      Command = false;
    }
  }
  DriveLeds(ConsigneLeds);
}
//**********************************************************************
void DriveLeds(unsigned int value)
{
  Driver.begin();
  Driver.SetColor(value, value, value);
  Driver.end();
}
//**********************************************************************
void Flush()
{
  while (Serial.available())
  {
    RecievedChar = Serial.read();
  }
}
//**********************************************************************
void serialEvent()
{
  while (Serial.available())
  {
    RecievedChar = Serial.read();
    if (RecievedChar == CR)
    {
      Serial.print("ReceivedString: ");
      Serial.println(ReceivedString);
      String_Split(SPLIT);
      Command = true;
      Flush();
    }
    else ReceivedString += RecievedChar;
  }
}
//**********************************************************************
void String_Split(char Splitter)
{
  int i;
  int Index = 0;
  int Nsubs;
  for (i = 0; i < SPLITTERS; i++)
  {
    SplitIndex[i] = ReceivedString.indexOf(Splitter, Index);
    Index = SplitIndex[i] + 1;
    if (!Index) break;
  }
  Nsubs = i + 1;
  Index = -1;
  for (i = 0; i < Nsubs; i++)
  {
    Subs[i] =  ReceivedString.substring(Index + 1, SplitIndex[i]);
    Serial.print("Sub ");
    Serial.print(i);
    Serial.print(": ");
    Serial.println(Subs[i]);
    Index = SplitIndex[i];
  }
  for (i = 0; i < Nsubs; i++)
  {
    Serial.print("Int ");
    Serial.print(i);
    Serial.print("= ");
    Serial.println(Subs[i].toInt());
  }
  ReceivedString = "";
  for (i = 0; i < SPLITTERS; i++)
  {
    SplitIndex[i] = -1;
  }
}


