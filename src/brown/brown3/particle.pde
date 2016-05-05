class Pinchop{
  
  final int step;
  int life;
  
  final int diaminit;
  final float decay;
  
  int x=width/2;
  int y=height/2;
  int z = 0;

  final color cor;
  ArrayList pinchost;
  ArrayList pinchitost;
  
  Pinchop(ArrayList pinchost, int life, int step, float dispersion, int diaminit){
    pinchitost = new ArrayList();
    this.pinchost = pinchost;
    pinchost.add(this);
    this.life = life;
    this.step = step;
    this.diaminit = diaminit;
    this.decay = 0.05;
    PVector vec = new PVector(random(-1,1),random(-1,1),random(-1,1));
    vec.normalize();
    vec.mult(dispersion);
    x += vec.x;
    y += vec.y;
    z += vec.z;
    
    cor = color(random(0,255),random(0,255),random(0,255));  
  }
  
  void update(){
    if(pinchitost.size()==0){
      pinchost.remove(this);  
    }  
  }
  
  void draw(){
    //fill(cor);
    
    if(life>=0){
      new Pinchito(x,y,z,pinchitost, cor, diaminit, decay);
      x = x + (int)random(-step,step); 
      y = y + (int)random(-step,step);
      z = z + (int)random(-step,step);
      //z = 0;
      life--;
    }
    
    for(int i=0;i<pinchitost.size();i++){
      Pinchito pin = (Pinchito)pinchitost.get(i);
      pin.draw();  
    }
      
    
    
    
  }
}
