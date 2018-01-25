public class Guy
{
  public int x,y,w,h;
  public boolean Alive;
  private int Flenght=20;
  private int SeuilAlive=20;
  private MovingAverage FilterX;
  private MovingAverage FilterY ;
  private MovingAverage FilterW;
  private MovingAverage FilterH ;
  
  public Guy()
  {
     FilterX = new MovingAverage(Flenght);
     FilterY = new MovingAverage(Flenght);
     FilterW = new MovingAverage(Flenght);
     FilterH = new MovingAverage(Flenght);
     Alive=false;
  }
  
  public void Decrease()
  {
    FilterW.pushValue(0);
    FilterH.pushValue(0);
    w=(int)FilterW.getValue();
    h=(int)FilterH.getValue();
    x=(int)FilterX.getValue();
    y=(int)FilterY.getValue();
    if(w<SeuilAlive) Alive=false;
    else 
    {
      Alive=true;
    fill(0,0,255, 90);
    noStroke();
    ellipse(x,y,w,h);
    }
    
  }

  public void Compute(int X, int Y, int W, int H)
  {
    FilterX.pushValue(X+0.5*W);
    FilterY.pushValue(Y+0.5*H);
    FilterW.pushValue(W);
    FilterH.pushValue(H);
    x=(int)FilterX.getValue();
    y=(int)FilterY.getValue();
    w=(int)FilterW.getValue();
    h=(int)FilterH.getValue();
    if(w<SeuilAlive) Alive=false;
    else 
    {
       Alive=true;
    fill(255,0,255, 90);
    noStroke();
    ellipse(x,y,w,h);
    }
     
  }
}