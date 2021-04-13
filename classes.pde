class WeekRect {
  int id;
  String day;
  String dayPt2;
  String P1;
  String P2;
  boolean noSchool;
  Calendar cal = Calendar.getInstance();
  public WeekRect(String[] args, int newID, int dayOfYear) {
    day = args[0];
    dayPt2 = args[1];
    P1 = split(args[2], '/')[0];
    P2 = split(args[2], '/')[1];

    cal.set(Calendar.DAY_OF_YEAR, dayOfYear);
    id = newID;
  }

  public void drawRect() {
    fill(43, 88, 12);
    rect(10, 10, width-20, 180, 10, 10, 10, 10);
    fill(255);
    textAlign(LEFT);
    textFont(font, 50); //Setting Text Font
    text(day + "\n" + dayPt2, 20, 70);
    textFont(font, 50); //Setting Text Font
    text("Fajr: " + P1, 335, 85);
    text("Maghrib: " + P2, 335, 165);
  }
  void checkPos(float x, float y) {
    if (x >= 10 && x <= width-20 && y >= ((id*200) + (height*0.145833333)) + transScale && y <= ((id*200) + (height*0.145833333) +transScale) + 180) {
      if (y < height -  height*0.102986612) {
        screenNumber = 4;
        event = cal;
      }
    }
  }
}
