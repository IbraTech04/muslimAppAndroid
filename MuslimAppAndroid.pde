import cassette.audiofiles.*;
import java.util.Calendar; //Import Calendar Functions
import android.media.MediaPlayer; 
import android.content.res.AssetFileDescriptor; 
import android.view.MotionEvent;

import ketai.ui.*;

import android.content.DialogInterface;
import android.app.Activity;
import android.app.AlertDialog;
import android.text.Editable;
import android.widget.EditText;

KetaiGesture gesture;

MediaPlayer mp; 
Context context; 
Activity act; 
AssetFileDescriptor afd;
Activity sound;

Calendar cal = Calendar.getInstance(); //Get calendar date
CompassManager compass;
PFont font; //Define Font  variable
PImage home, prayer, img, compasss; //Define image varibles
String calDate = ""; //Varible which holds the date
int day = day(), mon = month(), lineNum, hourLeft, minLeft, nextPrayerMin, nextPrayerHour, date = cal.get(Calendar.DAY_OF_WEEK), screenNumber = 1;
boolean fajrStat;
String[] week = {"", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}, months = {"", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"}, times;
String fajrHour, fajrMinute, duhurHour, duhurMinute, asrHour, asrMinute, maghribHour, maghribMinute, ishaHour, ishaMinute, fajrHourNext, fajrMinuteNext, nextPrayer; //Varibles which hold prayer times
String prevPrayer;
float direction;
void directionEvent(float newDirection) {
  direction = newDirection;
}


ArrayList<WeekRect> rects = new ArrayList<WeekRect>();
Calendar viewWeek = Calendar.getInstance(); //Get calendar date
Calendar event = Calendar.getInstance(); //Get calendar date

void setup() {
  background(0); //Setting Background
  textSize(100); //Set text size
  textAlign(CENTER);
  text("tMuslim V" + ver, width/2, height/2); //Loading Text
  sound = this.getActivity(); 
  context = sound.getApplicationContext(); 
  try { 
    mp = new MediaPlayer(); 
    afd = context.getAssets().openFd("Athan1.mp3");//which is in the data folder 
    mp.setDataSource(afd.getFileDescriptor()); 
    mp.prepare();
  } 
  catch(IOException e) { 
    println("file did not load");
  } 
  requestPermission("android.permission.READ_EXTERNAL_STORAGE", "doNothing");
  requestPermission("android.permission.WRITE_EXTERNAL_STORAGE", "downloadFile");//Setup Function
  try {
    checkForUpdates();
  }
  catch (Exception e) {
  }
  gesture = new KetaiGesture(this);
  compass = new CompassManager(this);
  background(0); //Setting Background
  textSize(100); //Set text size
  textAlign(CENTER);
  text("tMuslim V" + ver, width/2, height/2); //Loading Text
  times = loadStrings("Annual Prayers.txt"); //Load the file with all the prayer times
  fullScreen();
  orientation(PORTRAIT);
  noStroke();
  font = createFont("Product Sans Bold.ttf", 100); //Load the font
  home = loadImage("mosque.png"); //Load the images
  compasss = loadImage("compass.png"); //Load the images
  prayer = loadImage("Clock.png");
  img = loadImage("CMPS.png");
  loadTimes(); //Load the prayer times 
  delay(1000); //Delay which allows the user to read the loading text
  initWeekView();
}
void draw() { //Draw function
  // println(mp.isPlaying());
  if (updateMode) {
    background(0);
    beginUpdate();
  } else {
    playAthan();
    if (screenNumber == 0) {   //if statement which changes between the screens
    } else if (screenNumber == 1) {
      if (view == 0) {
        mainScreen();
      } else {
        weekView();
      }
    } else if (screenNumber == 2) {
      prayerList();
    } else if (screenNumber == 3) {
      qiblaDraw();
    } else if (screenNumber == 4) {
      onTime(event);
    }
  }
}
void mainScreen() { //The main screen function that draws the home screen
  calDate = "";
  date();
  background(0);
  fill(43, 88, 12);
  rect(0, height -  height*0.102986612, width, height, 20*displayDensity, 20*displayDensity, 0, 0); //These two are the two rectangles on the top and bottom
  rect(0, 0, width, height*0.102986612, 0, 0, 15*displayDensity, 15*displayDensity);
  fill(255);
  textFont(font, 25*displayDensity); //Setting Text Font
  textAlign(CENTER);
  text("tMuslim Home", width/2, height*0.0494444444 + 25); //Top Text
  imageMode(CENTER); //Setting the image mode to Center
  image(home, height*0.102986612/2, height - height*0.102986612/2, height*0.102986612/2, height*0.102986612/2); //Icons for switching Screens
  image(prayer, width - height*0.102986612/2, height - height*0.102986612/2, height*0.102986612/2, height*0.102986612/2);
  image(compasss, width/2, height - height*0.102986612/2, height*0.102986612/2, height*0.102986612/2);
  pushMatrix();
  translate(0, -50);
  textFont(font, 21*displayDensity);
  text(calDate, width/2, sizeDeteccH(790, height)); //Drawing hte date
  textFont(font, 75*displayDensity);
  //Calculating current time
  int hour = hour();
  if (hour > 12) {
    hour -= 12; //Convert to 12-hour if necissary
  }
  if (hour == 0) {
    hour = 12;
  }
  String min = str(minute());
  if (minute() < 10) {
    min = nf(minute(), 2); //Add 0 before number if necissary
  }
  String nextPrayerMinS = str(nextPrayerMin);
  if (nextPrayerMin < 10) {
    nextPrayerMinS = nf(nextPrayerMin, 2);
  }
  text(hour + " :" + min, width/2, height/2); //Draw clock
  textFont(font, 20*displayDensity);
  checkPrayer(); //Check which prayer is next
  timeCalc(nextPrayerHour, nextPrayerMin, fajrStat); //Calculate time until next prayer
  if (mp.isPlaying()) {
    text("Current Prayer: " + prevPrayer, width/2, sizeDeteccH(1030, height)); //Draw the current prayer
  } else {
    text("Next Prayer: " + nextPrayer, width/2, sizeDeteccH(1030, height)); //Draw the next prayer
    textFont(font, 17*displayDensity);
    text("At: " + nextPrayerHour + ":" + nextPrayerMinS, width/2, sizeDeteccH(1080, height)); //Draw next prayer's time
    text("(-" + return0Value(timeCalc(nextPrayerHour, nextPrayerMin, fajrStat)[0]) + ":" + return0Value(timeCalc(nextPrayerHour, nextPrayerMin, fajrStat)[1]) + ")", width/2, sizeDeteccH(1130, height)); //Draw how much time is left
    if (isSuhoorNext) {
      if (hour() == 0) {
        text("Time until Fajr: (-" + return0Value(timeCalc(int(fajrHour), int(fajrMinute), true)[0]) + ":" + return0Value(timeCalc(int(fajrHour), int(fajrMinute), true)[1]) + ")", width/2, sizeDeteccH(1175, height)); //Draw how much time is left
      } else if (hour() > 0 && hour < 5) {
        text("Time until Fajr: (-" + return0Value(timeCalc(int(fajrHour), int(fajrMinute), true)[0]) + ":" + return0Value(timeCalc(int(fajrHour), int(fajrMinute), true)[1]) + ")", width/2, sizeDeteccH(1175, height)); //Draw how much time is left
      } else {
        text("Time until Fajr: (-" + return0Value(timeCalc(int(fajrHourNext), int(fajrMinuteNext), true)[0]) + ":" + return0Value(timeCalc(int(fajrHourNext), int(fajrMinuteNext), true)[1]) + ")", width/2, sizeDeteccH(1175, height)); //Draw how much time is left
      }
    } else {
      text("Time until Maghrib: (-" + return0Value(timeCalc(int(maghribHour), int(maghribMinute), false)[0]) + ":" + return0Value(timeCalc(int(maghribHour), int(maghribMinute), fajrStat)[1]) + ")", width/2, sizeDeteccH(1175, height)); //Draw how much time is left
    }
  }
  popMatrix();
}

void qiblaDraw() {
  background(0);
  fill(43, 88, 12);
  rect(0, height -  height*0.102986612, width, height, 20*displayDensity, 20*displayDensity, 0, 0); //Rectangles at top and bottom
  rect(0, 0, width, height*0.102986612, 0, 0, 15*displayDensity, 15*displayDensity);
  fill(255);
  textFont(font, 25*displayDensity); //Setting Text Font
  textAlign(CENTER);
  text("tMuslim Qibla Locator", width/2, height*0.0494444444 + 25); //Top text
  imageMode(CENTER);
  image(home, height*0.102986612/2, height - height*0.102986612/2, height*0.102986612/2, height*0.102986612/2); //Icons for switching Screens
  image(prayer, width - height*0.102986612/2, height - height*0.102986612/2, height*0.102986612/2, height*0.102986612/2);
  image(compasss, width/2, height - height*0.102986612/2, height*0.102986612/2, height*0.102986612/2);
  fill(15, 168, 191);
  fill(255);
  textFont(font, 20);
  noStroke();
  translate(width/2, height/2);
  scale(2);
  rotate(direction);
  image(img, 0, 0, 500, 500);
}

void prayerList() {
  background(0);
  fill(43, 88, 12);
  rect(0, height -  height*0.102986612, width, height, 20*displayDensity, 20*displayDensity, 0, 0); //Rectangles at top and bottom
  rect(0, 0, width, height*0.102986612, 0, 0, 15*displayDensity, 15*displayDensity);
  fill(255);
  textFont(font, 25*displayDensity); //Setting Text Font
  textAlign(CENTER);
  text("tMuslim Prayer List", width/2, height*0.0494444444 + 25); //Top text
  imageMode(CENTER);
  image(home, height*0.102986612/2, height - height*0.102986612/2, height*0.102986612/2, height*0.102986612/2); //Icons for switching Screens
  image(prayer, width - height*0.102986612/2, height - height*0.102986612/2, height*0.102986612/2, height*0.102986612/2);
  image(compasss, width/2, height - height*0.102986612/2, height*0.102986612/2, height*0.102986612/2);
  textAlign(CENTER);
  textFont(font, 25*displayDensity);
  text("Prayer Times:", width/2, height/2-225);
  textFont(font, 21*displayDensity);
  if (nextPrayer.equals("Fajr")) {
    fill(50, 130, 184);
  } else if (prevPrayer.equals("Fajr") && mp.isPlaying()) {
    fill(128, 0, 0);
  } else {
    fill(255);
  }
  text("Fajr: " + fajrHour + ":" + fajrMinute, width/2, sizeDeteccH(855, height)); //Drawing Prayer times
  if (nextPrayer.equals("Duhur")) {
    fill(50, 130, 184);
  } else if (prevPrayer.equals("Duhur") && mp.isPlaying()) {
    fill(128, 0, 0);
  } else {
    fill(255);
  }
  text("Duhur: " + duhurHour + ":" + duhurMinute, width/2, sizeDeteccH(908, height));
  if (nextPrayer.equals("Asr")) {
    fill(50, 130, 184);
  } else if (prevPrayer.equals("Asr") && mp.isPlaying()) {
    fill(128, 0, 0);
  } else {
    fill(255);
  }
  text("Asr: " + asrHour + ":" + asrMinute, width/2, height/2);
  if (nextPrayer.equals("Maghrib")) {
    fill(50, 130, 184);
  } else if (prevPrayer.equals("Maghrib") && mp.isPlaying()) {
    fill(128, 0, 0);
  } else {
    fill(255);
  }
  text("Maghrib: " + maghribHour + ":" + maghribMinute, width/2, sizeDeteccH(1012, height));
  if (nextPrayer.equals("Isha")) {
    fill(50, 130, 184);
  } else if (prevPrayer.equals("Isha") && mp.isPlaying()) {
    fill(128, 0, 0);
  } else {
    fill(255);
  }
  text("Isha: " + ishaHour + ":" + ishaMinute, width/2, sizeDeteccH(1065, height));
  fill(255);
  text("Total Fast Time: " + return0Value(timeCalc(int(maghribHour), int(maghribMinute), int(fajrHour), int(fajrMinute), false)[0]) + ":" + return0Value(timeCalc(int(maghribHour), int(maghribMinute), int(fajrHour), int(fajrMinute), false)[1]), width/2, sizeDeteccH(1118, height));
}
//Calculate Date in format which user can understand
void date() {
  calDate += week[date];
  calDate += ", ";
  calDate += months[mon];
  calDate += " ";
  calDate += day;
  calDate += ", ";
  calDate += year();
}
//The function that loads the prayer times from a file and hands them to the program
void loadTimes() {
  String num = str(day());
  if (day() < 10) {
    num = nf(day(), 2); //Add 0 before number if necissary
  }
  String date = num + months[mon];
  for (int i = 0; i < times.length; i++) { //Until you find the entry with todays date continue the loop
    String toCheck = times[i];
    if (toCheck.equals(date)) { //Once you've found todays date, import all the prayer data
      fajrHour = split(times[i+1], ':')[0];
      fajrMinute = (split(times[i+1], ':')[1]);
      duhurHour = (split(times[i+2], ':')[0]);
      duhurMinute = (split(times[i+2], ':')[1]);
      asrHour = (split(times[i+3], ':')[0]);
      asrMinute = (split(times[i+3], ':')[1]);
      maghribHour = (split(times[i+4], ':')[0]);
      maghribMinute = (split(times[i+4], ':')[1]);
      ishaHour = (split(times[i+5], ':')[0]);
      ishaMinute = (split(times[i+5], ':')[1]);
      fajrHourNext = (split(times[i+7], ':')[0]);
      fajrMinuteNext = (split(times[i+7], ':')[1]);
      break; //Break the loop (stop the loop)
    }
  }
}

void mousePressed() { //Function which detects whether the mouse has pressed an icon or not
  if (mouseY >= height -  height*0.102986612 && mouseX <=height*0.102986612) {
    if (screenNumber != 1) {
      screenNumber = 1;
    } else {
      if (view == 1) {
        view = 0;
      } else {
        view = 1;
      }
    }
  } else if (mouseY >= height -  height*0.102986612 && mouseX >=width - height*0.102986612) {
    screenNumber = 2;
  } else if (mouseY >= height -  height*0.102986612 && mouseX <= width/2 + height*0.102986612 && mouseX >= width/2 - height*0.102986612) {
    screenNumber = 3;
  }
}
void checkPrayer() { //Function which checks which prayer is next by using LOTS AND LOTS OF MATH (Not even gonna bother explaining how)
  if (hour() > int(ishaHour) + 12 || hour() <= int(fajrHour)) {
    isSuhoorNext = true;
    nextPrayer = "Fajr";
    prevPrayer = "Isha";
    fajrStat = true;
    if (hour() == 0) {
      nextPrayerHour = int(fajrHour);
      nextPrayerMin = int(fajrMinute);
    } else if (hour() > 0 && hour() < 5) {
      nextPrayerHour = int(fajrHour);
      nextPrayerMin = int(fajrMinute);
    } else {
      nextPrayerHour = int(fajrHourNext);
      nextPrayerMin = int(fajrMinuteNext);
    }

    if (hour() == int(fajrHour)) {
      if (minute() < int(fajrMinute)) {
        isSuhoorNext = true;
        nextPrayer = "Fajr";
        prevPrayer = "Isha";
        fajrStat = true;
        nextPrayerHour = int(fajrHour);
        nextPrayerMin = int(fajrMinute);
      } else {
        isSuhoorNext = false;
        fajrStat = false;
        nextPrayer = "Duhur";
        prevPrayer = "Fajr";
        nextPrayerHour = int(duhurHour);
        nextPrayerMin = int(duhurMinute);
      }
    }
  } else if (hour() >= int(fajrHour) && hour() <= returnGreaterThan(int(duhurHour))) {
    isSuhoorNext = false;
    nextPrayer = "Duhur";
    prevPrayer = "Fajr";
    fajrStat = false;
    nextPrayerHour = int(duhurHour);
    nextPrayerMin = int(duhurMinute);
    if (hour() == returnGreaterThan(int(duhurHour))) {
      if (minute() < int(duhurMinute)) {
        nextPrayer = "Duhur";
        prevPrayer = "Fajr";
        fajrStat = false;
        nextPrayerHour = int(duhurHour);
        nextPrayerMin = int(duhurMinute);
      } else {
        nextPrayer = "Asr";
        prevPrayer = "Duhur";
        fajrStat = false;
        nextPrayerHour = int(asrHour);
        nextPrayerMin = int(asrMinute);
      }
    }
  } else if (hour() >= returnGreaterThan(int(duhurHour)) && hour() <= int(asrHour) + 12) {
    isSuhoorNext = false;
    nextPrayer = "Asr";
    prevPrayer = "Duhur";
    fajrStat = false;
    nextPrayerHour = int(asrHour);
    nextPrayerMin = int(asrMinute);
    if (hour() == int(asrHour) + 12) {
      if (minute() < int(asrMinute)) {
        nextPrayer = "Asr";
        prevPrayer = "Duhur";
        fajrStat = false;
        nextPrayerHour = int(asrHour);
        nextPrayerMin = int(asrMinute);
      } else {
        nextPrayer = "Maghrib";
        prevPrayer = "Asr";
        fajrStat = false;
        nextPrayerHour = int(maghribHour);
        nextPrayerMin = int(maghribMinute);
      }
    }
  } else if (hour() >= int(asrHour) + 12 && hour() <= int(maghribHour) + 12) {
    isSuhoorNext = false;
    nextPrayer = "Maghrib";
    prevPrayer = "Asr";
    fajrStat = false;
    nextPrayerHour = int(maghribHour);
    nextPrayerMin = int(maghribMinute);
    if (hour() == int(maghribHour) + 12) {
      if (minute() < int(maghribMinute)) {
        nextPrayerHour = int(maghribHour);
        nextPrayerMin = int(maghribMinute);
        nextPrayer = "Maghrib";
        prevPrayer = "Asr";
        fajrStat = false;
      } else {
        isSuhoorNext = true;
        fajrStat = false;
        nextPrayer = "Isha";
        prevPrayer = "Maghrib";
        nextPrayerHour = int(ishaHour);
        nextPrayerMin = int(ishaMinute);
      }
    }
  } else if (hour() >= int(maghribHour) + 12 && hour() <= int(ishaHour) + 12) {
    isSuhoorNext = true;
    fajrStat = false;
    nextPrayerHour = int(ishaHour);
    nextPrayerMin = int(ishaMinute);
    nextPrayer = "Isha";
    prevPrayer = "Maghrib";
    if (hour() == int(ishaHour) + 12) {
      if (minute() < int(ishaMinute)) {
        isSuhoorNext = true;
        fajrStat = false;
        nextPrayer = "Isha";
        prevPrayer = "Maghrib";
        nextPrayerHour = int(ishaHour);
        nextPrayerMin = int(ishaMinute);
      } else {
        isSuhoorNext = true;
        fajrStat = true;
        nextPrayer = "Fajr";
        prevPrayer = "Isha";
        nextPrayerHour = int(fajrHourNext);
        nextPrayerMin = int(fajrMinuteNext);
      }
    }
  }
}
void playAthan() { //Function which checks whether its time to play the athan, and does so
  int hour = hour();
  if (hour > 12) { //Convert to 12 hour time (if necissary)
    hour -= 12;
  }
  if (!mp.isPlaying()) { //If the Athan is not playing
    if (int(fajrHour) == hour && int(fajrMinute) == minute()) { //IF its fajr
      mp.start(); //Play athan
    } else  if (returnGreaterThan(int(duhurHour)) == hour && int(duhurMinute) == minute()) { //If its duhur
      mp.start(); //Play Athan
    } else  if (returnGreaterThan(int(asrHour)) == hour && int(asrMinute) == minute()) { //If its asr 
      mp.start(); //Play athan
    } else  if (returnGreaterThan(int(maghribHour)) == hour && int(maghribMinute) == minute()) { //If its maghtib
      mp.start(); //Play Athan
    } else  if (returnGreaterThan(int(ishaHour)) == hour && int(ishaMinute) == minute()) { //If its Isha
      mp.start(); //Play Athan
    }
  }
}

int[] timeCalc(int prayerHour, int prayerMin, boolean fajr) { //Time calculation function (If you think im gonna bother explaining all the math you're insane)
  int minute = minute(), hour = hour(); 
  int localMinLeft = 0;
  int localHourLeft = 0;
  int localHours = prayerHour;
  if (localHours < 12) {
    localHours +=12;
  }
  if (fajr) { //If we're calculating Fajr do this (This is because calculating Fajr is a bit more involved than other prayers)
    if (hour == 0) {
      localMinLeft = 60 - minute;
      localHours --;
      localMinLeft += int(prayerMin);
      if (localMinLeft >= 60) {
        localHourLeft ++;
        localMinLeft = localMinLeft - 60;
      }
      localHourLeft += int(prayerHour);
    } else if (hour > 0 && hour < 5) {
      localMinLeft = 60 - minute;
      localHourLeft --;
      localMinLeft += int(prayerMin);
      if (localMinLeft >= 60) {
        localHourLeft ++;
        localMinLeft = localMinLeft - 60;
      }
      localHourLeft = localHourLeft + (int(prayerHour) - hour());
    } else {
      localMinLeft = 60 - minute;
      localHourLeft --;
      localMinLeft += int(prayerMin);
      if (localMinLeft >= 60) {
        localHourLeft ++;
        localMinLeft = localMinLeft - 60;
      }
      localHourLeft += 24 - hour;

      localHourLeft += int(prayerHour);

      if (localMinLeft >= 60) {
        localHourLeft ++;
        localMinLeft = localMinLeft - 60;
      }
    }
    return new int[]{ localHourLeft, localMinLeft};
  } else {//Otherwise proceed normally
    localMinLeft = 60 - minute;
    localHours --;
    localMinLeft += prayerMin;
    if (localMinLeft >= 60) {
      localHourLeft ++;
      localMinLeft = localMinLeft - 60;
    }
    localHourLeft = localHourLeft + ((localHours) - hour());
    return new int[]{ localHourLeft, localMinLeft};
  }
}

int[] timeCalc(int prayerHour, int prayerMin, int startHour, int startMin, boolean fajr) { //Time calculation function (If you think im gonna bother explaining all the math you're insane)
  int minute = startMin, hour = startHour; 
  int localMinLeft = 0;
  int localHourLeft = 0;
  int localHours = prayerHour;
  if (localHours < 12) {
    println("here");
    localHours +=12;
  }
  if (fajr) { //If we're calculating Fajr do this (This is because calculating Fajr is a bit more involved than other prayers)
    if (hour == 0) {
      localMinLeft = 60 - minute;
      localHours --;
      localMinLeft += int(prayerMin);
      if (localMinLeft >= 60) {
        localHourLeft ++;
        localMinLeft = localMinLeft - 60;
      }
      localHourLeft += int(prayerHour);
    } else if (hour > 0 && hour < 5) {
      localMinLeft = 60 - minute;
      localHourLeft --;
      localMinLeft += int(prayerMin);
      if (localMinLeft >= 60) {
        localHourLeft ++;
        localMinLeft = localMinLeft - 60;
      }
      localHourLeft = localHourLeft + (int(prayerHour) - hour());
    } else {
      localMinLeft = 60 - minute;
      localHourLeft --;
      localMinLeft += int(prayerMin);
      if (localMinLeft >= 60) {
        localHourLeft ++;
        localMinLeft = localMinLeft - 60;
      }
      localHourLeft += 24 - hour;

      localHourLeft += int(prayerHour);
      if (localMinLeft >= 60) {
        localHourLeft ++;
        localMinLeft = localMinLeft - 60;
      }
    }
    return new int[]{ localHourLeft, localMinLeft};
  } else {//Otherwise proceed normally
    localMinLeft = 60 - minute;
    localHours --;
    localMinLeft += prayerMin;
    if (localMinLeft >= 60) {
      localHourLeft ++;
      localMinLeft = localMinLeft - 60;
    }
    localHourLeft = localHourLeft + ((localHours) - hour);
    return new int[]{ localHourLeft, localMinLeft};
  }
}

int returnGreaterThan(int input) {
  if (input < 12) {
    return input + 12;
  } else {
    return input;
  }
}
String return0Value(int input) {
  if (input < 10) {
    String toReturn = nf(input, 2);
    return toReturn;
  } else {
    return str(input);
  }
}
