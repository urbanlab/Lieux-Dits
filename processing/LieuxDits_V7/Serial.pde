import processing.serial.*;

Serial MirrorPort, SensorPort;
int lf = 10;    // Linefeed in ASCII
String SensorString = null;

void Connect() 
{
  printArray(Serial.list());

  MirrorPort = new Serial(this, Serial.list()[0], 115200); //sur COM1
  MirrorPort.clear();
  println("Connecting MirrorPort on " + Serial.list()[0]);

  SensorPort = new Serial(this, Serial.list()[1], 115200); //sur COM2
  SensorPort.clear();
  println("Connecting SensorPort on " + Serial.list()[1]);
}

void ReadSensorSerial()
{
  while (SensorPort.available() > 0) 
  {
    SensorString = SensorPort.readStringUntil(lf);
    if (SensorString != null)  
    {
      //print(SensorString);
      if (SensorString.length()==36)
      {
        SensorIRa=int(SensorString.substring(4, 5));
        SensorIRb=int(SensorString.substring(10, 11));
        SensorIRc=int(SensorString.substring(16, 17));
        SensorUS=int(SensorString.substring(21, 24));
        SensorSound=0;//int(SensorString.substring(31, 34));
      }
    }
  } 
}