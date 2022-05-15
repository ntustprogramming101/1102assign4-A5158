PImage title, gameover, startNormal, startHovered, restartNormal, restartHovered;
PImage groundhogIdle, groundhogLeft, groundhogRight, groundhogDown;
PImage bg, life, cabbage, stone1, stone2, soilEmpty;
PImage soldier;
PImage soil0, soil1, soil2, soil3, soil4, soil5;
PImage[][] soils, stones;

final int GAME_START = 0, GAME_RUN = 1, GAME_OVER = 2;
int gameState = 0;

final int LIFE0=0,LIFE1=1,LIFE2=2,LIFE3=3,LIFE4=4,LIFE5=5;
int lifeState=2;

final int GRASS_HEIGHT = 15;
final int SOIL_COL_COUNT = 8;
final int SOIL_ROW_COUNT = 24;
final int SOIL_SIZE = 80;

int[][] soilHealth;
int[] soilEmp1;
int[] soilEmp2;

final int START_BUTTON_WIDTH = 144;
final int START_BUTTON_HEIGHT = 60;
final int START_BUTTON_X = 248;
final int START_BUTTON_Y = 360;

float[] cabbageX, cabbageY, soldierX, soldierY;
float soldierSpeed = 2f;

float playerX, playerY;
int playerCol, playerRow;
final float PLAYER_INIT_X = 4 * SOIL_SIZE;
final float PLAYER_INIT_Y = - SOIL_SIZE;
boolean leftState = false;
boolean rightState = false;
boolean downState = false;
int playerHealth = 2;
final int PLAYER_MAX_HEALTH = 5;
int playerMoveDirection = 0;
int playerMoveTimer = 0;
int playerMoveDuration = 15;
int x =1;

boolean demoMode = false;

int soilE,soilE1,soilE2;

void setup() {
	size(640, 480, P2D);
	bg = loadImage("img/bg.jpg");
	title = loadImage("img/title.jpg");
	gameover = loadImage("img/gameover.jpg");
	startNormal = loadImage("img/startNormal.png");
	startHovered = loadImage("img/startHovered.png");
	restartNormal = loadImage("img/restartNormal.png");
	restartHovered = loadImage("img/restartHovered.png");
	groundhogIdle = loadImage("img/groundhogIdle.png");
	groundhogLeft = loadImage("img/groundhogLeft.png");
	groundhogRight = loadImage("img/groundhogRight.png");
	groundhogDown = loadImage("img/groundhogDown.png");
	life = loadImage("img/life.png");
	soldier = loadImage("img/soldier.png");
	cabbage = loadImage("img/cabbage.png");

	soilEmpty = loadImage("img/soils/soilEmpty.png");

  stone1 = loadImage("img/stone1.png");
  stone2 = loadImage("img/stone2.png");

	// Load soil images used in assign3 if you don't plan to finish requirement #6
	soil0 = loadImage("img/soil0.png");
	soil1 = loadImage("img/soil1.png");
	soil2 = loadImage("img/soil2.png");
	soil3 = loadImage("img/soil3.png");
	soil4 = loadImage("img/soil4.png");
	soil5 = loadImage("img/soil5.png");

	// Load PImage[][] soils
	soils = new PImage[6][5];
	for(int i = 0; i < soils.length; i++){
		for(int j = 0; j < soils[i].length; j++){
			soils[i][j] = loadImage("img/soils/soil" + i + "/soil" + i + "_" + j + ".png");      
		}
	}

	// Load PImage[][] stones
	stones = new PImage[2][5];
	for(int i = 0; i < stones.length; i++){
		for(int j = 0; j < stones[i].length; j++){
			stones[i][j] = loadImage("img/stones/stone" + i + "/stone" + i + "_" + j + ".png");
		}
	}

	// Initialize player
	playerX = PLAYER_INIT_X;
	playerY = PLAYER_INIT_Y;
	playerCol = (int) (playerX / SOIL_SIZE);
	playerRow = (int) (playerY / SOIL_SIZE);
	playerMoveTimer = 0;
	playerHealth = 2;
//empty
      soilEmp1 = new int[SOIL_ROW_COUNT];
      soilEmp2 = new int[SOIL_ROW_COUNT];
        for (int j = 1; j < 24; j++) {
          int soilE=floor(random(2)+1);
          if(soilE==2){
            soilE1=floor(random(8));
            soilE2=floor(random(8));
          }else{
            soilE1=floor(random(8));
            soilE2=8;
          }
          soilEmp1[j]=soilE1;
          soilEmp2[j]=soilE2;
          soilEmp1[0]=-1;
          soilEmp2[0]=-1;
        }

	// Initialize soilHealth
	soilHealth = new int[SOIL_COL_COUNT][SOIL_ROW_COUNT];
	for(int i = 0; i < soilHealth.length; i++){
		for (int j = 0; j < soilHealth[i].length; j++) {
			 // 0: no soil, 15: soil only, 30: 1 stone, 45: 2 stones
			soilHealth[i][j] = 15;
      if(i*SOIL_SIZE==soilEmp1[j]*SOIL_SIZE || i*SOIL_SIZE==soilEmp2[j]*SOIL_SIZE)soilHealth[i][j] = 0;
      
      else if(i==j)
        soilHealth[i][j] = 30;      
        
      else if(j==8 || j==11 || j==12 ||j==15){
          if(i==0 || i==3 || i==4 || i==7){
          }else{soilHealth[i][j] = 30;}
        } 
      else if(j==9 || j==10 || j==13 ||j==14){
          if(i==1 || i==2 || i==5 ||i==6){
          }else{soilHealth[i][j] = 30;}
        }
      else if(j>=16){
          if(i%3==0){if(j%3==1)soilHealth[i][j] = 30;}
          if(i%3==1){if(j%3==0)soilHealth[i][j] = 30;}
          if(i%3==2){if(j%3==2)soilHealth[i][j] = 30;}    
          if(i%3==0){if(j%3==2)soilHealth[i][j] = 45;} 
          if(i%3==1){if(j%3==1)soilHealth[i][j] = 45;}
          if(i%3==2){if(j%3==0)soilHealth[i][j] = 45;}
        }
        
		}
	}
      
      

	// Initialize soidiers and their position
  soldierX = new float[6];
  soldierY = new float[6];
  for (int i=0;i<=5;i++){
    soldierX[i]=floor(random(8));
    soldierY[i]=floor(random(4));

  }

	// Initialize cabbages and their position
  cabbageX = new float[6];
  cabbageY = new float[6];
  for (int i=0;i<=5;i++){
    cabbageX[i]=floor(random(8));
    cabbageY[i]=floor(random(4));

  }
}

