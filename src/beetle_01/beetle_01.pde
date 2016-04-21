JSONArray json;
JSONObject jsonObj;

class Weather {
  private int pm25;
  private int pm10;
  private int o3;
  private int no2;
  private int so2;
  private int co;
  private int temp;
  private String date;

  public Weather() {
  }

  public Weather(int pm25, int pm10, int o3, 
    int no2, int so2, int co, int temp, String date) {
    this.pm25 = pm25;
    this.pm10 = pm10;
    this.o3 = o3;
    this.no2 = no2;
    this.so2 = so2;
    this.co = co;
    this.temp = temp;
    this.date = date;
  }

  public int get_pm25() { 
    return pm25;
  }
  public int get_pm10() { 
    return pm10;
  }
  public int get_o3() { 
    return o3;
  }
  public int get_no2() { 
    return no2;
  }
  public int get_so2() { 
    return so2;
  }
  public int get_co() { 
    return co;
  }
  public int get_temp() { 
    return temp;
  }
  public String get_date() {
    return date;
  }
  

  public void set_pm25(int pm25) { 
    this.pm25 = pm25;
  }
  public void set_pm10(int pm10) { 
    this.pm10 = pm10;
  }
  public void set_o3(int o3) { 
    this.o3 = o3;
  }
  public void set_no2(int no2) { 
    this.no2 = no2;
  }
  public void set_so2(int so2) { 
    this.so2 = so2;
  }
  public void set_co(int co) { 
    this.co = co;
  }
  public void set_temp(int temp) { 
    this.temp = temp;
  }
  
  public void set_date(String date) {
    this.date = date;
  }

  public String toString() {
    return "Date: " + date + "   pm25:" + pm25 + " pm10:" + pm10 + " no2:"
      + no2 + " o3:" + o3 + " so2:" + so2 + " co:"
      + co + " temp:" + temp;
  }
};

Weather getWeaher(String city) {
  Weather we = new Weather();
  String url = "http://feed.aqicn.org/feed/" + city + "/en/feed.v1.json";
  try {
    jsonObj = loadJSONObject(url);
    try {
      we.set_date((jsonObj.getJSONObject("iaqi").getJSONObject("pm25").getString("date")));
    } catch (Exception e) {}
    try {
      we.set_pm25((jsonObj.getJSONObject("iaqi").getJSONObject("pm25").getInt("val")));
    } catch (Exception e) {}
    try {
      we.set_pm10((jsonObj.getJSONObject("iaqi").getJSONObject("pm10").getInt("val")));
    } catch (Exception e) {}
    try {
    we.set_no2((jsonObj.getJSONObject("iaqi").getJSONObject("no2").getInt("val")));
    } catch (Exception e) {}
    try {
      we.set_o3((jsonObj.getJSONObject("iaqi").getJSONObject("o3").getInt("val")));
    } catch (Exception e) {}
    try {
      we.set_so2((jsonObj.getJSONObject("iaqi").getJSONObject("so2").getInt("val")));
    } catch (Exception e) {}
    try {
      we.set_co((jsonObj.getJSONObject("iaqi").getJSONObject("co").getInt("val")));
    } catch (Exception e) {}
    try {
      we.set_temp((jsonObj.getJSONObject("weather").getInt("tempnow")));
    } catch (Exception e) {}
  } catch(Exception e) {}
  return we;
}

//taibei, aomen, xianggang
/*
"beijing", "shanghai", "tianjin", "chongqing", "haerbin", "changchun", "shenyang",
 "huhehaote", "shijiazhuang", "wulumuqi", "lanzhou", "xining", "xian","yinchuan", "zhengzhou", "jinan",
 "taiyuan", "wuhan", "changsha", "nanjing", "chengdu", "guiyang", "kunming", "nanning","hangzhou", 
 "guangzhou", "fuzhou", "haikou"
 */
void printAllCities() {
  String [] cities = {"beijing", "shanghai", "tianjin", "chongqing", "haerbin", "changchun", "shenyang",
 "huhehaote", "shijiazhuang", "wulumuqi", "lanzhou", "xining", "xian","yinchuan", "zhengzhou", "jinan",
 "taiyuan", "wuhan", "changsha", "nanjing", "chengdu", "guiyang", "kunming", "nanning","hangzhou", 
 "guangzhou", "fuzhou", "haikou"};
  for (int i=0; i!=cities.length; ++i) {
    Weather we = getWeaher(cities[i]);
    println(cities[i] + " " + we.toString());
  }
}

class Color {
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
  } else if (pm < 120) {
    clr = new Color(254, 249, 51);
  } else if (pm < 199) {
    clr = new Color(248, 42, 25);
  } else if (pm < 399) {
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
  } else if (pm < 20) {
    clr = new Color(231, 158, 142);
  } else if (pm < 30) {
    clr = new Color(226, 155, 144);
  } else if (pm < 40) {
    clr = new Color(193, 132, 122);
  } else if (pm < 50) {
    clr = new Color(168, 121, 132);
  } else if (pm < 60) {
    clr = new Color(133, 107, 135);
  } else if (pm < 70) {
    clr = new Color(113, 100, 132);
  } else {
    clr = new Color(108, 96, 134);
  }
  return clr;
}

ArrayList<Color> colors = new ArrayList<Color>();

void setup()
{
  size(200, 200);
  background(255);
  stroke(255);
  frameRate(12);


  printAllCities();
}

void draw() {
}