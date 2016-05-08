class Pincho{
  
  final int step;
  final int range;
  int life = 50;
  
  float x=width/2;
  float y=height/2;
  float z = 0;

  final color cor;
  float[][] points;
  
  int transp;
  
  //初始化range个点，这些点的范围基于窗体的中心，然后在-step和+step之间
  Pincho(int range, int step){
    this.range = range;
    this.step = step;
    points = new float[range][3];
    for(int i = 0;i<range;i++){
      x = x + random(-step,step); 
      y = y + random(-step,step);
      z = z + random(-step,step);
      points[i][0]=x;
      points[i][1]=y;
      points[i][2]=z;
    }
    transp = (int)random(0,100);
    //cor = color(random(200,255),random(0,200),random(0,100));  
    //cor = color(200,200,200);  
    cor = basicColor;  
}
  
  boolean fadein = true;
  boolean fadeout = false;
  boolean die = false;
  
  int transi = 0;
  
  void draw(){
    life--;
    if(life<=0){
      fadeout = true; 
    }
    
    if(fadein){
      transi+=7;
      if(transi>transp)
        fadein = false;
    }
    
    if(fadeout){
      fadein = false;
      transi-=7;
      if(transi<=0){
        fadeout=false;
        die = true;
        return; 
      }
          
    }
    
    //设置边框
    stroke(cor, transi);
    //保留上次视图
    pushMatrix();
    //平移上次视图
    translate(-width/2, -height/2, 0);
    //画折线
    beginShape();
    //println("length: " + points.length);
    for(int i = 0;i<points.length;i++){   
      x = points[i][0]; 
      y = points[i][1]; 
      z = points[i][2]; 
      //vertex(x,y,z);
    }
    endShape();
    popMatrix();
    
  }
  
  boolean isAlive(){
    return !die;  
  }
}
