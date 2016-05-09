import processing.opengl.*;
import javax.media.opengl.*;

final boolean SAVEFRAME = true;
final int STOPFRAME = 20000;

int circleNum = 300;

PGraphicsOpenGL pgl;
GL gl;
PImage blur;

PrintWriter out;
BufferedReader reader;

ArrayList pinchos;
ArrayList pinchosp;

int color1 = 50;
int color2 = 150;
color basicColor = color(255, 0, 0);

int [] clrs = {
              color(255, 0, 0),    //red
              color(0, 255, 0),    //green
              color(0, 0, 255),    //blue
              color(255, 0, 255),  //magenta
              color(255, 255, 0),  //yellow
              color(0, 255, 255),  //cyan
              color(128, 0, 128)   //purple
              };

int [] typeColor = {
                    color(255, 0, 0),  //AQI
                    color(0, 255, 0),  //PM2.5
                    color(0, 0, 255),  //PM10
                    color(255, 0, 255),  //O3
                    color(255, 255, 0),  //SO2
                    color(0, 255, 255),  //CO
                    color(128, 0, 128),  //NO2
                    color(0, 128, 0)   //TEMP
                    };
int [] typeRange = {0,   
                    3,  //AQI
                    83,  //PM2.5
                    86,  //PM10
                    89,  //O3
                    92,  //SO2
                    95,  //CO
                    97,  //SO2
                    100  //TEMP
                    };
                    
int getColorOfAQI(int aqi) { 
  //(
  return color(0, 0, 255); 
}
int getColorOfPM25(int pm25) { 
  int clr = 0; 
  if (pm25 < 60) {
    clr = color(54, 246, 45);
  } else if (pm25 < 120) {
    clr = color(254, 249, 51);
  } else if (pm25 < 199) {
    clr = color(248, 42, 25);
  } else if (pm25 < 399) {
    clr = color(123, 34, 131);
  } else {
    clr = color(96, 52, 6);
  }
  return clr;
}
int getColorOfPM10(int pm10) { return color(0, 0, 255); }
int getColorOfO3(int o3) { return color(255, 255, 0); }
int getColorOfSO2(int so2) { return color(255, 0, 255); }
int getColorOfCO(int co) { return color(0, 255, 255); }
int getColorOfNO2(int no2) { return color(128, 0, 128); }
int getColorOfTEMP(int temp) { return color(0, 128, 128); }

int aqi = 0;
int pm25 = 0;
int pm10 = 0;
int o3 = 0;
int so2 = 0;
int co = 0;
int no2 = 0;
int temp = 0;

void updateColor() {
  String city = (getShowCity());
  Weather we = getWeaher(city);
  
  typeColor[0] = getColorOfAQI(we.get_pm25());
  typeColor[1] = getColorOfPM25(we.get_pm25());
  typeColor[2] = getColorOfPM10(pm10);
  typeColor[3] = getColorOfO3(o3);
  typeColor[4] = getColorOfSO2(so2);
  typeColor[5] = getColorOfCO(co);
  typeColor[6] = getColorOfNO2(no2);
  typeColor[7] = getColorOfTEMP(temp);
}
                    
int getColor() {
  int rnd = (int)random(100);
  for (int i=0; i!=typeRange.length -1; ++i){
    if (rnd >= typeRange[i] && rnd < typeRange[i+1]) {
      return typeColor[i];
    }
  }
  return color(255, 0, 0);
}

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

Color clr = new Color(255, 0, 0);

void draw(){
  if (second() % 5 == 0) {
    thread("updateColor");
  }
  
  /*int reminder = minute() * 60 + second();
  reminder = reminder % 120;
  reminder = (second() / 20) % 6;
  int index = reminder % clrs.length;
  //basicColor = clrs[index];*/
  basicColor = getColor();
  //basicColor = color(clr.r, clr.g, clr.b);
  
  
  
  
  
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
  String line = null;
  
  try {
    line = reader.readLine();
  } catch (IOException e) {
    e.printStackTrace();
    //line = null;
    try {
    reader = createReader("fft.txt");
    line = reader.readLine();
    if (line == null) {
      println("read again failed");
      flush();
      noLoop();
      exit();
    }
    } catch(IOException e1) {      println("read again failed");flush();
      }
  }
  if (line == null) {
    try {
    reader = createReader("fft.txt");
    line = reader.readLine();
    println(line);
    } catch(IOException e1) {
      println("read again failed.");
      flush();
    }
    noLoop();
  }
  
  //println(line);
  if (line != null) {
    println("have lines");
    
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
   
  } else {
    println("line is null");
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
  //if(SAVEFRAME)
  //  saveFrame("rendering/brown-####.png");
  println(frameCount+" "+pinchos.size());
  /*if(frameCount>=STOPFRAME){
   exit(); 
  }*/
}
