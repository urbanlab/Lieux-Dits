import processing.serial.*;

Serial MirrorPort, SensorPort;
int lf = 10;    // Linefeed in ASCII
String SensorString = null;

public void Connect() 
{
  printArray(Serial.list());
      
      MirrorPort = new Serial(this, Serial.list()[0], 115200); //sur COM1
      MirrorPort.clear();
      println("Connecting MirrorPort on " + Serial.list()[0]);
      
      SensorPort = new Serial(this, Serial.list()[1], 115200); //sur COM2
      SensorPort.clear();
      println("Connecting SensorPort on " + Serial.list()[1]); 
}