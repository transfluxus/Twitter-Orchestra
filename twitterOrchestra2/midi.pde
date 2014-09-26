int midiBaseNote = 21;

void playDrum(int i) {
//  println(i,(midiBaseNote+i));
  myBus.sendNoteOn(0, midiBaseNote+i, 120); // Send a Midi noteOn
  //  println("d: "+(midiBaseNote+i));
}

int instrumentBaseNote = 32;

int notes[] = new int[2];

void playNote(int instrument, int note) {
//  println(note);
  myBus.sendNoteOff(1+instrument, notes[instrument], 120); 
  if(note == -1)
    return;
  note += instrumentBaseNote;
//  println(instrument, note);
  notes[instrument] = note;
  myBus.sendNoteOn(1+instrument, note, 120);
}

void playSample(String sampleName) {
  String[] s = split(sampleName,' ');
  int index =getSampleIndex(s[0]);
  if (index != -1)
    myBus.sendNoteOn(3, sampleBaseNote+index, 127);
  else {
    println("Sample with name: "+s +" not found");
  }
}

