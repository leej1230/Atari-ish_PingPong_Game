import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*; //Import Minim library to use sound
Minim minim = new Minim(this);
AudioPlayer BGM;
AudioPlayer Wall;
AudioPlayer Buzz;
AudioPlayer Shot; //Stating variables that I will use to input sounds

int easyX=100, easyY=300, easycolor=255; //Variables for easy level box in title screen
int normalX=400, normalY=300, normalcolor=255; //Variables for normal level box in title screen
int hardX=700, hardY=300, hardcolor=255; //Variables for hard level box in title screen

int my_x = 50, my_y = 250; //Initial position of player's box
int my_speed = 40; //Player can go up and down by this variable
int my_score = 0; //Player's score

int enemy_x = 930, enemy_y = 250; //Initial position of CPU's box
int enemy_speed = 30; //Enemy can go up and down by this variable
int enemy_score = 0; //Enemy's score

int ball_positionX = 500, ball_positionY = 300; //Initial position of ball
int ball_speedX = 2; //Ball's x direction speed
int ball_speedY = 2; //Ball's y direction speed
int ball_bounce = 0; //Counts how many time ball hit to player or CPU's box

int RocketX, RocketY; //Rocket's position
int rocket_speed = 6; //Rocket's x direction speed (Since y doesn't change, this variable only)
int rocket_launch = 0; //Flag for whether rocket can launch or not

color black = 0;
color green = color(0,255, 0);
color gray = 211;
color white = 255;
color orange = color(255, 170, 0);
color red = color(255, 0, 0);
color blue = color(0, 0, 255); //Input colors to word variable so that writing programs will be simpler

int AI_Diff = 1; //Difficulty of CPU. By lower the number, CPU gets stronger

int state; //Screen changes within this variable changes

void setup() { //Background Info
  frameRate(120); //Set frame rate to 120
  size(1000, 600);    //Size of screen
  state=0; //Input 0 to variable state
  BGM = minim.loadFile("Tetris_Theme.mp3");
  Wall = minim.loadFile("button57.mp3");
  Buzz = minim.loadFile("Quiz-Wrong_Buzzer02-1.mp3");
  Shot = minim.loadFile("shot1.mp3"); //Input sounds to variables
}

void draw() {
  int nextst=0; //Input 0 to nextst
  
  if(state == 0){ //If state is 0, operate
  nextst = title(); //Input the number returned from title() to nextst
  }
  
  else if(state == 1){ //If state is 1, operate
  background(black); // Setting the background to black
  nextst = game(); //Input the number returned from game() to nextst
  }
  
  else if(state == 2){ //If state is 2, operate
  nextst = ending(); //Input the number returned from ending() to nextst
  }
  
  state = nextst; //Input the number that nextst has to state
}

int title(){ //Function of title()
  background(black);    //Setting the background to black
  textSize(100); //Setting the text size 100
  fill(white); //Fills white color
  text("PONG", 350, 100); //Writes "" to position x and y 
  
  textSize(20); //Setting the text size to 20
  fill(white); //Fills white color
  text("↑KEY to move up", 350, 150); //Writes "" to position x and y
  text("↓KEY to move down", 350, 170); //Writes "" to position x and y
  text("Score 5 Points to win!", 350, 190); //Writes "" to position x and y
  text("Becareful with the ROCKETS!", 350, 210); //Writes "" to position x and y
  textSize(40); //Setting the text size to 40
  text("Click the LEVEL", 350, 280); //Writes "" to position x and y
  drawrocket(650, 200); //Draws rocket on position x and y by giving x and y information to function drawrocket()
  
  drawsqr(easyX, easyY); //Draws square on position x and y by giving x and y information to function drawsqr()
  textSize(50); //Setting the text size to 50
  fill(easycolor); //Fills with color inputted in easycolor
  text("EASY", easyX+40, easyY+70); //Writes "" to position x and y
  drawsqr(normalX, normalY); //Draws square on position x and y by giving x and y information to function drawsqr()
  textSize(40); //Setting the text size to 40
  fill(normalcolor); //Fills with color inputted in normalcolor
  text("NORMAL", normalX+18, normalY+68); //Writes "" to position x and y
  drawsqr(hardX, hardY); //Draws square on position x and y by giving x and y information to function drawsqr()
  textSize(50); //Setting the text size to 50
  fill(hardcolor); //Fills with color inputted in hardcolor
  text("HARD", hardX+30, hardY+70); //Writes "" to position x and y
 
  mouse_check(); //Operate function mouse_check()
  
  textSize(30); //Setting the text size to 30
  fill(white); //Fills white color
  text("Press 'z' key to start", 350, 500); //Writes "" to position x and y
  if(keyPressed && key == 'z'){ // if 'z' key is pressed
    return 1; //return 1 to title()
  }
  return 0; //return 0 to title()
} //End of function title()

