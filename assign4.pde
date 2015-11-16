
final int START=0;
final int PLAY=1;
final int END=2;
final int RESET=3;
final int ENEMY_RESET=4;

final int TEAM_A=1;
final int TEAM_B=2;
final int TEAM_C=3;


PImage start1;
PImage start2;
PImage end1;
PImage end2;
PImage bg1;
PImage bg2;
PImage enemy;
PImage fighter;
PImage hp;
PImage treasure;
PImage shoot;
PImage[] flame=new PImage[5];


int Up, Down, Left, Right;
int bgX=0;
int fighterX, fighterY;
int treasureX, treasureY;
int enemyX, enemyY;
int hpX;
int speed=5;
int enemySpeed=4;
int shootSpeed=-3;
int state, playState=1;
int[][] array1=new int[5][5];
int[][] flameX=new int[5][5];
int[][] flameY=new int[5][5];
float[][] count=new float [5][5];
boolean[] shootlimit=new boolean[5];
int[] shootX=new int[5];
int[] shootY=new int[5];
void setup () {

  size(640, 480) ;
  frameRate(50);
  start1=loadImage("img/start1.png");
  start2=loadImage("img/start2.png");
  bg1=loadImage("img/bg1.png");
  bg2=loadImage("img/bg2.png");
  end1=loadImage("img/end1.png");
  end2=loadImage("img/end2.png");
  enemy=loadImage("img/enemy.png");
  fighter=loadImage("img/fighter.png");
  hp=loadImage("img/hp.png");
  treasure=loadImage("img/treasure.png");
  shoot=loadImage("img/shoot.png");
  for (int i=1; i<=5; i++) {
    flame[i-1]=loadImage("img/flame"+i+".png");
  }
  for (int i=0; i<=4; i++) {
    shootlimit[i]=false;
  }
  for (int i=0; i<=4; i++) {
    for (int j=0; j<=4; j++) {
      count[i][j]=0;
    }
  }
  state=START;
}

