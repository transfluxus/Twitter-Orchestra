import processing.serial.*; 
import themidibus.*;

boolean useSerial = false;
int serialIndex = 0;
Serial serial;    // The serial port

MidiBus myBus; // The MidiBus
String midiChannel = "java-ableton";

void setup() {
  size(600, 200);
  if (useSerial) {
    serial = new Serial(this, Serial.list()[serialIndex], 9600); 
    serial.bufferUntil('\n');
  }
  //   myBus.list();
  myBus = new MidiBus(this, -1, midiChannel);
  for (int i=0; i < 8; i++) {
    instrument_seq[0][i] = -1;
    instrument_seq[1][i] = -1;
  }
  nextBInc = (int)(MINUTE / bpm);
}

void draw() {
  background(0);
  text("BPM: "+bpm, 30, 50);
  long time = millis();
  if (time > nextB) {
    nextB += nextBInc;
    // play drums
    for (int i = DRUMSSTART; i <= DRUMSEND; i++) {
      if ((patterns[i - 1] & bs[pos]) != 0)
        playDrum(i);
    }
    // play instruments
    playNote(0, instrument_seq[0][pos]);
    playNote(1, instrument_seq[1][pos]);
    pos = (pos + 1) % patternL;
  }
  if (cimp) {
    text(cimpS, 30, 100);
  }
}

void serialEvent(Serial p) { 
  String msg = p.readString();
  msg = msg.trim();
  parseMessage(msg);
//  while (!bufferFree);
//    msgBuffer.add(msg);
} 

void keyPressed() {
  //  println(keyCode);
  if (cimp) {
    addCIMP( keyCode - 48);
  }
  if (mousePressed && mouseButton==RIGHT) 
    sendDefaultTest(keyCode - 48);
  if (key=='m') {
    initCtrlMapSend();
  }  
  if (key==ENTER)
    sendCtrlMapSend();
}

void exit() {
  myBus.sendNoteOff(1, notes[0], 120); 
  myBus.sendNoteOff(2, notes[1], 120);
  super.exit();
}

