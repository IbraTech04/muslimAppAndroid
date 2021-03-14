import cassette.audiofiles.*;
import java.util.Calendar; //Import Calendar Functions
Calendar cal = Calendar.getInstance(); //Get calendar date
SoundFile athan; //Define Sound Varible
CompassManager compass;
PFont font; //Define Font  variable
PImage home, prayer, img, compasss; //Define image varibles
String calDate = ""; //Varible which holds the date
int day = day(), mon = month(), lineNum, hourLeft, minLeft, nextPrayerMin, nextPrayerHour, date = cal.get(Calendar.DAY_OF_WEEK), screenNumber = 1;
boolean fajrStat;
String[] week = {"", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}, months = {"", "January", "February", "March", "April", "May", "June", "July", "Auguest", "September", "October", "November", "December"}, times;
String fajrHour, fajrMinute, duhurHour, duhurMinute, asrHour, asrMinute, maghribHour, maghribMinute, ishaHour, ishaMinute, fajrHourNext, fajrMinuteNext, nextPrayer; //Varibles which hold prayer times
String prevPrayer;
boolean athanStat = false;
float direction;
void directionEvent(float newDirection) {
  direction = newDirection;
}

void setup() { //Setup Function
  compass = new CompassManager(this);
  background(0); //Setting Background
  textSize(100); //Set text size
  textAlign(CENTER);
  text("TM Muslim V2.5", width/2, height/2); //Loading Text
  times = loadStrings("Annual Prayers.txt"); //Load the file with all the prayer times
  fullScreen();
  orientation(PORTRAIT);
  noStroke();
  font = createFont("Product Sans Bold.ttf", 100); //Load the font
  home = loadImage("mosque.png"); //Load the images
  compasss = loadImage("compass.png"); //Load the images
  prayer = loadImage("Clock.png");
  img = loadImage("CMPS.png");
  athan = new SoundFile(this, "Athan1.wav"); //Loading the Athan sound
  loadTimes(); //Load the prayer times 
  delay(1000); //Delay which allows the user to read the loading text
}
void draw() { //Draw function
  playAthan();
  if (screenNumber == 0) {   //if statement which changes between the screens
  } else if (screenNumber == 1) {
    mainScreen();
  } else if (screenNumber == 2) {
    prayerList();
  } else if (screenNumber == 3) {
    qiblaDraw();
  }
}
void mainScreen() { //The main screen function that draws the home screen
  calDate = "";
  date();
  background(0);
  fill(43, 88, 12);
  rect(0, height -  height*0.102986612, width, height); //These two are the two rectangles on the top and bottom
  rect(0, 0, width, height*0.102986612);
  fill(255);
  textFont(font, 50); //Setting Text Font
  textAlign(CENTER);
  text("TM Muslim Home", width/2, height*0.0494444444 + 25); //Top Text
  imageMode(CENTER); //Setting the image mode to Center
  image(home, height*0.102986612/2, height - height*0.102986612/2, height*0.102986612/2, height*0.102986612/2); //Icons for switching Screens
  image(prayer, width - height*0.102986612/2, height - height*0.102986612/2, height*0.102986612/2, height*0.102986612/2);
  image(compasss, width/2, height - height*0.102986612/2, height*0.102986612/2, height*0.102986612/2);
  textFont(font, 40);
  text(calDate, width/2, height/2-155); //Drawing hte date
  textFont(font, 150);
  //Calculating current time
  int hour = hour();
  if (hour > 12) {
    hour -= 12; //Convert to 12-hour if necissary
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
  textFont(font, 40);
  checkPrayer(); //Check which prayer is next
  timeCalc(nextPrayerHour, nextPrayerMin, fajrStat); //Calculate time until next prayer
  if (athanStat) {
    text("Current Prayer: " + prevPrayer, width/2, height/2+55); //Draw the current prayer
  } else {
    text("Next Prayer: " + nextPrayer, width/2, height/2+55); //Draw the next prayer
    textFont(font, 40);
    text("At: " + nextPrayerHour + ":" + nextPrayerMinS, width/2, height/2+95); //Draw next prayer's time
    text("(-" + hourLeft + ":" + minLeft + ")", width/2, height/2+140); //Draw how much time is left
  }
}

void qiblaDraw() {
  background(0);
  fill(43, 88, 12);
  rect(0, height -  height*0.102986612, width, height); //Rectangles at top and bottom
  rect(0, 0, width, height*0.102986612);
  fill(255);
  textFont(font, 50);
  textAlign(CENTER);
  text("TM Muslim Qibla Locator", width/2, height*0.0494444444 + 25); //Top text
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
  rect(0, height -  height*0.102986612, width, height); //Rectangles at top and bottom
  rect(0, 0, width, height*0.102986612);
  fill(255);
  textFont(font, 50);
  textAlign(CENTER);
  text("TM Muslim Prayer List", width/2, height*0.0494444444 + 25); //Top text
  imageMode(CENTER);
  image(home, height*0.102986612/2, height - height*0.102986612/2, height*0.102986612/2, height*0.102986612/2); //Icons for switching Screens
  image(prayer, width - height*0.102986612/2, height - height*0.102986612/2, height*0.102986612/2, height*0.102986612/2);
  image(compasss, width/2, height - height*0.102986612/2, height*0.102986612/2, height*0.102986612/2);
  textAlign(CENTER);
  textFont(font, 55);
  text("Prayer Times:", width/2, height/2-225);
  textFont(font, 55);
  if (nextPrayer.equals("Fajr")) {
    fill(50, 130, 184);
  } else if (prevPrayer.equals("Fajr") && athanStat) {
    fill(128, 0, 0);
  } else {
    fill(255);
  }
  text("Fajr: " + fajrHour + ":" + fajrMinute, width/2, height/2-105); //Drawing Prayer times
  if (nextPrayer.equals("Duhur")) {
    fill(50, 130, 184);
  } else if (prevPrayer.equals("Duhur") && athanStat) {
    fill(128, 0, 0);
  } else {
    fill(255);
  }
  text("Duhur: " + duhurHour + ":" + duhurMinute, width/2, height/2-52);
  if (nextPrayer.equals("Asr")) {
    fill(50, 130, 184);
  } else if (prevPrayer.equals("Asr") && athanStat) {
    fill(128, 0, 0);
  } else {
    fill(255);
  }
  text("Asr: " + asrHour + ":" + asrMinute, width/2, height/2);
  if (nextPrayer.equals("Maghrib")) {
    fill(50, 130, 184);
  } else if (prevPrayer.equals("Maghrib") && athanStat) {
    fill(128, 0, 0);
  } else {
    fill(255);
  }
  text("Maghrib: " + maghribHour + ":" + maghribMinute, width/2, height/2+52);
  if (nextPrayer.equals("Isha")) {
    fill(50, 130, 184);
  } else if (prevPrayer.equals("Isha") && athanStat) {
    fill(128, 0, 0);
  } else {
    fill(255);
  }
  text("Isha: " + ishaHour + ":" + ishaMinute, width/2, height/2+105);
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
    screenNumber = 1;
  } else if (mouseY >= height -  height*0.102986612 && mouseX >=width - height*0.102986612) {
    screenNumber = 2;
  } else if (mouseY >= height -  height*0.102986612 && mouseX <= width/2 + height*0.102986612 && mouseX >= width/2 - height*0.102986612) {
    screenNumber = 3;
  }
}
void checkPrayer() { //Function which checks which prayer is next by using LOTS AND LOTS OF MATH (Not even gonna bother explaining how)
  if (hour() > int(ishaHour) + 12 || hour() <= int(fajrHour)) {
    nextPrayer = "Fajr";
    prevPrayer = "Isha";
    fajrStat = true;
    nextPrayerHour = int(fajrHour);
    nextPrayerMin = int(fajrMinute);
    if (hour() == int(fajrHour)) {
      if (minute() < int(fajrMinute)) {
        nextPrayer = "Fajr";
        prevPrayer = "Isha";
        fajrStat = true;
        nextPrayerHour = int(fajrHour);
        nextPrayerMin = int(fajrMinute);
      } else {
        fajrStat = false;
        nextPrayer = "Duhur";
        prevPrayer = "Fajr";
        nextPrayerHour = int(duhurHour);
        nextPrayerMin = int(duhurMinute);
      }
    }
  } else if (hour() >= int(fajrHour) && hour() <= int(duhurHour)) {
    nextPrayer = "Duhur";
    prevPrayer = "Fajr";
    fajrStat = false;
    nextPrayerHour = int(duhurHour);
    nextPrayerMin = int(duhurMinute);
    if (hour() == int(duhurHour)) {
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
  } else if (hour() >= int(duhurHour) && hour() <= int(asrHour) + 12) {
    nextPrayer = "Asr";
    prevPrayer = "Duhur";
    fajrStat = false;
    nextPrayerHour = int(asrHour);
    nextPrayerMin = int(asrMinute);
    if (hour() == int(asrHour)) {
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
        fajrStat = false;
        nextPrayer = "Isha";
        prevPrayer = "Maghrib";
        nextPrayerHour = int(ishaHour);
        nextPrayerMin = int(ishaMinute);
      }
    }
  } else if (hour() >= int(maghribHour) + 12 && hour() <= int(ishaHour) + 12) {
    fajrStat = false;
    nextPrayerHour = int(ishaHour);
    nextPrayerMin = int(ishaMinute);
    nextPrayer = "Isha";
    prevPrayer = "Maghrib";
    if (hour() == int(ishaHour) + 12) {
      if (minute() < int(ishaMinute)) {
        fajrStat = false;
        nextPrayer = "Isha";
        prevPrayer = "Maghrib";
        nextPrayerHour = int(ishaHour);
        nextPrayerMin = int(ishaMinute);
      } else {
        fajrStat = true;
        nextPrayer = "Fajr";
        prevPrayer = "Isha";
        nextPrayerHour = int(fajrHour);
        nextPrayerMin = int(fajrMinute);
      }
    }
  }
}
void playAthan() { //Function which checks whether its time to play the athan, and does so
  int hour = hour();
  if (hour > 12) { //Convert to 12 hour time (if necissary)
    hour -= 12;
    println(hour);
  }
  if (!athanStat) { //If the Athan is not playing
    if (int(fajrHour) == hour && int(fajrMinute) == minute()) { //IF its fajr
      athan.play(); //Play athan
      athanStat = true;
    } else  if (int(duhurHour) == hour && int(duhurMinute) == minute()) { //If its duhur
      athanStat = true;
      athan.play(); //Play Athan
    } else  if (int(asrHour) == hour && int(asrMinute) == minute()) { //If its asr 
      athan.play(); //Play athan
      athanStat = true;
    } else  if (int(maghribHour) == hour && int(maghribMinute) == minute()) { //If its maghtib
      athan.play(); //Play Athan
      athanStat = true;
    } else  if (int(ishaHour) == hour && int(ishaMinute) == minute()) { //If its Isha
      athan.play(); //Play Athan
      athanStat = true;
    }
  } else {
    if (int(fajrHour) != hour && int(fajrMinute) != minute()) { //IF its fajr
      athanStat = false;
    } else  if (int(duhurHour) != hour && int(duhurMinute) != minute()) { //If its duhur
      athanStat = false;
    } else  if (int(asrHour) != hour && int(asrMinute) != minute()) { //If its asr 
      athanStat = false;
    } else  if (int(maghribHour) != hour && int(maghribMinute) != minute()) { //If its maghtib
      athanStat = false;
    } else  if (int(ishaHour) != hour && int(ishaMinute) != minute()) { //If its Isha
      athanStat = false;
    }
  }
}