void drawsqr(int sq_x, int sq_y){ //Input the provided numbers to each variables
  stroke(white); //Set stroke color white
  strokeWeight(5); //Set stroke weight 5
  fill(black); //Fill with black
  rect(sq_x, sq_y, 200, 100); // Drawing the rectangle in x and y with the width of 200 and height of 100
} //End of drawsqr()

void mouse_check(){
  if(mousePressed == true) { //If mouse pressed, operate below
    if((mouseX>easyX) && (mouseX<easyX+200) && (mouseY>easyY) && (mouseY<easyY+100)){ //If mouse is placed in inside the box of easy, operate below
      Wall.play(); //Play the mp3 file in variable wall
      Wall.rewind(); //Rewind the mp3 file in variable wall
      easycolor=green; //Set easycolor to green
      normalcolor=white; //Set normalcolor to white
      hardcolor=white; //Set hardcolor to white
      AI_Diff=12; //Input 12 to AI_Diff (Change difficulty)
    }
    if((mouseX>normalX) && (mouseX<normalX+200) && (mouseY>normalY) && (mouseY<normalY+100)){ //If mouse is placed in inside the box of normal, operate below
      Wall.play(); //Play the mp3 file in variable wall
      Wall.rewind(); //Rewind the mp3 file in variable wall
      easycolor=white; //Set easycolor to white
      normalcolor=green; //Set normalcolor to green
      hardcolor=white; //Set hardcolor to white
      AI_Diff=8; //Input 8 to AI_Diff (Change difficulty)
    }
    if((mouseX>hardX) && (mouseX<hardX+200) && (mouseY>hardY) && (mouseY<hardY+100)){ //If mouse is placed in inside the box of hard, operate below
      Wall.play(); //Play the mp3 file in variable wall
      Wall.rewind(); //Rewind the mp3 file in variable wall
      easycolor=white; //Set easycolor to white
      normalcolor=white; //Set normalcolor to white
      hardcolor=green; //Set hardcolor to green
      AI_Diff=4; //Input 4 to AI_Diff (Change difficulty)
    }
  }  
} //End of mouse_check()

