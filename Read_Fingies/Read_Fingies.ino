int FSRPIN[] = {A0, A1, A2, A3, A4};
int fsrReadings[5];


void setup() {
  // put your setup code here, to run once:
  //pinMode(13, INPUT);
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
//  int readValue = digitalRead(13);
//  digitalWrite(8, 1-readValue);
//  Serial.println(readValue);
  for (int i=0; i < 5; i++) {
    fsrReadings[i] = analogRead(FSRPIN[i]);
    Serial.print(fsrReadings[i]);
    Serial.print('\t');
  }
  Serial.println();
  delay(100);
}