void timeCalc(int prayerHour, int prayerMin, boolean fajr) { //Time calculation function (If you think im gonna bother explaining all the math you're insane)
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
      localMinLeft += int(fajrMinute);
      if (localMinLeft >= 60) {
        localHourLeft ++;
        localMinLeft = localMinLeft - 60;
      }
      localHourLeft += int(fajrHour);
    } else if (hour > 0 && hour < 5) {
      localMinLeft = 60 - minute;
      localHourLeft --;
      localMinLeft += int(fajrMinute);
      if (localMinLeft >= 60) {
        localHourLeft ++;
        localMinLeft = localMinLeft - 60;
      }
      localHourLeft = localHourLeft + (int(fajrHour) - hour());
    } else {
      localMinLeft = 60 - minute;
      localHourLeft --;
      localMinLeft += int(fajrMinuteNext);
      if (localMinLeft >= 60) {
        localHourLeft ++;
        localMinLeft = localMinLeft - 60;
      }
      localHourLeft += 24 - hour;

      localHourLeft += int(fajrHourNext);

      if (localMinLeft >= 60) {
        localHourLeft ++;
        localMinLeft = localMinLeft - 60;
      }
    }
    hourLeft = localHourLeft;
    minLeft = localMinLeft;
  } else {//Otherwise proceed normally
    localMinLeft = 60 - minute;
    localHours --;
    localMinLeft += prayerMin;
    if (localMinLeft >= 60) {
      localHourLeft ++;
      localMinLeft = localMinLeft - 60;
    }
    localHourLeft = localHourLeft + ((localHours) - hour());
    hourLeft = localHourLeft;
    minLeft = localMinLeft;
  }
}
