import processing.opengl.*;
import javax.media.opengl.*;

final boolean SAVEFRAME = true;
final int STOPFRAME = 697;

int circleNum = 300;

PGraphicsOpenGL pgl;
GL gl;
PImage blur;

PrintWriter out;
BufferedReader reader;

ArrayList pinchos;
ArrayList pinchosp;

void setup(){
  size(192, 192, OPENGL);
  hint(ENABLE_OPENGL_4X_SMOOTH);
  
  reader = createReader("fft.txt");

  background(0);
  noStroke();
  noSmooth();
  frameRate(150);
  blur = loadImage("glow_orb_solid.png");
  imageMode(CENTER);
  pinchos = new ArrayList();
  pinchosp = new ArrayList();
  
  //advance reader pointer if needed
  int startline = 0;
  for(int i=0;i<startline;i++){
    try {
      reader.readLine();
    } catch (IOException e) {
      e.printStackTrace();
    }  
  }
}

float rotating = 0;

void draw(){
  background(0);
  pgl = (PGraphicsOpenGL) g;
  gl = pgl.beginGL();
  gl.glDisable(GL.GL_DEPTH_TEST);
  pgl.endGL();

  background(0);
  
  //一直旋转坐标轴
  pushMatrix();
  translate(width/2, height/2);
  rotateY(rotating);
  rotating+=0.02;
  if(rotating >= TWO_PI){
    rotating = 0;  
  }
  String line;
  
  try {
    line = reader.readLine();
  } catch (IOException e) {
    e.printStackTrace();
    line = null;
  }
  //println(line);
  if (line != null) {
    
    String[] bandas = split(split(line, ":")[1], " ");
   
    float media = 0;
    for(int i = 0; i < bandas.length; i++){
      if(!bandas[i].equals(" ") && !bandas[i].equals("")){
        media +=float(bandas[i]);
        //println(bandas[i]);
      }
    }
    
    media = media/bandas.length;
    
    for(int i = 0; i < bandas.length; i++){
      if(!bandas[i].equals(" ") && !bandas[i].equals("")){
        float energy = float(bandas[i]);
        if(energy >= 0){
          //生命15次，范围3， 分散程度，
          if (pinchosp.size() < circleNum)
          new Pinchop(pinchosp, 15, 3, media*10, (int)(energy/10));   
          println("pinchosp: " + pinchosp.size());
        }
        if(energy >= 0){
          //energy = energy * 100;
          int f = (int)(energy+media*media*media);
          if (pinchosp.size() < circleNum){

          Pincho pincho = new Pincho(f, 3);
          if(pinchos.size()<media*7 && pinchos.size() < 10){
            pinchos.add(pincho);  
          }
          }
        }
      }
    }
   
  }
  noFill();
  for(int i=0;i<pinchos.size();i++){
    Pincho pin = (Pincho)pinchos.get(i);
    if(pin.isAlive()){
      /*pin.draw();*/
    }else{
      pinchos.remove(pin);  
    }  
  }
  
  for(int i=0;i<pinchos.size();i++){
    Pincho pin = (Pincho)pinchos.get(i);
    if(pin.isAlive()){
      pin.draw();
    }  
  }
  
  
  gl = pgl.beginGL();
  gl.glDisable(GL.GL_DEPTH_TEST);
  gl.glEnable(GL.GL_BLEND);
  gl.glBlendFunc( GL.GL_SRC_ALPHA,GL.GL_ONE );
  pgl.endGL();
  fill(0);
  
  for(int i=0;i<pinchosp.size();i++){
    Pinchop pinchop = (Pinchop)pinchosp.get(i);
    pinchop.draw();
  }
  for(int i=0;i<pinchosp.size();i++){
    Pinchop pinchop = (Pinchop)pinchosp.get(i);
    pinchop.update();  
  }
  popMatrix();
  if(SAVEFRAME)
    saveFrame("rendering/brown-####.png");
  println(frameCount+" "+pinchos.size());
  if(frameCount>=STOPFRAME){
   exit(); 
  }
}
