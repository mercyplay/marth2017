  
import processing.sound.*;

AudioIn mic;
FFT fft;
AudioIn in;
int bands = 512;
float[] spectrum = new float[bands];

LowPass lowPass;
HighPass highPass;

color lineColor;

//Slider slider1;
//Slider slider2;

void setup() {
  size(1280, 720);
  background(255);
  smooth(4);
  
  // Load a soundfile from the /data folder of the sketch and play it back
  //file = new SoundFile(this, "/Users/alexanderfrenette/Dropbox/MARTH_RAF/github/marth2017/sound_testing/sample.mp3");
  //file = new SoundFile(this, "/Users/alexanderfrenette/Dropbox/MARTH_RAF/github/marth2017/sound_testing/Eminem - Rap God (Instrumental) Studio Quality.mp3");
  //file.play();
  
  mic = new AudioIn(this, 0);
  mic.play();


    
  // Create an Input stream which is routed into the Amplitude analyzer
  fft = new FFT(this, bands);
  in = new AudioIn(this, 1);
  
  // patch the AudioIn
  fft.input(mic);
  
  //// create LowPass() filter that will allow us to limit the lower frequencies
  //lowPass = new LowPass(this);    
  
  //// create highPass() filter that will allow us to limit the higher frequencies
  //highPass = new HighPass(this);

  //lowPass.process(in);
  //highPass.process(in);
  
  //lowPass.freq(10000);
  //highPass.freq(15000);
    
  // Slider
  //slider1 = new Slider(0, 8, width, 16, 1);
  //slider2 = new Slider(0, 32, width, 16, 1);
  
  /*
   * Testing : pan
   */
   //in.pan(1);
}      

void draw() { 
  background(255);
  
  // select the color
  lineColor = color(random(100, 255), random(100, 255), random(100, 255));
  stroke(lineColor);
  
  // used to find the total amplitudes of all of the frequencies
  float totalAmplitude = 0;
  
  fft.analyze(spectrum);

  for(int i = 0; i < bands; i++){
  totalAmplitude += spectrum[i];
    
  // The result of the FFT is normalized
  // draw the line for frequency band i scaling it up by 5 to get more amplitude.
  line( i, height, i, height - spectrum[i]*height*5 );
  //line( width - i, 0, i, height - spectrum[i]*height*5 );
  }
  
  int circleCenterX = width / 2;
  int circleCenterY = height / 2;
  
  float radius = totalAmplitude * 50;
  float circumfrence = 2.0 * PI * radius;
   //TODO : too small
  //float lineWidth = circumfrence / bands;
  float lineWidth = 3;
  float theta = 2.0 * (bands / 4.0);
  
  // create the lines around the circle
  pushMatrix();
  translate(circleCenterX, circleCenterY);
  
  for(int i = 0; i < (bands / 4.0); i++){
    //System.out.println(theta * bands);
    
    pushMatrix();
    rotate(theta * i);
            
    float lineLength = map(abs(spectrum[i] * 1000000.0), 0, 1000, 20, 50);
    
    if (lineLength < radius) {
      //System.out.println(radius);
      //System.out.println("LESS THAT");
      lineLength += random(0, radius);
    }
    
    if (lineLength >= width / 4.0) {
       System.out.println("LESS THAT");
       //lineLength = width / 2.0 - radius;
       lineLength = width / 4.0;
    }
      
    // The result of the FFT is normalized
    // draw the line for frequency band i scaling it up by 5 to get more amplitude
    
    stroke(0);
    strokeWeight(lineWidth * 2);
    line(0, 0, lineLength, 0);

    stroke(lineColor);
    strokeWeight(lineWidth);
    line(0, 0, lineLength, 0);
    
    // remove the rotate()
    popMatrix();
  }
  
  // remove the translate()
  popMatrix();
  
  // print out the sum of the amplitudes
  //System.out.println(totalAmplitude);
  // create the circle
  fill(0, 0, 149);
  ellipse((float) (width / 2), (float) (height / 2), radius, radius);
  
  // draw the sliders
  //slider1.update();
  //slider1.display();
  
  //slider2.update();
  //slider2.display();
  
  //int slider1Value = slider1.getValue();
  //int slider2Value = slider2.getValue();
}