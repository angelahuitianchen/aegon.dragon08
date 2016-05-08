class Pinchito{
  
  final int diam;
  final float lifedec;

  int lifec;
  final int x, y, z;
  ArrayList pinchitos;
  color cor;
  float cr, cb, cg;
  
  //在x,y,z出产生小圆圈,初始化大小为diam, 逐渐减少量为：lifedec
  Pinchito(int x, int y, int z, ArrayList pinchitos, color cor, int diam, float lifedec){
    this.x = x;
    this.y = y;
    this.z = z;
    this.pinchitos = pinchitos;
    this.cor = cor;
    this.diam = diam;
    this.lifedec = lifedec;
    pinchitos.add(this);
    lifec = diam;
    cr = 255;
    cb = blue(cor);
    cg = green(cor);
  }

  void draw(){
    //fill(cr, cg, cb );
    pushMatrix();
    translate(x-width/2, y-height/2, z);
    rotateY(-rotating);
    tint(cr, cg, cb);
    //image(blur, 0, 0, lifec, lifec);
    //ellipse(0, 0, lifec, lifec);
    popMatrix();
    lifec-=lifedec;
    if(lifec <= 0){
      pinchitos.remove(this);  
    }
  }  
}
