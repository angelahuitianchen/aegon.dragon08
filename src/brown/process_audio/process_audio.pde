import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

Minim minim;
AudioPlayer audio;
FFT fft;
PrintWriter writer;

void setup(){
  frameRate(30);
  writer = createWriter("fft.txt");
  minim = new Minim(this);
 
  audio = minim.loadFile("audio.mp3", 512);
  audio.play();
  fft = new FFT(audio.bufferSize(), audio.sampleRate());  
  
}

void draw(){
  fft.forward(audio.mix);
  String out = frameCount+":";
  for(int i = 0; i < fft.specSize(); i++){
    out+=(int)(fft.getBand(i)*10)+" ";  
    //println(fft.getBand(i));
  }
  writer.println(out);
  if(!audio.isPlaying()){
    bye();
  }  
  
}

void mousePressed(){
  bye();
}

void bye(){
  writer.flush();
  writer.close();
  audio.close();
  minim.stop();
  exit();
  
}


