PImage background1Img,background2Img,fighterImg,treasureImg,bloodImg,
enemyImg,start1Img,start2Img,end1Img,end2Img,flame1Img,flame2Img,flame3Img,
flame4Img,flame5Img,shootImg;

int x1;
int x2;
int x3,y3;//treasure
int x4;//blood
int x5;//enemy
float y5;//enemy
int x6,y6;//fighter
int fighterSpeed = 5;
float enemySpeed = floor(random(-8,8));
int gameState;
int GAME_START = 0;
int GAME_RUN  = 1;
int GAME_LOSE = 3;
int fighterStatus = 0;
boolean fighterUpPressed = false;
boolean fighterDownPressed = false;
boolean fighterLeftPressed = false;
boolean fighterRightPressed = false;

int enemyTeam1Y = 300;
int enemyTeam2Posy = 300;
int enemyTeam3Posy = 270;
int posTeam1X = -480;
int posTeam2X = -480;
int posTeam3X = -480;
boolean enemyTeam1 = true;
boolean enemyTeam2 = false;
boolean enemyTeam3 = false;
boolean[] deadOrNotT1 = {false,false,false,false,false};
boolean[] deadOrNotT2 = {false,false,false,false,false};
boolean[] deadOrNotT3 = {false,false,false,false,false,false,false,false};
boolean[] shootOrNotT1 = {false,false,false,false,false};

PImage[] flameImgs = { flame1Img, flame2Img, flame3Img, flame4Img, flame5Img };
int flameCounter = 0;
int picIndex = 0;
int fx = -800;//flame
float fy = -800;//flame
int timeE1 = 0;
int timeE2 = 0;
int timeE3 = 0;
int shootX = -200;
int shootY = -200;
int [] bX = {-100,-120,-140,-160,-180};
int [] bY = {-100,-100,-100,-100,100};
boolean canShoot = true;
int bx = -800;
int by = -800;
boolean shootBullet = true;

PFont ScoreText;//text
int score = 0;


void setup(){  
  size(640,480);
  start1Img = loadImage("img/start1.png");
  start2Img = loadImage("img/start2.png"); 
  background1Img = loadImage("img/bg1.png");
  background2Img = loadImage("img/bg2.png");
  fighterImg = loadImage("img/fighter.png");
  treasureImg = loadImage("img/treasure.png");
  bloodImg = loadImage("img/hp.png");
  enemyImg = loadImage("img/enemy.png");
  end1Img = loadImage("img/end1.png");
  end2Img = loadImage("img/end2.png");
  flameImgs[0] = loadImage("img/flame1.png");
  flameImgs[1] = loadImage("img/flame2.png");
  flameImgs[2] = loadImage("img/flame3.png");
  flameImgs[3] = loadImage("img/flame4.png");
  flameImgs[4] = loadImage("img/flame5.png");
  shootImg = loadImage("img/shoot.png");
  ScoreText = createFont("Arial",20);
  
  gameState = 0;

  x1 = 640;
  x2 = 0;
  x3 = floor(random(500));  
  y3 = floor(random(400));
  x4 = 20;
  x5 = 0;
  y5 = floor(random(400));
  x6 = 580;
  y6 = 240;

}

