JSONArray json;

class Color{
  public int r;
  public int g;
  public int b;
  
  public Color(int r, int g, int b) {
    this.r = r;
    this.g = g;
    this.b = b;
  }
};

Color getColor(int pm) {
  Color clr = null;
  if (pm < 60) {
    clr = new Color(54, 246, 45);
  } else if(pm < 120) {
    clr = new Color(254, 249, 51);
  } else if (pm < 199) {
    clr = new Color(248, 42, 25);
  } else if(pm < 399) {
    clr = new Color(123, 34, 131);
  } else {
    clr = new Color(96, 52, 6);
  }
  return clr;
}

Color getColorOfHumidity(int pm) {
  Color clr = null;
  if (pm < 10) {
    clr = new Color(231, 158, 142);
  } else if(pm < 20) {
    clr = new Color(231, 158, 142);
  } else if (pm < 30) {
    clr = new Color(226, 155, 144);
  } else if(pm < 40) {
    clr = new Color(193, 132, 122);
  } else if(pm < 50) {
    clr = new Color(168, 121, 132);
  } else if(pm < 60) {
    clr = new Color(133, 107, 135);
  } else if(pm < 70) {
    clr = new Color(113, 100, 132);
  } else {
    clr = new Color(108, 96, 134);
  }
  return clr;
}


void setup()
{
  size(200, 200);
  background(0);
  stroke(255);
  frameRate(12);

  //Use Jason Array to read the data in
  json = loadJSONArray("http://aqicn.org/publishingdata/json/");
  //Use for loop to go through each data set in the array
  for (int i = 0; i< json.size(); i++) {
    JSONObject dataSet = json.getJSONObject(i);
    String id = dataSet.getString("id");
    String name = dataSet.getString("cityName");

    //get pollution data (pollution data is another JSON array itself)
    JSONArray pol = dataSet.getJSONArray("pollutants");
    //background(255);
    
    for (int n = 0; n < pol.size (); n++) {
      JSONObject polData = pol.getJSONObject(n);
      String polType = polData.getString("pol");
      float polValue = polData.getFloat("value");

      println(id + "," + name + "," + polType + "," + polValue);
      if (polType.compareTo("PM2.5") == 0) {
        Color clr = getColor(int(polValue));
        fill(clr.r, clr.g, clr.b);
        rect(0,0,100,100);
      } else if (polType.compareTo("Ozone") == 0) {
        Color clr = getColor(int(polValue));
        fill(clr.r, clr.g, clr.b);
        rect(100,0,100,100);
      } else if (polType.compareTo("PM10") == 0) {
        Color clr = getColor(int(polValue));
        fill(clr.r, clr.g, clr.b);
        rect(0,100,100,100);
      } else if (polType.compareTo("Humidity") == 0) {
        Color clr = getColorOfHumidity(int(polValue));
        fill(clr.r, clr.g, clr.b);
        rect(100,100,100,100);
      }
    }
  }
}

void draw() {
}