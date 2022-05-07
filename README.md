# Jazz-Hand
## Project Description

The Jazz Hand is a musical glove that allows someone to play music by tapping their fingers on any hard surface.

The glove has pressure sensors sewn into the fingertips. The thumb and pinky each trigger octave changes lower and higher, respectively. The three fingers between them play the notes of a major C chord in the currently selected octave.

Due to limitations imposed by the Arduino's frequency generation hardware, it is not possible to generate multiple tones on the device as required by this project. For this reason, the Arduino is utilized only as a medium for reading pressure data. It feeds raw data into the computer, which determines which tones to play, and outputs them on its own speakers.

The computer runs a Processing program to interpret the instructions of the musician. As such, replacing or editing the Processing program has the full potential to completely change the instrument. We generate flat tones, but it is possible to introduce tamber, or to map any finger to a new functionality.

This project was intended to use two gloves, for a total of ten pressure sensors. Of these, two could have been designated for changing the octave, and the other eight would have been able to play any chord on a major scale. When our institution determined to evacuate campus due to COVID-19, we split the project materials among ourselves and constructed individual gloves at our respective residences.

## Directory Structure
### Final Code
`Read Fingies` contains the code to run on the arduino and a diagram of the required circuit to connect a single pressure sensor to the Arduino.

`tones` contains the code to run on Processing while the arduino is connected to the computer via USB.

### Vestigial
`serial input` contains arduino code to verify the measurements read from the resistance-based pressure sensor.
