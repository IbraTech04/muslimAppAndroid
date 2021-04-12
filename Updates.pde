import android.content.Intent;
import android.net.Uri;
import android.os.Environment;
import android.content.Context;
import processing.core.PApplet;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.graphics.Color;
import android.widget.TextView;
import android.view.Gravity;
TextView msg;
int msgId;

void checkForUpdates() {
  nversionFromServer = loadStrings("https://raw.githubusercontent.com/IbraTech04/updateServer/master/muslimAppVers.txt");
  if (isGreater(nversionFromServer[0])) {
    if (nversionFromServer[1].equals("URGENT")) {
      urgentUpdate();
    } else {
      update();
    }
  }
}

void doNothing(boolean granted) {
}

void downloadFile(boolean granted) {
}

byte[] test;
void beginUpdate() {
  if (updateState == 0) {
    textAlign(CENTER);
    textFont(font, 25*displayDensity); //Setting Text Font
    text("Updating TMMuslim", width/2, height/2-26*displayDensity);
    textFont(font, 12*displayDensity); //Setting Text Font
    text("Stage One: Downloading Update Files", width/2, height/2);
    text("Please do not close this \nwindow until this process is complete \nNote: TMMuslim updates may take more time than \nother apps", width/2, height/2+13*displayDensity);
    updateState++;
  } else if (updateState == 1) {
    test = loadBytes("https://github.com/IbraTech04/updateServer/raw/master/muslimappandroid_release_signed_aligned.apk");
    updateState++;
  } else if (updateState == 2) {
    background(0);
    textFont(font, 25*displayDensity); //Setting Text Font
    text("Updating TMMuslim", width/2, height/2-26*displayDensity);
    textFont(font, 12*displayDensity); //Setting Text Font
    text("Stage Two: Applying Update", width/2, height/2);
    text("Please do not close this \nwindow until this process is complete", width/2, height/2+26*displayDensity);
    updateState++;
  } else if (updateState == 3) {
    File theDir = new File(Environment.getExternalStorageDirectory() + "/TMMuslim");
    if (!theDir.exists()) {
      theDir.mkdirs();
    }
    saveBytes(Environment.getExternalStorageDirectory() + "/TMMuslim/muslimApp" + nversionFromServer[0] + ".apk", test);
    delay(2000);
    updateState++;
  } else if (updateState == 4) {
    background(0);
    textFont(font, 12*displayDensity); //Setting Text Font
    text("File Downloaded. \nNavigate to Internal Storage > TMMuslim \nand select the latest APK", width/2, height/2+30);
    updateState++;
  } else if (updateState == 5) {
    delay(10000); 
    updateMode = false;
  }
}

void update() {
  act = this.getActivity();

  final TextView msg = new TextView(act); 
  msg.setBackgroundColor(Color.WHITE);
  msg.setTextSize(20);
  msg.setGravity(Gravity.CENTER_HORIZONTAL); 
  msg.setText("A new version is availible. Would you like to update?"); 
  act.runOnUiThread(new Runnable() {
    public void run() {
      AlertDialog.Builder builder = new AlertDialog.Builder(act);
      builder.setView(msg);
      builder.setTitle("Time to update!");
      builder.setPositiveButton("Yes Bleeze", 
        new DialogInterface.OnClickListener() {
        public void onClick(DialogInterface dialog, 
          int which) {
          //link("https://github.com/IbraTech04/timeTableGenAndroid/releases");
          updateMode = true;
        }
      }
      );
      builder.setNegativeButton("No sank you", 
        new DialogInterface.OnClickListener() {
        public void onClick(DialogInterface dialog, 
          int which) {
        }
      }
      )
      .show();
    }
  }
  );
}
void urgentUpdate() {
  act = this.getActivity();

  final TextView msg = new TextView(act); 
  msg.setBackgroundColor(Color.WHITE);
  msg.setTextSize(20);
  msg.setGravity(Gravity.CENTER_HORIZONTAL); 
  msg.setText("An urgent update is availible. We highly suggest you update"); 
  act.runOnUiThread(new Runnable() {
    public void run() {
      AlertDialog.Builder builder = new AlertDialog.Builder(act);
      builder.setView(msg);
      builder.setTitle("Urgent Update");
      builder.setPositiveButton("Jazak Allah Khair", 
        new DialogInterface.OnClickListener() {
        public void onClick(DialogInterface dialog, 
          int which) {
          //link("https://github.com/IbraTech04/timeTableGenAndroid/releases");
          updateMode = true;
        }
      }
      );
      builder.setNegativeButton("No thank you", 
        new DialogInterface.OnClickListener() {
        public void onClick(DialogInterface dialog, 
          int which) {
        }
      }
      )
      .show();
    }
  }
  );
}


boolean isGreater(String version) {
  String ver1 = ver + ".0.0";
  version = version + ".0.0";
  String[] ww = split(version, '.');
  String[] w = split(ver1, '.');
  println(version);
  try { 

    if (int(ww[0]) > int(w[0])) {
      return true;
    } else if (int(ww[1]) > int(w[1]) && int(ww[0]) == int(w[0])) {
      println("1");
      return true;
    } else if (int(ww[2]) > int(w[2]) && int(ww[1]) == int(w[1]) && int(ww[0]) == int(w[0])) {
      println("2");

      return true;
    }
  } 
  catch (Exception e) {
    println("here");
    e.printStackTrace();
    return true;
  }
  return false;
}
