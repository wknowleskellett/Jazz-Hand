int FSRPIN[] = {A0, A1, A2, A3, A4};
int fsrReadings[5];


void setup() {
  // Prepare to send readings to the computer over USB
  Serial.begin(9600);
}

void loop() {
  // Iterate over each finger and output voltage readings, tab separated
  for (int i=0; i < 5; i++) {
    fsrReadings[i] = analogRead(FSRPIN[i]);
    Serial.print(fsrReadings[i]);
    Serial.print('\t');
  }
  // Flush and prepare to send new data
  Serial.println();
  delay(100);
}
