ArrayList<String> msgBuffer = new ArrayList<String>();

String hashTags[] = {
  "PS", "BD", "SD", "KI", "CB", "CR", "I1", "I2", "F1", "F2", "F3", "BP", "CT"
};

boolean checkLastMsgs = true;
ArrayList<String> lastMsgs = new ArrayList<String>();
int msgBufferSize = 10;

//PS: play sample, BD: bass drum, SD: snare, KI: kick,CB: cowbell, CR: crash
//I1: instrument 1, I2: instrument 2
// marker // TODO
final int PS = 0;
final int DRUMSSTART = 1;
final int DRUMSEND = 5;
final int INSTRUMENTSTART = 6;
final int INSTRUMENTEND = 7;
final int EFFECTSTART = 8;
final int EFFECTEND = 10;
final int TEMPO = 11;
final int CTRL = 12;
//
final int numIns = hashTags.length;
byte patterns[] = new byte[numIns - 1];
// length
final int patternL = 8;

final  long MINUTE = 60000;
int bpm = 135;
// nextBeat
long nextB;
// time increase
int nextBInc;
// pos in the sequence
int pos;
// sequence-bits
int bs[] = {
  1, 2, 4, 8, 16, 32, 64, 128, 256
};
// instrument sequence
int instrument_seq[][] = new int[2][8];

int sampleBaseNote = 36;

void parseMessage(String msg) {
  println("parsing: "+msg);
  if (checkLastMsgs) 
    if (!checkMsgBuffer(msg)) {
      println("Message already proccesed recently");
      return;
    } else 
      lastMsgs.add(msg);
  int hashInd = msg.indexOf('#');
  if (hashInd == -1 || msg.length() < hashInd+3) {
    println("msg to short or no hashtag: "+msg);
    return;
  }
  int tag = 0;
  String s = msg.substring(hashInd + 1, hashInd + 3);
  boolean found = false;
  for (int i = 0; i < numIns; i++) {
    if (s.equals(hashTags[i])) {
      tag = i;
      found = true;
      break;
    }
  }
  if (!found) {
    print("unknown tag "+msg);
    println(s);
    return;
  }
  //  println(tag);
  if (tag == PS) {
    if (!checkMsgLength(msg, hashInd+4))
      return;
    playSample(msg.substring(hashInd + 4));
  } else if (tag >= DRUMSSTART && tag <= DRUMSEND) {
    if (!checkMsgLength(msg, hashInd+4))
      return;
    String pa = msg.substring(hashInd + 4);
    drums(tag - DRUMSSTART, pa);
  } else if (tag >= INSTRUMENTSTART && tag <= INSTRUMENTEND) {
    if (!checkMsgLength(msg, hashInd+4))
      return;
    String pa = msg.substring(hashInd + 4);
    instrument(tag - INSTRUMENTSTART, pa);
  } else if (tag >= EFFECTSTART && tag <= EFFECTEND) {
    if (!checkMsgLength(msg, hashInd+4))
      return;
    String bpm = msg.substring(hashInd + 4);
    sendControl(tag-EFFECTSTART, int(bpm));
  } else if (tag == TEMPO) { 
    if (!checkMsgLength(msg, hashInd+4))
      return;
    String bpm = msg.substring(hashInd + 4);
    this.bpm = int(bpm);
    this.bpm = constrain(this.bpm, 60, 300);
    nextBInc = (int)(MINUTE / this.bpm);
  } else if (tag == CTRL) {
    if (!checkMsgLength(msg, hashInd+4))
      return;
    String m = msg.substring(hashInd + 4);
    String[] ps = split(m, ' ');
    if (ps.length<2)
      return;
    int ctrlNo = int(ps[0]);
    int val = int(ps[1]);
    val = constrain(val, 0, 127);
    sendControl(ctrlNo, val);
  }
}

void drums(int tag, String patternS) {
  //  println("d "+patternS+ " "+patternS.length());
  // pattern
  byte pattern = 0;
  for (int i = 0; i < patternL; i++) {
    if (patternS.length()<i+1)
      break;
    pattern = (byte)(pattern << 1);
    byte b = (byte)(patternS.charAt(i) == '1' ? 1 : 0);
    pattern += b;
  }
  //  Serial.println(pattern);
  patterns[tag] = pattern;
}



boolean checkMsgLength(String msg, int length) {
  if ( msg.length() >= length)
    return true;
  println("Message to short: "+msg);
  return false;
}

void instrument(int tag, String pattern) {
  //  println(pattern);
  for (int i = 0; i < patternL; i++) {
    //    println(i+" "+pattern.substring(0, 2));
    instrument_seq[tag][i] = int(pattern.substring(0, 2));
    if (pattern.length()>=3)
      pattern = pattern.substring(3);
  }
  //  for (int i = 0; i < patternL; i++)
  //    println(instrument_seq[tag][i]);
}


boolean checkMsgBuffer(String msg) {
  try {
    if (lastMsgs.size() > msgBufferSize) 
      for (int i=0; i < lastMsgs.size () - msgBufferSize; i++)
        lastMsgs.remove(i);
  } 
  catch(Exception e) {
  }
  for (int i=lastMsgs.size ()-1; i >= 0; i--) {
//    println("compare: "+msg+ ","+lastMsgs.get(i));
    if (lastMsgs.get(i).equals(msg))
      return false;
  }
  return true;
}

