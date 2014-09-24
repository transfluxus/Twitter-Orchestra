#include <Process.h>

String hashTags[] = {"PS", "BD", "SD", "KI", "SN", "CR", "I1", "I2"};
//PS: play sample, BD: bass drum, SD: snare, KI: kick,SN: snare, CR: crash
//I1: instrument 1, I2: instrument 2
// marker // TODO
const int DRUMSSTART = 1;
const int DRUMSEND = 5;
const int INSTRUMENTSTART = 6;
const int INSTRUMENTEND = 7;
const int EFFECTSTART = 8;
const int EFFECTEND = 10;
//
const int numIns = 6;
byte patterns[numIns - 1];
// length
const int patternL = 8;

const unsigned long MINUTE = 60000;
int bpm = 120;
// nextBeat
unsigned long nextB;
// time increase
int nextBInc;
// pos in the sequence
int pos;
// sequence-bits
int bs[] = {1, 2, 4, 8, 16, 32, 64, 128, 256};

int instrument_1_seq[8];
int instrument_2_seq[8];

const String sampleFolder = "/mnt/twitterOrchestra/samples/";

void setup() {
  Bridge.begin();
  Serial.begin(9600);
  while (!Serial);
  String msg = "#BD 10001000";
  parseMessage(msg);
  String msg2 = "#SD 01010101";
  parseMessage(msg2);
  String msg3 = "#KI 10001010";
  parseMessage(msg3);
  String msg4 = "#CR 01000000";
  parseMessage(msg4);

  nextBInc = MINUTE / bpm;
}

void loop() {
  unsigned long time = millis();
  if (time > nextB) {
    nextB += nextBInc;
    for (int i = 1; i < numIns; i++) {
      if (patterns[i - 1] & bs[pos])
        Serial.print(hashTags[i]);
      else
        Serial.print("..");
      Serial.print("-");
    }
    Serial.println("");
    pos = (pos + 1) % patternL;
  }
}

void parseMessage(String msg) {
  int hashInd = msg.indexOf('#');
  // instrument
  if (hashInd == -1)
    return;
  int tag = 0;
  String s = msg.substring(hashInd + 1, hashInd + 3);
  for (int i = 0; i < numIns; i++) {
    if (s == hashTags[i]) {
      tag = i;
      Serial.println(s);
      break;
    }
  }
  if (tag == 0)
    playSample(msg.substring(hashInd + 4));
  else if (tag >= DRUMSSTART && tag <= DRUMSEND) {
    String pa = msg.substring(hashInd + 4, hashInd + 4 + patternL);
    drums(tag - DRUMSSTART, pa);
  } else if (tag >= INSTRUMENTSTART && tag <= INSTRUMENTEND) {
    
  }
}

void playSample(String sampleName) {
  Process p;
  p.runShellCommandAsynchronously("madplay " + sampleFolder + sampleName + ".wav");
}

void playDrumSample(int tag) {

}

void drums(int tag, String patternS) {
  // pattern
  if (patternS.charAt(0) == 'p') {
    playDrumSample(tag);
    return;
  }
  byte pattern = 0;
  Serial.println(patternS);
  for (int i = 0; i < patternL; i++) {
    pattern = pattern << 1;
    byte b = patternS.charAt(i) == '1' ? 1 : 0;
    pattern += b;
  }
  Serial.println(pattern);
  patterns[tag] = pattern;
}