void draw() {

  switch(state) {  

  case START:
    if (mouseX>=205&&mouseX<=455&&mouseY>=375&&mouseY<=415) {
      image(start1, 0, 0);
      if (mousePressed) {
        state=RESET;
      }
    } else
      image(start2, 0, 0);
    break;



  case RESET:
    //reset treasure position      
    treasureX=floor(random(0, 600));
    treasureY=floor(random(0, 440));
    //reset fighter position      
    fighterX=520;
    fighterY=240;
    hpX=20;
    state=ENEMY_RESET;
    break;

  case ENEMY_RESET:
    //reset enemy position      
    if (playState==TEAM_C) {
      enemyX=-160-60;
      enemyY=floor(random(60, 360));
      for (int i=0; i<=2; i++) {
        for (int j=0; j<=2; j+=2) {
          array1[2+i-j][4-i-j]=1;
        }
      }
      for (int i=0; i<=2; i++) {
        for (int j=0; j<=2; j+=2) {
          array1[2-i+j][4-i-j]=1;
        }
      }
    } else if (playState==TEAM_B) {
      enemyX=-60; 
      enemyY=floor(random(0, 340));
      for (int i=0; i<=4; i++) {
        array1[i][4-i]=1;
      }
    } else {
      enemyX=-60;
      enemyY=floor(random(0, 420));
      for (int i=0; i<=4; i++) {
        array1[i][0]=1;
      }
    }

    state=PLAY;
    break;  



  case PLAY:  
    background(0);
    image(bg1, bgX%1280-640, 0);
    image(bg2, (bgX+640)%1280-640, 0);

    image(fighter, fighterX, fighterY);
    image(treasure, treasureX, treasureY);
    //team    
    switch(playState) {
    case TEAM_A:
      for (int i=0; i<=4; i++) {
        if (enemyX<=(640+400)&&array1[i][0]==1)
          image(enemy, enemyX-i*80, enemyY);
      }
      enemyX+=enemySpeed;
      if (enemyX>(640+400)) {
        for (int i=0; i<=4; i++) {
          array1[i][0]=0;
        }
        playState=TEAM_B;
        state=ENEMY_RESET;
      }
      //judge enemy hit
      for (int i=0; i<=4; i++) {
        if (fighterX-(enemyX-i*80)<=55
          &&fighterX-(enemyX-i*80)>=-50
          &&fighterY-enemyY<=55
          &&fighterY-enemyY>=-50
          &&array1[i][0]==1)
        {
          array1[i][0]=2;
          flameX[i][0]=enemyX-i*80;
          flameY[i][0]=enemyY;
          hpX=hpX-20;
        }
        if (hpX<=0) {
          hpX=0;
          state=END;
        }
      }
      //shoot
      for (int n=0; n<=4; n++) {
        for (int i=0; i<=4; i++) {
          if (shootX[n]-(enemyX-i*80)<=55
            &&shootX[n]-(enemyX-i*80)>=-30
            &&shootY[n]-enemyY<=55
            &&shootY[n]-enemyY>=-27
            &&shootlimit[n]==true
            &&array1[i][0]==1
            )
          {
            array1[i][0]=2;
            flameX[i][0]=enemyX-i*80;
            flameY[i][0]=enemyY;
            shootlimit[n]=false;
          }
        }
      }
      for (int i=0; i<=4; i++) {

        if (array1[i][0]==2) {
          image(flame[int(count[i][0])], flameX[i][0], flameY[i][0]);
          count[i][0]+=0.2;
        }
        if (count[i][0]>=4) {
          array1[i][0]=0;
          count[i][0]=0;
        }
      }

      break;

    case TEAM_B:
      for (int i=0; i<=4; i++) {

        if (enemyX<=(640+400)&&array1[i][4-i]==1)
          image(enemy, enemyX-i*80, (enemyY+i*20));
      }
      enemyX+=enemySpeed;
      if (enemyX>(640+400)) {
        for (int i=0; i<=4; i++) {
          array1[i][4-i]=0;
        }
        playState=TEAM_C;
        state=ENEMY_RESET;
      }
      //judge enemy hit
      for (int i=0; i<=4; i++) {
        if (fighterX-(enemyX-i*80)<=55
          &&fighterX-(enemyX-i*80)>=-50
          &&fighterY-(enemyY+i*20)<=55
          &&fighterY-(enemyY+i*20)>=-50
          &&array1[i][4-i]==1) {
          array1[i][4-i]=2;
          flameX[i][4-i]=enemyX-i*80;
          flameY[i][4-i]=enemyY+i*20;
          hpX=hpX-20;
          if (hpX<=0) {
            hpX=0;
            state=END;
          }
        }
      }
      //shoot
      for (int n=0; n<=4; n++) {
        for (int i=0; i<=4; i++) {
          if (shootX[n]-(enemyX-i*80)<=55
            &&shootX[n]-(enemyX-i*80)>=-30
            &&shootY[n]-(enemyY+i*20)<=55
            &&shootY[n]-(enemyY+i*20)>=-27
            &&shootlimit[n]==true
            &&array1[i][4-i]==1
            )
          {
            array1[i][4-i]=2;
            flameX[i][4-i]=enemyX-i*80;
            flameY[i][4-i]=enemyY+i*20;
            shootlimit[n]=false;
          }
        }
      }
      //animation flame
      for (int i=0; i<=4; i++) {

        if (array1[i][4-i]==2) {
          image(flame[int(count[i][4-i])], flameX[i][4-i], flameY[i][4-i]);
          count[i][4-i]+=0.2;
        }
        if (count[i][4-i]>=4) {
          array1[i][4-i]=0;
          count[i][4-i]=0;
        }
      }

      break;

    case TEAM_C:
      for (int i=0; i<=2; i++) {
        for (int j=0; j<=2; j+=2) {
          if (enemyX<=(640+160)&&array1[(2+i-j)][4-i-j]==1) {
            image(enemy, enemyX-(+i-j)*80, (enemyY+(2-i-j)*20));
          }
        }
      }
      for (int i=0; i<=2; i++) {
        for (int j=0; j<=2; j+=2) {
          if (enemyX<=(640+160)&&array1[(2-i+j)][4-i-j]==1) {
            image(enemy, enemyX-(-i+j)*80, (enemyY+(2-i-j)*20));
          }
        }
      }
      enemyX+=enemySpeed;

      //judge enemy hit         
      for (int i=0; i<=2; i++) {
        for (int j=0; j<=2; j+=2) {
          if (fighterX-(enemyX-(i-j)*80)<=55
            &&fighterX-(enemyX-(i-j)*80)>=-50
            &&fighterY-(enemyY+(2-i-j)*20)<=55
            &&fighterY-(enemyY+(2-i-j)*20)>=-50
            &&array1[2+i-j][4-i-j]==1) {
            array1[2+i-j][4-i-j]=2;
            flameX[2+i-j][4-i-j]=enemyX-(i-j)*80;
            flameY[2+i-j][4-i-j]=enemyY+(2-i-j)*20;
            hpX=hpX-20;
            if (hpX<=0) {
              hpX=0;
              state=END;
            }
          }
        }
      }
      for (int i=0; i<=2; i++) {
        for (int j=0; j<=2; j+=2) {
          if (fighterX-(enemyX-(-i+j)*80)<=55
            &&fighterX-(enemyX-(-i+j)*80)>=-50
            &&fighterY-(enemyY+(2-i-j)*20)<=55
            &&fighterY-(enemyY+(2-i-j)*20)>=-50
            &&array1[2-i+j][4-i-j]==1) 
          {
            array1[2-i+j][4-i-j]=2;
            flameX[2-i+j][4-i-j]=enemyX-(-i+j)*80;
            flameY[2-i+j][4-i-j]=enemyY+(2-i-j)*20;
            hpX=hpX-20;
            if (hpX<=0) {
              hpX=0;
              state=END;
            }
          }
        }
      }

      for (int n=0; n<=4; n++) {
        for (int i=0; i<=2; i++) {
          for (int j=0; j<=2; j+=2) {
            if (shootX[n]-(enemyX-(i-j)*80)<=55
              &&shootX[n]-(enemyX-(i-j)*80)>=-30
              &&shootY[n]-(enemyY+(2-i-j)*20)<=55
              &&shootY[n]-(enemyY+(2-i-j)*20)>=-27
              &&array1[2+i-j][4-i-j]==1
              &&shootlimit[n]==true) 
            {
              array1[2+i-j][4-i-j]=2;
              flameX[2+i-j][4-i-j]=enemyX-(i-j)*80;
              flameY[2+i-j][4-i-j]=enemyY+(2-i-j)*20;
              shootlimit[n]=false;
            }
          }
        }
        for (int i=0; i<=2; i++) {
          for (int j=0; j<=2; j+=2) {
            if (shootX[n]-(enemyX-(-i+j)*80)<=55
              &&shootX[n]-(enemyX-(-i+j)*80)>=-50
              &&shootY[n]-(enemyY+(2-i-j)*20)<=55
              &&shootY[n]-(enemyY+(2-i-j)*20)>=-50
              &&array1[2-i+j][4-i-j]==1
              &&shootlimit[n]==true) 
            {
              array1[2-i+j][4-i-j]=2;
              flameX[2-i+j][4-i-j]=enemyX-(-i+j)*80;
              flameY[2-i+j][4-i-j]=enemyY+(2-i-j)*20;
              shootlimit[n]=false;
            }
          }
        }
      }


      for (int i=0; i<=2; i++) {
        for (int j=0; j<=2; j+=2) {
          if (array1[2+i-j][4-i-j]==2) {
            image(flame[int(count[2+i-j][4-i-j])], flameX[2+i-j][4-i-j], flameY[2+i-j][4-i-j]);
            if (i==1)
              count[2+i-j][4-i-j]+=0.2;
            else
              count[2+i-j][4-i-j]+=0.1;
          }
          if (count[2+i-j][4-i-j]>=4) {
            array1[2+i-j][4-i-j]=0;
            count[2+i-j][4-i-j]=0;
          }
        }
      }

      for (int i=0; i<=2; i++) {
        for (int j=0; j<=2; j+=2) {
          if (array1[2-i+j][4-i-j]==2) {
            image(flame[int(count[2-i+j][4-i-j])], flameX[2-i+j][4-i-j], flameY[2-i+j][4-i-j]);
            if (i==1)
              count[2-i+j][4-i-j]+=0.2;
            else
              count[2-i+j][4-i-j]+=0.1;
          }
          if (count[2-i+j][4-i-j]>=4) {
            array1[2-i+j][4-i-j]=0;
            count[2-i+j][4-i-j]=0;
          }
        }
      }

      if (enemyX>(640+160)) {
        for (int i=0; i<=2; i++) {
          for (int j=0; j<=2; j+=2) {
            array1[2+i-j][4-i-j]=0;
          }
        }
        for (int i=0; i<=2; i++) {
          for (int j=0; j<=2; j+=2) {
            array1[2-i+j][4-i-j]=0;
          }
        } 
        
        playState=TEAM_A;
        state=ENEMY_RESET;
        
      }
      break;
    }




    for (int i=0; i<=4; i++) {
      if (shootlimit[i]==true) {
        image(shoot, shootX[i], shootY[i]);
        shootX[i]+=shootSpeed;
      }
      if (shootX[i]<=-30)
        shootlimit[i]=false;
    }


    //hp
    fill(#ff0000);
    stroke(#ff0000);
    rect(20, 18, hpX*2, 20);
    image(hp, 15, 15);

    fill(#ffffff);
    textAlign(RIGHT, BOTTOM);
    text(hpX+" /100", 224, 45);
    bgX++;

    //judge treasure eaten
    if (fighterX-treasureX<=40&&fighterX-treasureX>=-50&&fighterY-treasureY<=40&&fighterY-treasureY>=-50) {
      treasureX=floor(random(0, 600));
      treasureY=floor(random(0, 440));
      hpX=hpX+10;
      if (hpX>=100)
        hpX=100;
    }


    /*
  //enemy move
     enemyX=(60+(enemyX+enemySpeed))%700-60; 
     enemyY=enemyY-(enemyY-fighterY)*(random(2,4)/150);
     //enemy loop 
     if(enemyX>=638)
     enemyY=floor(random(0,430));
     */
    //fighter move    
    fighterX=fighterX-int(fighterX>0)*Left*speed+int(fighterX<590)*Right*speed;
    fighterY=fighterY-int(fighterY>0)*Up*speed+int(fighterY<430)*Down*speed;
    break;


  case END:
    if (mouseX>=205&&mouseX<=436&&mouseY>=305&&mouseY<=350) {
      image(end1, 0, 0);
      if (mousePressed) {
        for (int i=0; i<=4; i++) {
          shootlimit[i]=false;
        }
        state=RESET;
        playState=TEAM_A;
      }
    } else
      image(end2, 0, 0);
    break;
  }
}


void keyPressed() {
  if (key==' ') {
    for (int i=0; i<=4; i++) {
      if (shootlimit[i]==false) {
        shootlimit[i]=true;
        shootX[i]=fighterX;
        shootY[i]=fighterY+10;
        break;
      }
    }
  }
  if (key==CODED) {

    switch(keyCode) {
    case UP:
      Up=1;
      break;
    case DOWN:
      Down=1;
      break;
    case LEFT:
      Left=1;
      break;
    case RIGHT:
      Right=1;
      break;
    }
  }
}

void keyReleased() {
  if (key==CODED) {
    switch(keyCode) {
    case UP:
      Up=0;
      break;
    case DOWN:
      Down=0;
      break;
    case LEFT:
      Left=0;
      break;
    case RIGHT:
      Right=0;
      break;
    }
  }
}
