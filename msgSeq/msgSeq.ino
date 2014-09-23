#include <Process.h>


String instruments[] = {"PS", "BD", "SD","KI","SN","CR"};
//PS: play sample, BD: bass drum, SD: snare, KI: kick,SN: snare, CR: crash
const int numIns = 6;
byte patterns[numIns-1];
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
      if (patterns[i-1] & bs[pos])
        Serial.print(instruments[i]);
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
  int instrument = 0;
  String s = msg.substring(hashInd + 1, hashInd + 3);
  for (int i = 0; i < numIns; i++) {
    if (s == instruments[i]) {
      instrument = i;
      Serial.println(s);
      break;
    }
  }
  if (instrument == 0)
    playSample(msg.substring(hashInd + 4));
  else {
    instrument--;
    // pattern
    String pa = msg.substring(hashInd + 4, hashInd + 4 + patternL);
    byte pattern = 0;
    Serial.println(pa);
    for (int i = 0; i < patternL; i++) {
      pattern = pattern << 1;
      byte b = pa.charAt(i) == '1' ? 1 : 0;
      pattern += b;
    }
    Serial.println(pattern);
    patterns[instrument] = pattern;
  }
}

void playSample(String msg) {
  Process p;
  p.runShellCommandAsynchronously("madplay "+sampleFolder+msg);
}
