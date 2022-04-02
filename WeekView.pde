import java.lang.Math;
void mouseDragged() {
  toSubtract = (pmouseY-mouseY)*1.7;
}
void weekView() {

  transScale -= toSubtract;
  if (toSubtract > 0) {
    if (toSubtract > 150) {
      toSubtract-=3;
    } else {
      toSubtract-=2.5;
    }
    if (toSubtract < 0) {
      toSubtract = 0;
    }
  } else if (toSubtract < 0) {
    if (toSubtract < -150) {
      toSubtract+=3;
    } else {
      toSubtract+=2.5;
    }
  }
  if (transScale > 250) {
    toSubtract -=7;
  }
  if (transScale > 150) {
    toSubtract -=5;
  }
  if (transScale > 0) {
    transScale = 0;
  } 
  if (transScale < (-100*daysLeft)-((height*0.102986612)*2) + height - 50) {
    transScale = (-100*daysLeft)-((height*0.102986612)*2) + height - 50;
    toSubtract = 0;
  } 
  background(0);
  textAlign(CENTER);
  fill(43, 88, 12);
  pushMatrix();
  translate(0, height*0.145833333);
  translate(0, transScale);
  for (int i = 0; i < getMaxVal(); i++) {
    if (i >= int(Math.abs(transScale/200))-1) {
      rects.get(i).drawRect();
    }
    translate(0, 200);
  }

  noStroke();
  popMatrix();
  fill(43, 88, 12);
  rect(0, height -  height*0.102986612, width, height, 20*displayDensity, 20*displayDensity, 0, 0); //These two are the two rectangles on the top and bottom
  imageMode(CENTER);
  //image(settingsp, height*0.102986612/2, height - height*0.102986612/2, height*0.102986612/2, height*0.102986612/2);
  //image(calendar, width - height*0.102986612/2, height - height*0.102986612/2, height*0.102986612/2, height*0.102986612/2);
  //image(weekV, width/2, height - height*0.102986612/2, height*0.102986612/2, height*0.102986612/2);
  rect(0, 0, width, height*0.102986612, 0, 0, 15*displayDensity, 15*displayDensity);
  fill(255);
  textFont(font, 25*displayDensity); //Setting Text Font
  textAlign(CENTER);
  text("tMuslim WeekView\u2122 Beta", width/2, height*0.0494444444 + 25); //Top Text
  imageMode(CENTER); //Setting the image mode to Center
  image(home, height*0.102986612/2, height - height*0.102986612/2, height*0.102986612/2, height*0.102986612/2); //Icons for switching Screens
  image(prayer, width - height*0.102986612/2, height - height*0.102986612/2, height*0.102986612/2, height*0.102986612/2);
  image(compasss, width/2, height - height*0.102986612/2, height*0.102986612/2, height*0.102986612/2);
}

void mouseWheel(MouseEvent event) {
  if (view == 1 && screenNumber == 1) {
    float e = event.getCount();
    toSubtract += e*8.75;
    if (toSubtract < 0 && transScale == 0) {
      toSubtract = 0;
    }
  }
}
void initWeekView() {
  rects.clear();
  viewWeek.set(Calendar.MONTH, 11);
  viewWeek.set(Calendar.DAY_OF_MONTH, 30);
  daysLeft = (viewWeek.get(Calendar.DAY_OF_YEAR) - cal.get(Calendar.DAY_OF_YEAR)) + 1;
  for (int i = cal.get(Calendar.DAY_OF_YEAR); i <= viewWeek.get(Calendar.DAY_OF_YEAR); i++) {
    Calendar temp = Calendar.getInstance();
    temp.set(Calendar.DAY_OF_YEAR, i);
    String arg = str(temp.get(Calendar.MONTH) + 1) + "/" + str(temp.get(Calendar.DAY_OF_MONTH));
    rects.add(new WeekRect(parseDateWeekView(arg), i - cal.get(Calendar.DAY_OF_YEAR), i));
  }
}
String otherCalDate;

String[] parseDateWeekView(String lineIn) {
  String[] split = split(lineIn, '/');
  Calendar c = Calendar.getInstance();
  c.set(Calendar.DAY_OF_MONTH, int(split[1]));
  c.set(Calendar.MONTH, int(split[0]) - 1);
  int dayOfMonth = c.get(Calendar.DAY_OF_MONTH);
  String dayOfWeek = week[c.get(Calendar.DAY_OF_WEEK)];
  String month = months[c.get(Calendar.MONTH) + 1];
  otherCalDate = month + " " + c.get(Calendar.DAY_OF_MONTH) + " 2021";
  String[] toReturn = {dayOfWeek, otherCalDate, loadTimesWeekView(dayOfMonth, month)};
  return toReturn;
}

String loadTimesWeekView(int day, String month) {
  String num = str(day);
  if (day < 10) {
    num = nf(day, 2); //Add 0 before number if necissary
  }
  String date = num + month;
  String fajr = "";
  String maghrib = "";
  for (int i = 0; i < times.length; i++) { //Until you find the entry with todays date continue the loop
    String toCheck = times[i];
    if (toCheck.equals(date)) { //Once you've found todays date, import all the prayer data
      fajr = times[i+1];
      maghrib = times[i+4];
      break; //Break the loop (stop the loop)
    }
  }
  return fajr + "/" + maghrib;
}

double getMaxVal() {
  if (int((height + 300)) / 100 + Math.ceil(Math.abs(transScale)/100) < daysLeft) {
    return int((height + 300)) / 100 + Math.ceil(Math.abs(transScale)/200);
  } else {
    double toSubtract = int((height + 300)) / 100 + Math.ceil(Math.abs(transScale)/100) - daysLeft;
    return int((height + 300)) / 100 + Math.ceil(Math.abs(transScale)/100) - toSubtract;
  }
}
void onDoubleTap(float x, float y)
{
  if (screenNumber == 1 && view == 1) {
    for (int i = 0; i < getMaxVal(); i++) {
      rects.get(i).checkPos(x, y);
    }
  }
}
public boolean surfaceTouchEvent(MotionEvent event) {

  //call to keep mouseX, mouseY, etc updated
  super.surfaceTouchEvent(event);

  //forward event to class for processing
  return gesture.surfaceTouchEvent(event);
}
