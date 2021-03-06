/*
Sketch for the Twitter Orchestra Workshop Retune14.
 Libraries you need:
 twitter4j, themidibus
 
 The midibus sends midi notes to a virtual midi-channel
 called "java-ableton" (created with an app called midiLoop)
 and received by ableton. (the Ableton project is also in github)
 Just playing samples would also be doable with minim or something similar
 */

import twitter4j.*;

import processing.serial.*; 
import themidibus.*;

// Incoming msg from Serial connection (a connected Yun...)
boolean useSerial = false;
// serial port to use
int serialIndex = 0;
Serial serial;    // The serial port

MidiBus myBus; // The MidiBus
String midiChannel = "java-ableton";

// use the twitter stream with twitter4j
boolean twitterStream = true;

// delay between twitter calls
final int timelineDelay = 61000;
long nextTimeLine = timelineDelay;

// play-delay between messages 
long nextMsgBufferGet = 0;
final int msgBufferDelay = 5000;

// print all kinds of messages for debubbing
boolean AllMsgs = false;

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
  if (twitterStream) 
    twitterInit();
}

void draw() {
  background(0);
  text("BPM: "+bpm, 30, 50);
  // process messages in the buffer
  long time = millis();
  if (time > nextMsgBufferGet) {
    nextMsgBufferGet += msgBufferDelay; 
    if (msgBuffer.size()>0) {
      String msg = msgBuffer.get(msgBuffer.size()-1);
      parseMessage(msg);
      msgBuffer.remove(msgBuffer.size()-1);
      println("buffered msges left: "+msgBuffer.size());
    }
  }
  text("buffer next: "+ (nextMsgBufferGet-time) + " / size: "+msgBuffer.size(), 30, 150);
  // process drum sequecer
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
  // process twitter calls
  if (time > nextTimeLine) { 
    getTimeline();    
    nextTimeLine+= timelineDelay;
  }
  text("nextTwitterUpdate: "+ (nextTimeLine- time), 30, 180);
  // teststuff
  if (cimp) {
    text(cimpS, 30, 100);
  }
}

void serialEvent(Serial p) { 
  if (!useSerial)
    return;
  String msg = p.readString();
  msg = msg.trim();
  serialEvent(msg);
} 

void serialEvent(String msg) { 
  if (AllMsgs)
    println("--Incoming: "+msg);
  if (msg.length()==0)
    return;
  /*  if (msg.charAt(0)!='>') {
   println("to_not interesting: "+msg);
   return;
   }  */
  try {
    if (checkUseable(msg)) {
      msgBuffer.add(msg);
      println("to_buffering: "+msg);
    } else {
      if (AllMsgs)
        println("msg not accepted: "+msg);
    }
  } 
  catch (Exception e) {
    serialEvent(msg);
  }
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

boolean checkUseable(String msg) {
  if (checkLastMsgs) 
    if (!checkMsgBuffer(msg)) {
      println("Message already proccesed recently");
      return false;
    } 
  int hashInd = msg.indexOf('#');
  if (hashInd == -1 || msg.length() < hashInd+3) {
    if (AllMsgs)
      println("msg to short or no hashtag: "+msg);
    return false;
  }
  String s = msg.substring(hashInd + 1, hashInd + 3);
  s = s.toUpperCase();
  for (int i = 0; i < numIns; i++) {
    if (s.equals(hashTags[i])) {
      println("found tag: "+hashTags[i]);
      return true;
    }
  }
  return false;
}