int game(){
  
  BGM.play(); //Play variable BGM
  stage(); //Operate function stage
  
  enemy_y=AI(ball_positionY, enemy_y); //Provide two values to function AI, and Input value returned by function AI to enemy_y
  
  drawBlock(my_x,my_y,white); //Provide x, y, and color to function drawBlock to draw the player's box
  drawBlock(enemy_x,enemy_y,white); //Provide x, y, and color to function drawBlock to draw the CPU's box
  
  speed_up(); //Operate function speed_up()

  ball_positionX = ball_positionX + ball_speedX; //Add ball's x and x direction speed and input that value to ball_positionX
  ball_positionY = ball_positionY + ball_speedY; //Add ball's y and y direction speed and input that value to ball_positionY
  
  drawBall(ball_positionX, ball_positionY, 15, white); //Provide x, y, width(&height) and color to function drawBall to draw the ball (This line draws new positioned ball)
  ballMove(); //Operate function ballMove()
  
  draw_score(); //Operate function draw_score()
  
  score_check(); //Operate function score_check()

  
  if (AI_Diff == 4){ //If AI_Diff is 4 (hard mode), operate below
    if((ball_bounce>=3) && (0 == int(random(130))) && (rocket_launch == 0)){ //if ball_bounce is more or equal to 3 and out of 130~0, 0 released and rocket_launch is 0, operate below
      Shot.rewind(); //Rewind mp3 file in variable Shot
      Shot.play(); //Play mp3 file in variable Shot
      RocketX = enemy_x+10; //Input the value that 10 added to enemy_x to RocketX
      RocketY = enemy_y+50; //Input the value that 50 added to enemy_y to RocketY
      rocket_launch = 1; //Input 1 to variable rocket_launch
    }
  }
  
  if (AI_Diff == 8){ //If AI_Diff is 8 (normal mode), operate below
    if((ball_bounce>=3) && (0 == int(random(70))) && (rocket_launch == 0)){ //if ball_bounce is more or equal to 3 and out of 70~0, 0 released and rocket_launch is 0, operate below
      Shot.rewind(); //Rewind mp3 file in variable Shot
      Shot.play(); //Play mp3 file in variable Shot
      RocketX = enemy_x+10; //Input the value that 10 added to enemy_x to RocketX
      RocketY = enemy_y+50; //Input the value that 50 added to enemy_y to RocketY
      rocket_launch = 1; //Input 1 to variable rocket_launch
    }
  }
  
  if (AI_Diff == 12){ //If AI_Diff is 12 (easy mode), operate below
    if((ball_bounce>=3) && (0 == int(random(20))) && (rocket_launch == 0)){ //if ball_bounce is more or equal to 3 and out of 20~0, 0 released and rocket_launch is 0, operate below
      Shot.rewind(); //Rewind mp3 file in variable Shot
      Shot.play(); //Play mp3 file in variable Shot
      RocketX = enemy_x+10; //Input the value that 10 added to enemy_x to RocketX
      RocketY = enemy_y+50; //Input the value that 50 added to enemy_y to RocketY
      rocket_launch = 1; //Input 1 to variable rocket_launch
    }
  }
  
  if(rocket_launch == 1){ //If rocket_launch is 1, operate below
    rocketmotion(); //Operate function rocketmotion()
  }
  
  if((my_score==5) || (enemy_score==5)){ //If player or CPU's score is 5 operate below
    return 2; //return 2 to game()
  }
  
  return 1; //return 1 to game()
} //end of function game()

void stage(){ 
  drawDotline(500, 0, 500, 600); //Operates function drawDotline() by providing values
  
  strokeWeight(50); //Set stroke's weight to 50
  stroke(white); //Set stroke color white
  line(0,0,1000,0); //Draw the straight horizontal line from x=0 to x=1000 in above of the screen

  
  strokeWeight(50); //Set stroke's weight to 50
  stroke(white); //Set stroke color white
  line(0,600,1000,600); //Draw the straight horizontal line from x=0 to x=1000 in below of the screen
} //End of the function stage()

