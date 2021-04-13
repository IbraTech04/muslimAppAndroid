void onTime (Calendar cal) {
  background(0);
  String[] times = split(loadTimesOnTime(cal.get(Calendar.DAY_OF_MONTH), months[cal.get(Calendar.MONTH) + 1]), '/');
  fill(43, 88, 12);
  rect(0, height -  height*0.102986612, width, height); //These two are the two rectangles on the top and bottom
  rect(0, 0, width, height*0.102986612);
  fill(255);
  image(home, height*0.102986612/2, height - height*0.102986612/2, height*0.102986612/2, height*0.102986612/2); //Icons for switching Screens
  image(compasss, width/2, height - height*0.102986612/2, height*0.102986612/2, height*0.102986612/2);
  textFont(font, 25*displayDensity); //Setting Text Font
  textAlign(CENTER);
  text("TMMuslim DayCheck\u2122", width/2, height*0.0494444444 + 25); //Top Text
  text("Prayer Times for: " + months[cal.get(Calendar.MONTH) + 1] + " " + cal.get(Calendar.DAY_OF_MONTH), width/2, height/2-225);
  textFont(font, 21*displayDensity);
  text("Fajr: " + times[0], width/2, sizeDeteccH(855, height)); //Drawing Prayer times
  text("Duhur: " + times[1], width/2, sizeDeteccH(908, height));
  text("Asr: " + times[2], width/2, height/2);
  text("Maghrib: " + times[3], width/2, sizeDeteccH(1012, height));
  text("Isha: " + times[4], width/2, sizeDeteccH(1065, height));
}

String loadTimesOnTime(int day, String month) {
  String num = str(day);
  if (day < 10) {
    num = nf(day, 2); //Add 0 before number if necissary
  }
  String date = num + month;
  String fajr = "";
  String duhur = "";
  String asr = "";
  String maghrib = "";
  String ishaa = "";
  for (int i = 0; i < times.length; i++) { //Until you find the entry with todays date continue the loop
    String toCheck = times[i];
    if (toCheck.equals(date)) { //Once you've found todays date, import all the prayer data
      fajr = times[i+1];
      duhur = times[i+2];
      asr = times[i+3];
      maghrib = times[i+4];
      ishaa = times[i+5];
      break; //Break the loop (stop the loop)
    }
  }
  String toReturn = fajr + "/" + duhur + "/" + asr + "/" + maghrib + "/" + ishaa;
  return toReturn;
}
