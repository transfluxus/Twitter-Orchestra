
void parseMessage(String msg) {
  int hashInd = msg.indexOf('#');
  if (hashInd == -1)
    return;
  int tag = 0;
  String s = msg.substring(hashInd + 1, hashInd + 3);
  boolean found;
  for (int i = 0; i < numIns; i++) {
    if (s == hashTags[i]) {
      tag = i;
      Serial.println(s);
      found = true;
      break;
    }
  }
  if (!found) {
    Serial.print("wrong tag ");
    Serial.println(s);
    return;
  }
  if (tag == 0)
    playSample(msg.substring(hashInd + 4));
  else if (tag >= DRUMSSTART && tag <= DRUMSEND) {
    String pa = msg.substring(hashInd + 4, hashInd + 4 + patternL);
    drums(tag - DRUMSSTART, pa);
  } else if (tag >= INSTRUMENTSTART && tag <= INSTRUMENTEND) {
    String pa = msg.substring(hashInd + 4);
    instrument(tag - INSTRUMENTSTART, pa);
  }
}


void playSample(String sampleName) {
//  Process p;
//  p.runShellCommandAsynchronously("madplay " + sampleFolder + sampleName + ".wav");
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
  //  Serial.println(patternS);
  for (int i = 0; i < patternL; i++) {
    pattern = pattern << 1;
    byte b = patternS.charAt(i) == '1' ? 1 : 0;
    pattern += b;
  }
  //  Serial.println(pattern);
  patterns[tag] = pattern;
}

void instrument(int tag, String pattern) {
  //  Serial.println(pattern);
  for (int i = 0; i < patternL; i++) {
    Serial.println(pattern.substring(0, 2));
    instrument_seq[tag][i] = pattern.substring(0, 2).toInt();
    pattern = pattern.substring(3);
  }
  for (int i = 0; i < patternL; i++)
    Serial.println(instrument_seq[tag][i]);
}