int AI(int ball_Y, int y){ //Recieves two values and input to "ball_Y" and "y"
  
  if (ball_bounce < 3){ //If value in ball_bounce is lower than 3, operate below
    if ((ball_Y>y) && enemy_y<470){ //If ball's y position is bigger than CPU's y position and CPU's y position is below 470, operate below
      y=y+enemy_speed; //Add CPU's y position and CPU's speed and input to variable y
    }
    if((ball_Y<y) && enemy_y>20){ //If ball's y position is smaller than CPU's y position and CPU's y position is bigger than 20, operate below
      y=y-enemy_speed; //Subtract CPU's y position and CPU's speed and input to variable y
    }
  }
  
  if ((ball_bounce >= 3) && (0==int(random(AI_Diff)))){ //If value in ball_bounce is bigger or equal to 3 and if 0 was emitted from random 0~(number in AI_Diff), operate below
    if ((ball_Y>y) && enemy_y<470){ ////If ball's y position is bigger than CPU's y position and CPU's y position is below 470, operate below
      y=y+enemy_speed; //Add CPU's y position and CPU's speed and input to variable y
    }
    if((ball_Y<y) && enemy_y>20){ //If ball's y position is smaller than CPU's y position and CPU's y position is bigger than 20, operate below
      y=y-enemy_speed; //Subtract CPU's y position and CPU's speed and input to variable y
    }
  }
  
  return y; //return y to AI()
} //End of function AI()

void ballMove() {

  if(ball_positionY < 20 || ball_positionY > 560){ //When ball hits wall in above or below, operates below
    Wall.play(); //Play the mp3 file in variable Wall
    Wall.rewind(); //Rewind the mp3 file in variable Wall
    ball_speedY = ball_speedY * -1; //Multiply negative 1 to ball's y direction speed and input that to ball's y direction speed variable
  }
  if(((ball_positionY+15)>my_y) && (ball_positionY<(my_y+100))  &&  (ball_positionX<(my_x+20)) && (ball_positionX>my_x) && (ball_speedX<0)){ //When ball hits player's box, operates below
    Wall.play(); //Play the mp3 file in variable Wall
    Wall.rewind(); //Rewind the mp3 file in variable Wall
    ball_speedX = ball_speedX  * -1; //Multiply negative 1 to ball's x direction speed and input that to ball's x direction speed variable
    ball_bounce= ball_bounce+1; // Add count to ball_bounce
  }
  if(((ball_positionY+15)>enemy_y) && ((ball_positionY)<(enemy_y+100))  &&  ((ball_positionX+15)>enemy_x) &&  ((ball_positionX+15)<(enemy_x+20)) && (ball_speedX>0)){ //When ball hits CPU's box, operates below
    Wall.play(); //Play the mp3 file in variable Wall
    Wall.rewind(); //Rewind the mp3 file in variable Wall
    ball_speedX = ball_speedX  * -1; //Multiply negative 1 to ball's x direction speed and input that to ball's x direction speed variable
    ball_bounce= ball_bounce+1; // Add count to ball_bounce
  }
} //End of function ballMove()

void drawDotline(int dotline_x1, int dotline_y1, int dotline_x2, int dotline_y2){ //Input the provided numbers to each variables
  for (int i = 0; i <= 50; i++) { //Until i reaches 50, operate below
    float x = lerp(dotline_x1, dotline_x2, i/10.0) + 10; //calculates a number between two numbers at decided range
    float y = lerp(dotline_y1, dotline_y2, i/50.0); //calculates a number between two numbers at decided range
    strokeWeight(1);
    stroke(255);
    point(x, y); //Draw the point
  }
} //End of drawDotline()

void drawBall(int ball_x, int ball_y, int ball_size, int ball_color){ //Input the provided numbers to each variables
  stroke(black); //Set stroke color black
  strokeWeight(1); //Set stroke weight 1
  fill(ball_color); //Fill with value in ball_color
  square(ball_x, ball_y, ball_size); //Draw square in x, y, with the size of value in ball_size
} //End of drawBall()

void drawBlock(int tmp_x, int tmp_y, int tmp_col) { //Input the provided numbers to each variables
  stroke(tmp_col); //Set stroke color
  strokeWeight(5); //Set stroke weight 5
  fill(black); //Fill with black
  rect(tmp_x,tmp_y,20,100); // Drawing the rectangle in x and y with the width of 20 and height of 100
} //End of drawBlock()

