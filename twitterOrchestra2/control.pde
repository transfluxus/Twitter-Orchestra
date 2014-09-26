import java.util.TreeSet;

TreeSet<Integer> ctrlNos = new TreeSet<Integer>();


void sendCtrlInit(int ctrl) {
  sendControl(ctrl, 100);
}

void sendControl(int ctrl, int value) {
  if (!ctrlNos.contains(ctrl)) {
    println("Controlnumber not sent yet: "+ctrl+" map it in ableton ...");
    ctrlNos.add(ctrl);
  }
  println(ctrl, value);
  myBus.sendControllerChange(0, ctrl, value);
}

boolean cimp = false;
String cimpS="";

void initCtrlMapSend() {
  cimp = true;
  cimpS="";
}

void addCIMP(int n) {
//  println(n);
  if (n>=0 && n<= 9)
    cimpS+=Integer.toString(n);
  if (cimpS.length()==3)
    sendCtrlMapSend();
}

void sendCtrlMapSend() {
  int ctrlNo = constrain(int(cimpS), 0, 127);
  sendCtrlInit(ctrlNo);
  cimpS = "";
  cimp = false;
}

