/*
Tweet like this:
#PS sampleName @twitrchestra
example:
#PS birds  @twitrchestra

or one of these hashtags
"BD", "SD", "KI", "CB", "CR"
and a sequence of 8:
10101010
Example:
#BD 10001000 @twitrchestra
*/
String[] sampleNames = { "birds","ambient","bamboo","tui",
"metal-rub","door","dialup","boom","chicken","children-playing",
"raindrops","pascal",
"herbst","glitch1","glitch2","ship","guitar","sitar"
};


String[] testStrings = {
  "#BD 10001000"
    , "#SD 10101010"
    , "#KI 01110000"
    , "#CB 00000001"
    //, "#CR 10110000"
    ,"#CT 5 120"
    , "#I1 51.53.55.56.-1.60.60.58"
    , "#I2 42.47.42.42.47.42.42.42"
    , "#PS birds"
    , "#BP 150"
    , "#BD 11001000"
};

void sendDefaultTest(int index) {  
 // println(index);
  if(index >= 17 && index <= 27) // a,b,c,d,e,f,g,h,i,j
      playSample(index-17);
  if (index<testStrings.length && index >= 0)
    sendTest(testStrings[index]);
}

// for testing
void playSample(int index) {
  if (index>=0 && index < sampleNames.length) {
    myBus.sendNoteOn(3,sampleBaseNote+index, 127);
  }
}

void sendTest(String msg) {
  //parseMessage(msg);
  serialEvent(msg);
}