void drawrocket(int RX, int RY){ //Input the provided numbers to each variables
  noStroke(); //delete stroke
  fill(red); //Fill with red
  triangle(RX, RY, RX+6, RY+7.5, RX+6, RY-7.5); //Draw triangle (head of rocket)
  fill(white); //Fill with white
  rect(RX+6, RY-7.5, 25, 15); //Draw rectangle (body of rocket)
  fill(blue); //Fill with blue
  circle(RX+14, RY, 8); //Draw Circle (Window of rocket)
  fill(gray); //Fill with gray
  rect(RX+31, RY-7.5, 4, 15); //Draw square (Bottom of rocket)
  fill(red); //Fill with red
  arc(RX+35, RY, 15, 10, radians(270), radians(450), CHORD); //draw arc (Fire of rocket)
  fill(orange); //Fill with red
  arc(RX+35, RY, 10, 5, radians(270), radians(450), CHORD); //draw arc (Smaller fire of rocket)
} //End of drawrocket()

void rocketmotion(){
    drawrocket(RocketX, RocketY); //Send RocketX and RocketY value to drawrocket() function and operate it
    RocketX = RocketX-rocket_speed; //Subtract rocket_speed from RocketX and input into RocketX
    drawrocket(RocketX, RocketY); //Send RocketX and RocketY value to drawrocket() function and operate it
    if (RocketX < -30){ //if RocketX is smaller than -30 operate below
      rocket_launch = 0; //Set rocket_launch 0
    }
} //End of rocketmotion()

void score_check(){
  if( (ball_positionX<=0) || ((my_y<(RocketY+7.5))) && ((my_y+100)>(RocketY-7.5))&& ((my_x+20)>RocketX) && (my_x<(RocketX+31)) ){ //If ball hits left end wall or player box hit by rocket operate below
    Buzz.play(); //Play mp3 file in variable Buzz
    Buzz.rewind(); //Rewind mp3 file in variable Buzz
    enemy_score=enemy_score+1; //Add score on CPU
    ball_positionX = 500; //Reset value
    ball_positionY = 300; //Reset value
    ball_speedX = -2; //Reset value
    ball_speedY = -2; //Reset value
    ball_bounce = 0; //Reset value
    my_x = 50; //Reset value
    my_y = 250; //Reset value
    enemy_x = 930; //Reset value
    enemy_y = 250; //Reset value
    rocket_launch = 0; //Reset value
    RocketX = enemy_x; //Reset value
    RocketY = enemy_y; //Reset value
    BGM.pause(); //Pause mp3 file in variable BGM
    delay(700); //Stop process for 700 milliseconds
  }
  
  if((ball_positionX+15)>=width){ //If ball hits right end wall operate below
    Buzz.play(); //Play mp3 file in variable Buzz
    Buzz.rewind(); //Rewind mp3 file in variable Buzz
    my_score=my_score+1; //Add score on player
    ball_positionX = 500; //Reset value
    ball_positionY = 300; //Reset value
    ball_speedX = 2; //Reset value
    ball_speedY = 2; //Reset value
    ball_bounce = 0; //Reset value
    my_x = 50; //Reset value
    my_y = 250; //Reset value
    enemy_x = 930; //Reset value
    enemy_y = 250; //Reset value
    rocket_launch = 0; //Reset value
    RocketX = enemy_x; //Reset value
    RocketY = enemy_y; //Reset value
    BGM.pause(); //Pause mp3 file in variable BGM
    delay(700); //Stop process for 700 milliseconds
  }
} //End of score_check()

void keyPressed() { //If key is pressed, operate below
  if((keyCode == DOWN)&&(my_y<470)){ //If key is down key and y value is below 470, operate below
    my_y=my_y+my_speed; //Add my_speed value to my_y and input to my_y
    drawBlock(my_x, my_y, white); //Provide the x, y, and color value to drawBlock
  }
  if((keyCode == UP)&&(my_y>20)){ //If key is down key and y value is above 20, operate below
    my_y=my_y-my_speed; //Subtract my_speed value to my_y and input to my_y
    drawBlock(my_x, my_y, white);  //Provide the x, y, and color value to drawBlock
  }
} //End of keyPrressed()

