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
  
  // The length of 'notes' is related to the amount of fingers
  // that play a note
  // With one glove, 3. With two gloves, 8.
  notes = new SinOsc[3];
  
  // The frequencies of a C major chord in Middle C
  freqs = new float[]{261.626,329.628,391.995};
  
  for (int i=0; i < notes.length; i++) {
     notes[i] = new SinOsc(this);
     notes[i].freq(freqs[i]);
  }
  
  s = new Sound(this);
  
  // We found by experimentation that the arduino was consistently listed at
  // index 1.
  // A future way to detect the glove automatically would be to edit the Arduino code
  // to listen for a manually implemented handshake before beginning its data read cycle.
  String portName = Serial.list()[1];
  
  // With two gloves, it would be most convenient to have one Arduino on each glove,
  // and configure a second Serial connection here.
  myPort = new Serial(this, portName, 9600);
  
  // Initial flush
  myPort.clear();
  myPort.readStringUntil('\n');
}

void draw()
{
  if ( myPort.available() > 0) {
    // Read in 5 voltage levels, tab separated
    val = myPort.readStringUntil('\n');
    if (val != null) {
      String[] splitted = val.split("\t");
      
      // Initialize a new array every time, since lastPressures will be redirected to point at this array.
      int[] splitInts = new int[5];
      for (int i=0; i<5; i++) {
        splitInts[i] = Integer.parseInt(splitted[i]);
        print(splitInts[i] + "\t");
      }
      println();
      
      processKeys(splitInts);
      lastPressures = pressures;
    }
  }
}

// The processKeys method holds all the power.
// Reimplementations of this method can do anything they'd like
// with the voltage data per finger read directly from the device.
void processKeys(int[] pressures) {
  int intervalChange = 0;
  // If the thumb was just pressed, lower our octave.
  if (lastPressures[0] == 0 && pressures[0] > 0) {
    intervalChange -= 1;
  }
  // If the pinky was just pressed, raise our octave.
  if (lastPressures[4] == 0 && pressures[4] > 0) {
    intervalChange += 1;
  }
  adjustInterval(intervalChange);
  
  // Trigger changes to notes per-finger.
  for (int i=0; i < 3; i++) {
    if (pressures[i+1] > 0) {
      // Update the volume of the respective finger's note based on pressure.
      notes[i].amp(pressures[i+1]/1000.0);
      if (lastPressures[i+1] == 0) {
        notes[i].play();
      }
    } else if (lastPressures[i+1] > 0) { // If pressure just ceased,
      notes[i].stop();
    }
  }
}

void adjustInterval(int amount) {
  if (amount == 0) {
    return;
  }
  for (int i=0; i < 3; i++) {
    freqs[i] *= pow(2, amount);
    
    // Update the octave of the respective finger's note.
    notes[i].freq(freqs[i]);
  }
}
