import processing.serial.*;
import processing.sound.*;

Serial myPort;
String val;

int[] lastPressures;
SinOsc[] notes;
float[] freqs;
Sound s;

void setup()
{
  size(200,200);
  
  lastPressures = new int[]{0,0,0,0,0};
  notes = new SinOsc[3];
  freqs = new float[]{261.626,329.628,391.995};
  for (int i=0; i < notes.length; i++) {
     notes[i] = new SinOsc(this);
     notes[i].freq(freqs[i]);
  }
  
  s = new Sound(this);
  
  String portName = Serial.list()[1];
  myPort = new Serial(this, portName, 9600);
  myPort.clear();
  myPort.readStringUntil('\n');
}

void draw()
{
  if ( myPort.available() > 0) {
    val = myPort.readStringUntil('\n');         // read it and store it in val
    if (val != null) {
      String[] splitted = val.split("\t");
      int[] splitInts = new int[5];
      for (int i=0; i<5; i++) {
        splitInts[i] = Integer.parseInt(splitted[i]);
        print(splitInts[i] + "\t");
      }
      processKeys(splitInts);
      println();
    }
  }
}

void processKeys(int[] pressures) {
  int intervalChange = 0;
  if (lastPressures[0] == 0 && pressures[0] > 0) {
    intervalChange -= 1;
  }
  if (lastPressures[4] == 0 && pressures[4] > 0) {
    intervalChange += 1;
  }
  adjustInterval(intervalChange);
  
  for (int i=0; i < 3; i++) {
    if (pressures[i+1] > 0) {
      notes[i].amp(pressures[i+1]/1000.0);
      if (lastPressures[i+1] == 0) {
        notes[i].play();
      }
    } else if (lastPressures[i+1] > 0) {
      notes[i].stop();
    }
  }
  
  lastPressures = pressures;
}

void adjustInterval(int amount) {
  if (amount == 0) {
    return;
  }
  for (int i=0; i < 3; i++) {
    freqs[i] *= pow(2, amount);
     notes[i].freq(freqs[i]);
  }
}
