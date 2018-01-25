//http://wiki.seeed.cc/PIR_Motion_Sensor_Large_Lens_version/

//#define DEBUG

//attention! nécessite une capa découplage sur alim (essais OK avec 1000uF)
#include <Ultrasonic.h>
#define MICROPHONE A4
#define FILTER_LENGHT 5
#define SEUIL_US 120
#define MAX_US 150
#define PIR_MOTION_SENSOR 2
#define SEUIL_IR 70
#define DEBOUNCE_MAX 10

Ultrasonic ultrasonic(7);
bool PirMotion = false;
int SoundLevelValue, SoundLevelAverage;
int Filter[FILTER_LENGHT];
void setup()
{
  pinMode(PIR_MOTION_SENSOR, INPUT);
  Serial.begin(115200);
  FilterInit();
}
void loop()
{
  int val;
  static int valFiltree;
  static int FiltreUs = 0;
  int IRa, IRb, IRc;
  bool bIRa,bIRb,bIRc;
  static int DebounceIRa = 0;
  static int DebounceIRb = 0;
  static int DebounceIRc = 0;
  //PirMotion = digitalRead(PIR_MOTION_SENSOR);

  IRa = analogRead(A1);
  IRb = analogRead(A2);
  IRc = analogRead(A3);

  if (IRa > SEUIL_IR)
  {
    if (DebounceIRa < DEBOUNCE_MAX)DebounceIRa++;
  }
  else
  {
    if (DebounceIRa > 0) DebounceIRa--;
  }
  if (IRb > SEUIL_IR)
  {
    if (DebounceIRb < DEBOUNCE_MAX)DebounceIRb++;
  }
  else
  {
    if (DebounceIRb > 0) DebounceIRb--;
  }
  if (IRc > SEUIL_IR)
  {
    if (DebounceIRc < DEBOUNCE_MAX)DebounceIRc++;
  }
  else
  {
    if (DebounceIRc > 0) DebounceIRc--;
  }

  if(DebounceIRa == DEBOUNCE_MAX)bIRa=true;
  else bIRa=false;
   if(DebounceIRb == DEBOUNCE_MAX)bIRb=true;
  else bIRb=false;
   if(DebounceIRc == DEBOUNCE_MAX)bIRc=true;
  else bIRc=false;
  
  val = ultrasonic.MeasureInCentimeters();
  if (val > MAX_US) val = MAX_US;
  if (val <= SEUIL_US)
  {
    FiltreUs++;
    if (FiltreUs > 10)
    {
      FiltreUs = 10;
      valFiltree = val;
    }
  }
  else
  {
    FiltreUs--;
    if (FiltreUs < 0)
    {
      FiltreUs = 0;
      valFiltree = 0;
      //if(valFiltree>0) valFiltree--;
    }
  }

SoundLevelValue = Soundlevel();
  SoundLevelAverage = Filtering(SoundLevelValue);

#ifdef DEBUG
  Serial.print(0);
  Serial.print(" ");
  Serial.print(MAX_US);
  Serial.print(" ");
  //Serial.print(valFiltree);
  Serial.print(" ");
  //Serial.print(FiltreUs);
  Serial.print(" ");
  Serial.print(DebounceIRa);
  Serial.print(" ");
  Serial.print(DebounceIRb);
  Serial.print(" ");
  Serial.print(DebounceIRc);
  //if (PirMotion) Serial.print(40);
  //else Serial.print(10);
  Serial.print(" ");
  Serial.print(SoundLevelAverage);
  Serial.println();
#else
  //Serial.print("PIR=");
  //Serial.print(PirMotion);
  Serial.print("IRa=");
  Serial.print(bIRa);
   Serial.print(",IRb=");
  Serial.print(bIRb);
   Serial.print(",IRc=");
  Serial.print(bIRc);
  Serial.print(",US=");
  if (valFiltree < 100) Serial.print("0");
  if (valFiltree < 10) Serial.print("0");
  Serial.print(valFiltree);
  Serial.print(",Sound=");
   if (SoundLevelAverage< 100) Serial.print("0");
  if (SoundLevelAverage < 10) Serial.print("0");
  Serial.print(SoundLevelAverage);
  Serial.println();
#endif 

  delay(50);
}

//**************************************************************
int Soundlevel()
{
  const int sampleWindow = 50; // Sample window width in mS (50 mS = 20Hz)
  unsigned int sample;
  unsigned long startMillis = millis(); // Start of sample window
  unsigned int peakToPeak = 0;   // peak-to-peak level

  unsigned int signalMax = 0;
  unsigned int signalMin = 1024;

  // collect data for 50 mS
  while (millis() - startMillis < sampleWindow)
  {
    sample = analogRead(MICROPHONE);
    if (sample < 1024)  // toss out spurious readings
    {
      if (sample > signalMax)
      {
        signalMax = sample;  // save just the max levels
      }
      else if (sample < signalMin)
      {
        signalMin = sample;  // save just the min levels
      }
    }
  }
  peakToPeak = signalMax - signalMin;  // max - min = peak-peak amplitude
  double volts = (peakToPeak * 10.0) / 1024;  // convert to volts
  return ((int)(volts * 100));
}

//**************************************************
void FilterInit()
{
  for (int i = 0; i < FILTER_LENGHT; i++)
  {
    Filter[i] = 0;
  }
}

int Filtering(int Value)
{
  static int Index = 0;
  long Sum;

  Filter[Index] = Value;
  Index++;
  if (Index == FILTER_LENGHT) Index = 0;
  Sum = 0;
  for (int i = 0; i < FILTER_LENGHT; i++)
  {
    Sum += Filter[i];
  }
  Sum = Sum / FILTER_LENGHT;
  return ((int)Sum);
}

