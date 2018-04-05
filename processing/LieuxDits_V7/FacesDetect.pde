void FacesDetect()
{
  if (video.available() == true) 
  {
    opencv.loadImage(video);
    faces = opencv.detect();
    FlagFaces=true;
    video.read();
  }

  if (FlagFaces)
  {
    imageMode(CORNER);
    image(video, 0, 0 );
    ActiveGuys=0;
    for (int i = 0; i < Nguys; i++) 
    {
      if (faces.length >i) 
      {
         Guys[i].Compute(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
       
        noFill(); 
        strokeWeight(1);
        stroke(255, 255, 255);
        rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
      } 
      else Guys[i].Decrease();
      if (Guys[i].Alive) ActiveGuys++;
    }
  }

  //print(ActiveGuys);
  //print("|");
  //println(frameRate);
}