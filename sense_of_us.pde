/*
2010 variables: http://api.census.gov/data/2010/sf1/variables.html
 ex: P0010001 (Total population 2010)
 2000 variables: http://api.census.gov/data/2000/sf1/variables.html
 ex: P001001 (Total population 2000)
 */

PShape usa;
PShape state;

int popTot2000 = 0;
int popTot2010 = 0;
int div;
int div2 = 0;
int num = 0;

int x = -250;
int y = -110;
String[] abbr;

PrintWriter page;

void setup() {
  size(1140, 700);
  /////Request the original data, GATHER
  String stateText2010[] = loadStrings("http://api.census.gov/data/2010/sf1?key=e8a63d6bac96233cd5c3cf2de348ed9882285b0a&get=PCT0050001,NAME&for=state:*"); 
  String stateText2000[] = loadStrings("http://api.census.gov/data/2000/sf1?key=e8a63d6bac96233cd5c3cf2de348ed9882285b0a&get=PCT005001,NAME&for=state:*"); 

  for (int i =0; i<stateText2000.length; i++) {
    String [] data0 = splitTokens(stateText2000[i], "[],\"");
    popTot2000 += int(data0[0]); 
    String [] data1 = splitTokens(stateText2010[i], "[],\"");
    popTot2010 += int(data1[0]);
  }

  drawMap();

  /////PARSE the data
  for (int i=1; i<52; i++) {
    String [] data2010 = splitTokens(stateText2010[i], "[],\"");
    String [] fornext = splitTokens(stateText2010[i+1], "[],\"");
    String [] forlast = splitTokens(stateText2010[i-1], "[],\"");
    String [] data2000 = splitTokens(stateText2000[i], "[],\"");

    String name = data2010[1];  //Alabama

    int pop2010 = int(data2010[0]); //4779736
    int pop2000 = int(data2000[0]); //4447100
    int popDiff = pop2010-pop2000; //332636
    float nationalp = ((((float)popTot2010-popTot2000)/popTot2000)*100);
    page = createWriter("website/"+name+".html"); 

    page.println("<html><head><title>"+name+"</title><link rel ='stylesheet' type = 'text/css' href = 'style1.css'></head>");
    page.println("<body><div id = 'title'><h1>Sense (of) US</h1> <div = 'data'><a id = 'linkhead' href = 'https://www.census.gov/data/developers/data-sets/decennial-census-data.html'>The Data</a></div></div>");
    page.println("<h2><a href= 'https://en.wikipedia.org/wiki/"+name+"'>"+name+"</a></h2>");
    page.println("<h3 style = 'text-decoration: underline;'>Did the total population of people of only Asian descent increase from 2000 to 2010?</h3>");



    if (popDiff>0) {
      float percentage = ((((float)pop2010-pop2000)/pop2000)*100);
      page.println("<p>Yes, the population increased from 2000 to 2010 by "+popDiff+" people, about "+percentage+"%.</p>");
      if (nationalp > percentage) {
        page.println("<p> This percent change is less than the change in the national average, which is "+nationalp+"%.</p>");
      } else if (percentage > nationalp) {
        page.println("<p> This percent change is more than the change in the national average, which is "+nationalp+"%.</p>");
      }
    } else if (popDiff<0) {
      float percentage = ((((float)(popDiff*-1)/pop2000)*100));
      page.println("<p>No, the population decreased from 2000 to 2010 by "+(popDiff*-1)+" people, about "+percentage+"%.</p>");
    } else {
      page.println("<p>The population did not change from 2000 to 2010 from "+pop2010+" people.</p>");
    }



    page.println("<div id= 'footer'>");
    if (i<51) {
      page.println("<a id = 'next' href = '"+fornext[1]+".html'>"+fornext[1]+"--> </a></p>");
    }

    page.println("<a id = 'index' href = 'index.html'>Index</a></p>");


    if (i>1) {
      page.println("<center><a id = 'last' href = '"+forlast[1]+".html'> <--"+forlast[1]+"</a></center></div>");
    } else {
      page.println("<center><p id = 'last'></p></center></div>");
    }

    {
      if (pop2010>1000000) {
        div = 5000;
        div2 = 250000;
      } else {
        div = 1000;
        div2 = 50000;
      }

      if (num< (popTot2000/50000)) {
        num =(popTot2000/50000);
      }

      if (num< (popTot2010/50000)) {
        num =(popTot2010/50000);
      }

      if (num< (pop2010/div)) {
        num =(popTot2010/div);
      }

      if (num< (pop2000/div)) {
        num =(popTot2000/div);
      }
    }

    page.println("<div id = 'entire' style = 'padding: 10px;'><figure><figcaption><h3>Change in Population for National and State Statistics</h3></figcaption>");
    page.println("<figcaption><h5 style = 'color: white;'>Blue: National Statistics, Pink: State Statistics</h5></figcaption>");
    page.println("<div class='chart' style = 'padding-top:15px;'>");
    page.println("<div class='barnational' style = 'width:"+((popTot2000/div2))+"; height='49';'> 2000: "+(popTot2000/50)+"</div>");
    page.println("<div class='barnational' style = 'width:"+((popTot2010/div2))+"; height='49';'> 2010: "+((popTot2010/50))+"</div>");
    page.println("<div class='barstate' style = 'width:"+((pop2000/div))+"; height='49';'> 2000: "+pop2000+"</div>");
    page.println("<div class='barstate' style = 'width:"+((pop2010/div))+"; height='49';'>  2010: "+pop2010+"</div>");
    page.println("</div></figure><div>");
    page.flush();
    page.close();
  }
  stateTable(popTot2000, popTot2010);
}

