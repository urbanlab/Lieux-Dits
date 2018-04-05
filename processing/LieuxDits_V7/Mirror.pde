//********************************************
void Mirror()
{
  if (MirrorOn && !FlagMirrorOff)
  {
    if (MirrorCurrentValue > MirrorMin) MirrorCurrentValue -=MirrorStep;
  } 
  else
  {
    if (MirrorCurrentValue < MirrorMax) MirrorCurrentValue +=MirrorStep;
  }
  if (MirrorCurrentValue < MirrorMin) MirrorCurrentValue=MirrorMin;
  if (MirrorCurrentValue > MirrorMax) MirrorCurrentValue=MirrorMax;
  MirrorSend(MirrorCurrentValue);
}
//****************************************************
void MirrorSend(int Consigne)
{
  String MirrorCmd;
  MirrorCmd="Mirror,"+Consigne+"\r";
  MirrorPort.write(MirrorCmd);
}