void draw(){
  //game start
  if(gameState == 0){
    image(start2Img,0,0);
  
    if(mouseX>1.0/3.0*width && mouseX<2.0/3.0*width && mouseY>3.0/4.0*height && mouseY<height){
      image(start1Img,0,0);
      
    if(mousePressed){
        gameState = 1;
      }
    }
  }    
  
  //game run  
  if (gameState == 1)  {   
    //scroll background 
    image(background1Img,x1-640,0);
    image(background2Img,x2-640,0);
    
    //text
    textFont(ScoreText,30);
    textAlign(LEFT);
    fill(255);
    text("Score：" + score ,10,450);
    
    // flame img constantly appear
    image( flameImgs[ picIndex ], fx, fy );
    flameCounter++;
                    
    if( flameCounter % 6 == 0 ){
        picIndex ++;
    }
                    
    if( picIndex >= flameImgs.length ){
        picIndex = 0;
    }    
  
    x1 = x1+1;
    x2 = x2+1;
    
    x1 = x1%1280;
    x2 = x2%1280;
      
    //fighter
    image(fighterImg,x6,y6);
      
    //treasure
    image(treasureImg,x3,y3);
    
    //blood
    noStroke();
    fill(255,0,0);
    rect(33,15,x4*1.94,15);//blood bar
    image(bloodImg,20,10);
    
    //three enemy team
    // enemy team1
    if(enemyTeam1 == true)
    {
        int[] enemyTeam1Xs = {0,1,2,3,4};
        int unitX1 = 70;
        
        for (int i = 0; i < 5; i++)
        {        
            int xPos = enemyTeam1Xs[i]*unitX1+posTeam1X;
            int yPos = enemyTeam1Y;
    
            if(deadOrNotT1[i] == false)
            {
                image(enemyImg, xPos, yPos);
            
                //detect fighter to enemy's distance
                if(isHit(xPos,yPos,enemyImg.width,enemyImg.height,x6,y6,fighterImg.width,fighterImg.height))
                { 
                    deadOrNotT1[i] = true;
                    x4 = x4-20;                        
                        
                    //flame pic position
                    fx = xPos;
                    fy = yPos;
                 }                 
            }
                
            if(timeE1 % 120 == 0)
            {
                fx = -800;
                fy = -800;
            }
                 
            timeE1++;              
        }
        
        if(posTeam1X > width) {
            posTeam1X = -480;
            enemyTeam1Y = floor(random(60,420));
                 
            for( int j = 0 ; j < 5 ; j++) {
                deadOrNotT1[j] = false;
            }
                 
            enemyTeam2 = true;
            enemyTeam1 = false;
        }
            
            
        //bullet meet enemyT1 
        for(int b = 0 ; b < bX.length; b++)
        {
           for(int e = 0 ; e < enemyTeam1Xs.length ; e++){
               if(deadOrNotT1[e] == false)
               {
                   int xPos = enemyTeam1Xs[e]*unitX1+posTeam1X;
                   int yPos = enemyTeam1Y;
               
                   if(isHit(xPos,yPos,enemyImg.width,enemyImg.height, bX[b],bY[b],shootImg.width,shootImg.height))
                   {
                      deadOrNotT1[e] = true;
                      fx = xPos;
                      fy = yPos;
                      bY[b] = -200;
                      
                      scoreChange();
                   }
                             
                   if( bX[b] <= 10)
                   {
                      bY[b] = -800;
                   }
               }
           }
        }
          posTeam1X+=5;
    }

    //enemy team2
      if(enemyTeam2 == true)
      {
        int[] enemyTeam2X = {0,1,2,3,4};
        float[] enemyTeam2Y = {0,-0.5,-1,-1.5,-2};
        int unitX2 = 70;
    
        for(int i = 0;i < 5; i++){          
            int xPos = enemyTeam2X[i]*unitX2+posTeam2X;
            float yPos = enemyTeam2Y[i]*unitX2+enemyTeam2Posy;
            
            if(deadOrNotT2[i] == false){
                      image(enemyImg, xPos, yPos);

                      if(isHit(x6,y6,fighterImg.width,fighterImg.height,xPos,(int)yPos,enemyImg.width,enemyImg.height))
                      {
                          deadOrNotT2[i] = true;
                          x4 = x4-20;
                          //flame pic position
                          fx = xPos;
                          fy = yPos;
                      }
             }
             
            if(timeE2 % 120 == 0){
                fx = -800;
                fy = -800;
            }
            timeE2++;
        }
        
            if(posTeam2X > width)
            {
                posTeam2X = -480;
                enemyTeam2Posy = floor(random(140,410));
                
                for( int j = 0 ; j < 5 ; j++)
                {
                     deadOrNotT2[j] = false;
                }
                
                enemyTeam3 = true;
                enemyTeam2 = false;
            }
            
             //bullet meet enemyT2
               for(int b = 0 ; b < bX.length; b++)
               {
                   for(int e = 0 ; e < enemyTeam2X.length ; e++)
                   {
                       if( deadOrNotT3[e] == false )
                       {                   
                           int xPos = enemyTeam2X[e]*unitX2+posTeam2X;
                           float yPos = enemyTeam2Y[e]*unitX2+enemyTeam2Posy; 
    
                           if(isHit(bX[b],bY[b],shootImg.width,shootImg.height,xPos,(int)yPos,enemyImg.width,enemyImg.height))
                           {  
                               deadOrNotT2[e] = true;
                               fx = xPos;
                               fy = yPos;
                               bY[b] = -200;
                               scoreChange();
                           }
                       }
                  }
               }              
            
        posTeam2X+=5;
      }
      
      //enemy team3
      if(enemyTeam3 == true){
       int[] enemyTeam3X = {0,1,2,1,0,-1,-2,-1};
       int[] enemyTeam3Y = {-2,-1,0,1,2,1,0,-1};    
       int unitX3 = 70;
       
         for(int i = 0;i < 8;i++)
         {
             int xPos = enemyTeam3X[i]*unitX3+posTeam3X;
             int yPos = enemyTeam3Y[i]*unitX3+enemyTeam3Posy;
           
             if(deadOrNotT3[i] == false)
             {
                image(enemyImg, xPos, yPos);
              
                //int enemyDistX = x6-xPos;
                //float enemyDistY = y6-yPos;             
                //int enemyTeam3Dist = (int)sqrt(enemyDistX*enemyDistX+enemyDistY*enemyDistY);             
                //if(enemyTeam3Dist <= enemyImg.width*0.5f+fighterImg.width*0.5f)
                if(isHit(x6,y6,fighterImg.width,fighterImg.height,xPos,yPos,enemyImg.width,enemyImg.height))
                {  
                    image(enemyImg,xPos+1000,yPos+1000);
                    deadOrNotT3[i] = true;
                    x4 = x4-20;
                    //flame pic
                    fx = xPos;
                    fy = yPos;
                 }
             }
             
                if(timeE3 % 120 == 0)
                {
                    fx = -800;
                    fy = -800;
                }
                    timeE3++;
              
                if( posTeam3X > width*1.5)
                {
                    posTeam3X = -480;
                    enemyTeam3Posy = floor(random(140,270));
                
                    for( int j = 0 ; j < 8 ; j++)
                    {
                        deadOrNotT3[j] = false;
                    }          
                    enemyTeam1 = true;
                    enemyTeam3 = false;
               }
         }
                //bullet meet enemyT3
                 for(int b = 0 ; b < bX.length; b++){
                     for(int e = 0 ; e < enemyTeam3X.length ; e++){
                     
                       if( deadOrNotT3[e] == false )
                       {
                           int xPos = enemyTeam3X[e]*unitX3+posTeam3X;
                           int yPos = enemyTeam3Y[e]*unitX3+enemyTeam3Posy;
                         
                           if(isHit(bX[b],bY[b],shootImg.width,shootImg.height,xPos,yPos,enemyImg.width,enemyImg.height))
                           {  
                               deadOrNotT3[e] = true;
                               fx = xPos;
                               fy = yPos;
                               bY[b] = -200;
                               scoreChange();
                           }
                       }
                  }
               }
         
               posTeam3X+=5;   
      }
      
    
    //scrollBack
    //x5 = x5%762;  
    if(x5>701){
      x5 = 0;
      y5 = floor(random(480));
     }
     
     
    //fighter position
    if(fighterUpPressed)
    {
        if(y6>5){
          y6 = y6-fighterSpeed;
        }
      }
      if(fighterDownPressed){
        if(y6<height-fighterImg.width){
          y6 = y6+fighterSpeed;
        }
      }
      if(fighterLeftPressed){
        if(x6>5){
          x6 = x6-fighterSpeed;    
        }
      }
      if(fighterRightPressed){
        if(x6<width-fighterImg.width){
          x6 = x6+fighterSpeed;
        }
     }

    //fighter meet treasure
    if(isHit(x6,y6,fighterImg.width,fighterImg.height,x3,y3,treasureImg.width,treasureImg.height))
    {  
        if(x4 < 100)
        {  
          x4= x4+10;
        }
          x3 = floor(random(400));
          y3 = floor(random(400));
    }

    //shoot bullets
    
    for(int i = 0;i < 5;i++)
    {
        image(shootImg,bX[i],bY[i]); 
        bX[i]-=10;
    }
      
    if(keyPressed && key == ' ')
    {
       if(canShoot == true )
       {
          for(int i = 0; i < 5; i++)
          {
              if(bX[i] < 0)
              {  
               bX[i] = x6;
               bY[i] = y6;
               canShoot = false;                              
               break;
              }
          }
      }            
    }   
    else
    { 
        canShoot = true;
    }    

  }//state=1 condition end   
  
  
  //loseState
  if(x4 <= 13){
    gameState = 3;
  }


  //gameState = lose
  if(gameState == 3)
  {
      image(end2Img,0,0);   
      
      y5 = floor(random(400));
      x4 = 20;
      if(mouseX>1.0/3.0*width && mouseX<2.0/3.0*width && mouseY>2.0/3.0*height && mouseY<3.0/4.0*height)
      {
          image(end1Img,0,0);
              if(mousePressed)
              {
                  gameState = GAME_RUN;
                  //flame disapear
                  fy = -200;
                   
                  //after lose restart team1 to team3's position
                  posTeam1X = -480;
                  posTeam2X = -480;
                  posTeam3X = -480;
                  
                  enemyTeam1 = true;
                  enemyTeam2 = false;
                  enemyTeam3 = false;
        
                  for( int i = 0 ; i < 5 ; i++)
                  {
                      deadOrNotT1[i] = false;
                      deadOrNotT2[i] = false;
                  }
          
                  for( int j = 0 ; j < 8 ; j++)
                  {
                      deadOrNotT3[j] = false;
                  }
              }
      }
  }      
                 
} //draw end

void keyPressed()
{
  if(keyCode == UP){
    fighterUpPressed = true;
  } 
  if(keyCode == DOWN){
    fighterDownPressed = true;
  }
  if(keyCode == LEFT){
    fighterLeftPressed = true;
  }
  if(keyCode == RIGHT){
    fighterRightPressed = true;
  } 
 
}

void keyReleased()
{
  if(keyCode == UP){
    fighterUpPressed = false;
  } 
  if(keyCode == DOWN){
    fighterDownPressed = false;
  }
  if(keyCode == LEFT){
    fighterLeftPressed = false;
  }
  if(keyCode == RIGHT){
    fighterRightPressed = false;
  }
  
}

//文字加20分function
void scoreChange()
{
    score += 20;
}

//偵測碰撞位置的function
boolean isHit ( int ax, int ay, int aw, int ah, int bx, int by, int bw, int bh ) 
{
    if(ax + aw >= bx && bx + bw >= ax && ay + ah >= by && by + bh >= ay)
    {
      return true;
    }
      return false;
}