void stateTable(int popTot2000, int popTot2010) {
  page = createWriter("website/index.html"); 
  String stateNames[] = loadStrings("State_Names.txt");
  page.println("<html><head><title>Home</title><link rel ='stylesheet' type = 'text/css' href = 'style1.css'></head>");
  page.println("<body><div id ='title'><h1>Sense (of) US</h1><div><a id = 'linkhead' href = 'https://www.census.gov/data/developers/data-sets/decennial-census-data.html'>The Data </a></div></div>");
  page.println("<div><h3 style = 'text-decoration: underline; font-size: 28px;'>Did the total population of people of only Asian descent increase from 2000 to 2010?</h3></div>");
  page.println("<p>I looked at the change from 2000 to 2010 of people of only Asian descent.</p>");
  page.println("<p>Nationally, the population increased by about 43%, from "+popTot2000+" to "+popTot2010+".");
  page.println("<p>Thus, according to the national statistics, the answer to my question is yes. But what about state statistics?</p>");
  page.println("<table align ='center' width = '50%'>");
  for (int i = 0; i<stateNames.length; i+=4) {
    if (i<48) {
      page.println("<tr><td><a href = '"+stateNames[i]+".html'>"+stateNames[i]+"</a></td>");
      page.println("<td><a href = '"+stateNames[i+1]+".html'>"+stateNames[i+1]+"</a></td>");
      page.println("<td><a href = '"+stateNames[i+2]+".html'>"+stateNames[i+2]+"</a></td>");
      page.println("<td><a href = '"+stateNames[i+3]+".html'>"+stateNames[i+3]+"</a></td></tr>");
    } else if (i==48) {
      page.println("<tr><td><a href = '"+stateNames[i]+".html'>"+stateNames[i]+"</a></td>");
      page.println("<td><a href = '"+stateNames[i+1]+".html'>"+stateNames[i+1]+"</a></td>");
      page.println("<td><a href = '"+stateNames[i+2]+".html'>"+stateNames[i+2]+"</a></td>");
      page.println("<td></td></tr>");
    }
  }
  page.println("<div><img src='map.png'/></div>");
  page.println("</body></html>");
  page.flush();
  page.close();
}


void drawMap() {
  abbr = loadStrings("State_Abbreviations.txt");
  usa = loadShape("usa-wikipedia.svg");
  background(#022B3A);

  String stateText2010[] = loadStrings("http://api.census.gov/data/2010/sf1?key=e8a63d6bac96233cd5c3cf2de348ed9882285b0a&get=PCT0050001,NAME&for=state:*"); 
  String stateText2000[] = loadStrings("http://api.census.gov/data/2000/sf1?key=e8a63d6bac96233cd5c3cf2de348ed9882285b0a&get=PCT005001,NAME&for=state:*"); 

  shape(usa, x, y);

  //data for map values
  for (int i =1; i<52; i++) {
    //the data
    String [] data2010 = splitTokens(stateText2010[i], "[],\"");
    String [] data2000 = splitTokens(stateText2000[i], "[],\"");

    int pop2010 = int(data2010[0]);
    int pop2000 = int(data2000[0]);

    state = usa.getChild(abbr[i-1]);
    state.disableStyle();

    for (int f = 0; f<256; f++) {
      fill(256-f);
      rect(800+f, 650, 2, 10);
    }
    fill(255);
    textSize(20);
    text("0%", 770, 660);
    text("115%", 1060, 660);

    int diff  = (pop2010-pop2000);
    if (diff<0) {
      diff*=-1;
    }

    float pcolor = map((((float)diff/pop2000)*100), 0, 116, 255, 0);
    fill(pcolor);
    noStroke();
    shape(state, x, y);
  }
  save("website/map.png");
}  