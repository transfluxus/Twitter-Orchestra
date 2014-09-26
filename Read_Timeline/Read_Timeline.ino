#include <Bridge.h>
#include <Temboo.h>
#include "accounts.h" // contains Temboo account information

int numRuns = 1;   // execution count, so this doesn't run forever
int maxRuns = 999;   // the max number of times the Twitter HomeTimeline Choreo should run

unsigned long nextTwitterCheck = 0;
unsigned long twitterDelay = 5000;

TembooChoreo HomeTimelineChoreo;

//
String hashTags[] = {"PS", "BD", "SD", "KI", "CB", "CR", "I1", "I2"};
//PS: play sample, BD: bass drum, SD: snare, KI: kick,CB: cowbell, CR: crash
//I1: instrument 1, I2: instrument 2
// marker // TODO
const int DRUMSSTART = 1;
const int DRUMSEND = 5;
const int INSTRUMENTSTART = 6;
const int INSTRUMENTEND = 7;
const int EFFECTSTART = 8;
const int EFFECTEND = 10;
//
const int numIns = 8;
byte patterns[numIns - 1];
// length
const int patternL = 8;

const unsigned long MINUTE = 60000;
int bpm = 135;
// nextBeat
unsigned long nextB;
// time increase
int nextBInc;
// pos in the sequence
int pos;
// sequence-bits
int bs[] = {1, 2, 4, 8, 16, 32, 64, 128, 256};

int instrument_seq[2][8];



void setup() {
  pinMode(2, OUTPUT);
  pinMode(3, OUTPUT);
  pinMode(4, OUTPUT);
  Serial.begin(9600);
  // For debugging, wait until a serial console is connected.
  delay(4000);
  while (!Serial);
  Bridge.begin();
  nextBInc = MINUTE / bpm;
}

void loop() {
  sequencer();
  tembooCheck();
  if (millis() > nextTwitterCheck) {
    temboo();
    nextTwitterCheck += twitterDelay;
  }
  // while we haven't reached the max number of runs...
}

void sequencer() {
  unsigned long time = millis();
  if (time > nextB) {
    nextB += nextBInc;
    Serial.print(">");
    for (int i = DRUMSSTART; i <= DRUMSEND; i++) {
      if (patterns[i - 1] & bs[pos])
        Serial.print(hashTags[i]);
      else
        Serial.print("..");
      Serial.print("-");
    }
    Serial.print(" ");
    Serial.print(instrument_seq[0][pos]);
    Serial.print("-");
    Serial.print(instrument_seq[1][pos]);
    // Serial.print(" ");
    Serial.println("");

    pos = (pos + 1) % patternL;
  }
}

void temboo() {
  if (numRuns <= maxRuns) {
    Serial.println("Running ReadATweet - Run #" + String(numRuns++));

    HomeTimelineChoreo.close();
    HomeTimelineChoreo.begin();
    HomeTimelineChoreo.setAccountName(TEMBOO_ACCOUNT);
    HomeTimelineChoreo.setAppKeyName(TEMBOO_APP_KEY_NAME);
    HomeTimelineChoreo.setAppKey(TEMBOO_APP_KEY);
    HomeTimelineChoreo.setChoreo("/Library/Twitter/Timelines/HomeTimeline");
    HomeTimelineChoreo.addInput("Count", "1"); // the max number of Tweets to return from each request
    HomeTimelineChoreo.addInput("AccessToken", TWITTER_ACCESS_TOKEN);
    HomeTimelineChoreo.addInput("AccessTokenSecret", TWITTER_ACCESS_TOKEN_SECRET);
    HomeTimelineChoreo.addInput("ConsumerKey", TWITTER_API_KEY);
    HomeTimelineChoreo.addInput("ConsumerSecret", TWITTER_API_SECRET);
    HomeTimelineChoreo.addOutputFilter("tweet", "/[1]/text", "Response");
    HomeTimelineChoreo.addOutputFilter("author", "/[1]/user/screen_name", "Response");
    unsigned int returnCode = HomeTimelineChoreo.run();
    HomeTimelineChoreo.runAsynchronously();
/*
    if (returnCode == 0) {
      String author; // a String to hold the tweet author's name
      String tweet; // a String to hold the text of the tweet
      while (HomeTimelineChoreo.available()) {
        // read the name of the output item
        String name = HomeTimelineChoreo.readStringUntil('\x1F');
        name.trim();
        String data = HomeTimelineChoreo.readStringUntil('\x1E');
        data.trim();
        // assign the value to the appropriate String
        if (name == "tweet") {
          tweet = data;
        } else if (name == "author") {
          author = data;
        }
      }
      Serial.println("@" + author + " - " + tweet);
      parseMessage(tweet);
*/

      //  Serial.println(tweet);
      /*
            int hashPos = tweet.indexOf('#');
            //Serial.println(hashPos);
            if (tweet.substring(hashPos) == "#two") {
                digitalWrite(2, HIGH);
                digitalWrite(3, LOW);
                digitalWrite(4, LOW);
              } else if (tweet.substring(hashPos) == "#three") {
                digitalWrite(2, LOW);
                digitalWrite(3, HIGH);
                digitalWrite(4, LOW);
              } else if (tweet.substring(hashPos) == "#four") {
                digitalWrite(2, LOW);
                digitalWrite(3, LOW);
                digitalWrite(4, HIGH);
              } else {
                digitalWrite(2, LOW);
                digitalWrite(3, LOW);
                digitalWrite(4, LOW);
              }
      
    } else {
      while (HomeTimelineChoreo.available()) {
        char c = HomeTimelineChoreo.read();
        //     Serial.print(c);
      }
    }
    HomeTimelineChoreo.close();
    */
  }
  // Serial.println("Waiting...");
  //  delay(5000); // wait 90 seconds between HomeTimeline calls
}

void tembooCheck() {
  String author; // a String to hold the tweet author's name
  String tweet; // a String to hold the text of the tweet
  while (HomeTimelineChoreo.available()) {
    // read the name of the output item
    String name = HomeTimelineChoreo.readStringUntil('\x1F');
    name.trim();
    String data = HomeTimelineChoreo.readStringUntil('\x1E');
    data.trim();
    // assign the value to the appropriate String
    if (name == "tweet") {
      tweet = data;
    } else if (name == "author") {
      author = data;
    }
  }
  Serial.println("@" + author + " - " + tweet);
  parseMessage(tweet);

}