void draw() {

	switch (gameState) {

		case GAME_START: // Start Screen
		image(title, 0, 0);
		if(START_BUTTON_X + START_BUTTON_WIDTH > mouseX
	    && START_BUTTON_X < mouseX
	    && START_BUTTON_Y + START_BUTTON_HEIGHT > mouseY
	    && START_BUTTON_Y < mouseY) {

			image(startHovered, START_BUTTON_X, START_BUTTON_Y);
			if(mousePressed){
				gameState = GAME_RUN;
				mousePressed = false;
			}

		}else{

			image(startNormal, START_BUTTON_X, START_BUTTON_Y);

		}

		break;

		case GAME_RUN: // In-Game
		// Background
		image(bg, 0, 0);

		// Sun
	    stroke(255,255,0);
	    strokeWeight(5);
	    fill(253,184,19);
	    ellipse(590,50,120,120);

	    // CAREFUL!
	    // Because of how this translate value is calculated, the Y value of the ground level is actually 0
		pushMatrix();
		translate(0, max(SOIL_SIZE * -18, SOIL_SIZE * 1 - playerY));

		// Ground

		fill(124, 204, 25);
		noStroke();
		rect(0, -GRASS_HEIGHT, width, GRASS_HEIGHT);

		// Soil

		for(int i = 0; i < SOIL_COL_COUNT; i++){
      for(int j = 0; j < SOIL_ROW_COUNT; j++){

        if(soilHealth[i][j] > 0){

          int soilColor = (int) (j / 4);
          int soilAlpha = (int) (min(5, ceil((float)soilHealth[i][j] / (15 / 5))) - 1);

          image(soils[soilColor][soilAlpha], i * SOIL_SIZE, j * SOIL_SIZE);

          if(soilHealth[i][j] > 15){
            int stoneSize = (int) (min(5, ceil(((float)soilHealth[i][j] - 15) / (15 / 5))) - 1);
            image(stones[0][stoneSize], i * SOIL_SIZE, j * SOIL_SIZE);
          }

          if(soilHealth[i][j] > 15 * 2){
            int stoneSize = (int) (min(5, ceil(((float)soilHealth[i][j] - 15 * 2) / (15 / 5))) - 1);
            image(stones[1][stoneSize], i * SOIL_SIZE, j * SOIL_SIZE);
          }

        }else{
          image(soilEmpty, i * SOIL_SIZE, j * SOIL_SIZE);
        }

      }
    }

		// Cabbages
		// > Remember to check if playerHealth is smaller than PLAYER_MAX_HEALTH!
    for(int i=0;i<=5;i++){
      image(cabbage,cabbageX[i]*SOIL_SIZE,cabbageY[i]*SOIL_SIZE+i*SOIL_SIZE*4);
      if(playerX==cabbageX[i]*SOIL_SIZE && playerY==cabbageY[i]*SOIL_SIZE+i*SOIL_SIZE*4 && playerHealth<=4){        
          cabbageX[i]=1000;cabbageY[i]=1000;
          image(cabbage,cabbageX[i],cabbageY[i]);
          playerHealth++;        
      }
    }
    
      
		// Groundhog

		PImage groundhogDisplay = groundhogIdle;

		// If player is not moving, we have to decide what player has to do next
    if(playerMoveTimer == 0){

      if((playerRow + 1 < SOIL_ROW_COUNT && soilHealth[playerCol][playerRow + 1] == 0) || playerRow + 1 >= SOIL_ROW_COUNT){

        groundhogDisplay = groundhogDown;
        playerMoveDirection = DOWN;
        playerMoveTimer = playerMoveDuration;

      }else{

        if(leftState){

          groundhogDisplay = groundhogLeft;

          // Check left boundary
          if(playerCol > 0){

            if(playerRow >= 0 && soilHealth[playerCol - 1][playerRow] > 0){
              soilHealth[playerCol - 1][playerRow] --;
            }else{
              playerMoveDirection = LEFT;
              playerMoveTimer = playerMoveDuration;
            }

          }

        }else if(rightState){

          groundhogDisplay = groundhogRight;

          // Check right boundary
          if(playerCol < SOIL_COL_COUNT - 1){

            if(playerRow >= 0 && soilHealth[playerCol + 1][playerRow] > 0){
              soilHealth[playerCol + 1][playerRow] --;
            }else{
              playerMoveDirection = RIGHT;
              playerMoveTimer = playerMoveDuration;
            }

          }

        }else if(downState){

          groundhogDisplay = groundhogDown;

          // Check bottom boundary
          if(playerRow < SOIL_ROW_COUNT - 1){

            soilHealth[playerCol][playerRow + 1] --;

          }
        }
      }

    }else{
      // Draw image before moving to prevent offset
      switch(playerMoveDirection){
        case LEFT:  groundhogDisplay = groundhogLeft;  break;
        case RIGHT:  groundhogDisplay = groundhogRight;  break;
        case DOWN:  groundhogDisplay = groundhogDown;  break;
      }
    }
    image(groundhogDisplay, playerX, playerY);

		// If player is now moving?
		// (Separated if-else so player can actually move as soon as an action starts)
		// (I don't think you have to change any of these)

		if(playerMoveTimer > 0){

			playerMoveTimer --;
			switch(playerMoveDirection){

				case LEFT:
				groundhogDisplay = groundhogLeft;
				if(playerMoveTimer == 0){
					playerCol--;
					playerX = SOIL_SIZE * playerCol;
				}else{
					playerX = (float(playerMoveTimer) / playerMoveDuration + playerCol - 1) * SOIL_SIZE;
				}
				break;

				case RIGHT:
				groundhogDisplay = groundhogRight;
				if(playerMoveTimer == 0){
					playerCol++;
					playerX = SOIL_SIZE * playerCol;
				}else{
					playerX = (1f - float(playerMoveTimer) / playerMoveDuration + playerCol) * SOIL_SIZE;
				}
				break;

				case DOWN:
				groundhogDisplay = groundhogDown;
				if(playerMoveTimer == 0){
					playerRow++;
					playerY = SOIL_SIZE * playerRow;
				}else{
					playerY = (1f - float(playerMoveTimer) / playerMoveDuration + playerRow) * SOIL_SIZE;
				}
				break;
			}

		}

		

		// Soldiers
		// > Remember to stop player's moving! (reset playerMoveTimer)
		// > Remember to recalculate playerCol/playerRow when you reset playerX/playerY!
		// > Remember to reset the soil under player's original position!
    for(int i=0;i<=5;i++){           
      image(soldier,soldierX[i]+=soldierSpeed,soldierY[i]*SOIL_SIZE+i*SOIL_SIZE*4);
      if (soldierX[i]>=width)soldierX[i]=-SOIL_SIZE;
      if(playerY+80>soldierY[i]*SOIL_SIZE+i*SOIL_SIZE*4 &&  playerY<soldierY[i]*SOIL_SIZE+i*SOIL_SIZE*4+80){
        if(playerX-soldierX[i]<80 && playerX-soldierX[i]>0){
           playerHealth--;
           playerX=PLAYER_INIT_X;
           playerY=PLAYER_INIT_Y;
           playerMoveTimer=0;
           playerCol = (int) (playerX / SOIL_SIZE);
           playerRow = (int) (playerY / SOIL_SIZE);
           
        }
        if(playerX-soldierX[i]>-80 && playerX-soldierX[i]<0){ 
           playerHealth--;
           playerX=PLAYER_INIT_X;
           playerY=PLAYER_INIT_Y;
           playerMoveTimer=0;
           playerCol = (int) (playerX / SOIL_SIZE);
           playerRow = (int) (playerY / SOIL_SIZE);
           
        } 
      }
    }

		// Demo mode: Show the value of soilHealth on each soil
		// (DO NOT CHANGE THE CODE HERE!)

		if(demoMode){	

			fill(255);
			textSize(26);
			textAlign(LEFT, TOP);

			for(int i = 0; i < soilHealth.length; i++){
				for(int j = 0; j < soilHealth[i].length; j++){
					text(soilHealth[i][j], i * SOIL_SIZE, j * SOIL_SIZE);
				}
			}

		}

		popMatrix();

		// Health UI
    if(playerHealth>=PLAYER_MAX_HEALTH)playerHealth=PLAYER_MAX_HEALTH;
    if(playerHealth<=0)gameState=GAME_OVER;
    for(int i=0;i<=playerHealth-1;i++){
      image(life,10+i*70,10,50,51);
      
    }

		break;

		case GAME_OVER: // Gameover Screen
		image(gameover, 0, 0);
		
		if(START_BUTTON_X + START_BUTTON_WIDTH > mouseX
	    && START_BUTTON_X < mouseX
	    && START_BUTTON_Y + START_BUTTON_HEIGHT > mouseY
	    && START_BUTTON_Y < mouseY) {

			image(restartHovered, START_BUTTON_X, START_BUTTON_Y);
			if(mousePressed){
				gameState = GAME_RUN;
				mousePressed = false;
    
    //soilempty
    soilEmp1 = new int[SOIL_ROW_COUNT];
      soilEmp2 = new int[SOIL_ROW_COUNT];
        for (int j = 1; j < 24; j++) {
          int soilE=floor(random(2)+1);
          if(soilE==2){
            soilE1=floor(random(8));
            soilE2=floor(random(8));
          }else{
            soilE1=floor(random(8));
            soilE2=8;
          }
          soilEmp1[j]=soilE1;
          soilEmp2[j]=soilE2;
          soilEmp1[0]=-1;
          soilEmp2[0]=-1;
        }

				// Initialize player
				playerX = PLAYER_INIT_X;
				playerY = PLAYER_INIT_Y;
				playerCol = (int) (playerX / SOIL_SIZE);
				playerRow = (int) (playerY / SOIL_SIZE);
				playerMoveTimer = 0;
				playerHealth = 2;

				// Initialize soilHealth
				soilHealth = new int[SOIL_COL_COUNT][SOIL_ROW_COUNT];
				for(int i = 0; i < soilHealth.length; i++){
					for (int j = 0; j < soilHealth[i].length; j++) {
						 // 0: no soil, 15: soil only, 30: 1 stone, 45: 2 stones
						soilHealth[i][j] = 15;
					}
				}

				// Initialize soidiers and their position
        soldierX = new float[6];
        soldierY = new float[6];
        for (int i=0;i<=5;i++){
          soldierX[i]=floor(random(8));
          soldierY[i]=floor(random(4));
      
        }
      
        // Initialize cabbages and their position
        cabbageX = new float[6];
        cabbageY = new float[6];
        for (int i=0;i<=5;i++){
          cabbageX[i]=floor(random(8));
          cabbageY[i]=floor(random(4));
      
        }
			}

		}else{

			image(restartNormal, START_BUTTON_X, START_BUTTON_Y);

		}
		break;
		
	}
}

void keyPressed(){
	if(key==CODED){
		switch(keyCode){
			case LEFT:
			leftState = true;
			break;
			case RIGHT:
			rightState = true;
			break;
			case DOWN:
			downState = true;
			break;
		}
	}else{
		if(key=='b'){
			// Press B to toggle demo mode
			demoMode = !demoMode;
		}
	}
}

void keyReleased(){
	if(key==CODED){
		switch(keyCode){
			case LEFT:
			leftState = false;
			break;
			case RIGHT:
			rightState = false;
			break;
			case DOWN:
			downState = false;
			break;
		}
	}
}