void speed_up(){
  if (ball_bounce==5){ //If ball_bounce reaches 5, speed up the ball by using below lines
    if((ball_speedX>0) && (ball_speedY>0)){ //If ball_speedX is positive and ball_speedY is positive operate below
      ball_speedX=3; //Set ball_speedX to 3
      ball_speedY=3; //Set ball_speedY to 3
    }
    if((ball_speedX>0) && (ball_speedY<0)){ //If ball_speedX is positive and ball_speedY is negative operate below
      ball_speedX=3; //Set ball_speedX to 3
      ball_speedY=-3; //Set ball_speedY to -3
    }
    if((ball_speedX<0) && (ball_speedY>0)){ //If ball_speedX is negative and ball_speedY is positive operate below
      ball_speedX=-3; //Set ball_speedX to -3
      ball_speedY=3; //Set ball_speedY to 3
    }
    if((ball_speedX<0) && (ball_speedY<0)){ //If ball_speedX is negative and ball_speedY is negative operate below
      ball_speedX=-3; //Set ball_speedX to -3
      ball_speedY=-3; //Set ball_speedY to -3
    }
  }
  if (ball_bounce==10){ //If ball_bounce reaches 10, speed up the ball by using below lines
    if((ball_speedX>0) && (ball_speedY>0)){ //If ball_speedX is positive and ball_speedY is positive operate below
      ball_speedX=4; //Set ball_speedX to 4
      ball_speedY=4; //Set ball_speedY to 4
    }
    if((ball_speedX>0) && (ball_speedY<0)){ //If ball_speedX is positive and ball_speedY is negative operate below
      ball_speedX=4; //Set ball_speedX to 4
      ball_speedY=-4; //Set ball_speedY to -4
    }
    if((ball_speedX<0) && (ball_speedY>0)){ //If ball_speedX is negative and ball_speedY is positive operate below
      ball_speedX=-4; //Set ball_speedX to -4
      ball_speedY=4; //Set ball_speedY to 4
    }
    if((ball_speedX<0) && (ball_speedY<0)){ //If ball_speedX is negative and ball_speedY is negative operate below
      ball_speedX=-4; //Set ball_speedX to -4
      ball_speedY=-4; //Set ball_speedY to -4
    }
  }
} //End of speed_up()

void draw_score(){
  textSize(90); //set text size to 90
  fill(white); //fill with white
  text(my_score, 430, 100); //Write value in my_score to x, y position
  textSize(90); //set text size to 90
  fill(white); //fill with white
  text(enemy_score, 533, 100); //Write value in enemy_score to x, y position
} //End of draw_score()

int ending(){
  
  background(black); //Set background black
  textSize(100); //Setting the text size to 100
  fill(white); //Fills white color
  text("GAME SET", 248, 170); //Writes "" to position x and y
  
  textSize(90); //Setting the text size to 90
  fill(white); //Fills white color
  text(my_score, 430, 320); //Writes the value inputted in my_score to position x and y
  textSize(90); //Setting the text size to 90
  fill(white); //Fills white color
  text(enemy_score, 533, 320); //Writes the value inputted in enemy_score to position x and y
  textSize(90); //Setting the text size to 90
  fill(white); //Fills white color
  text("-", 490, 320); //Writes "" to position x and y
  
  if(my_score>enemy_score){ //If value in my_score is higher than the value in enemy_score, operate below
    text("YOU WIN", 310, 480); //Writes "" to position x and y
  }
  
  if(my_score<enemy_score){ //If value in my_score is lower than the value in enemy_score, operate below
    text("YOU LOSE", 290, 480); //Writes "" to position x and y
  }
  
  return 2; //return 2 to ending()
} //End of function ending()
