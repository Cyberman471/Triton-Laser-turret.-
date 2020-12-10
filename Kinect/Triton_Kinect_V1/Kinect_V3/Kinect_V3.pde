

/*kinect practice project.
 Developed by Jester Cornejo
 2020-12-07, Monday

Objective:
 To use the body tracking freature of the kinect
 to track the user's hand, and control the Triton Laser turret.

Approach for control:
 1. Gather right hand's possition x and y values.
 2. Map each coordinates into the servo's angle.
 3. if the hand's fist is close, then 
  Deploy = false, and LaserEnable = false,
    or else,
  Deploy = true, and LaserEnabled = true.
 
Kinect_V2:

This sketch is a more refined program for the triton laser turret

changes made here from the Kinect_v1 is the simplified parsing of skeleton data.
Added functions for Laser Turret

Use the following comment on top of every function:

/*

  Function Name:
  
  Purpose: 
  
  Parameters:
  
  
*/
 
import processing.serial.*;
import KinectPV2.KJoint;
import KinectPV2.*;
import cc.arduino.*;
import org.firmata.*;
import processing.serial.*;

Serial port;



//Turret turret;
Arduino arduino;
KinectPV2 kinect;
Serial myPort;
    
int LaserPort = 13;
int HeadPort = 8;
int DeployPort = 7;
int WaistPort = 9;

int HeadAxisMin = 20;


boolean Mode = false;
boolean LaserOn = false;
char Laser = 'F';
boolean DeployEnabled = false;



// *New* Public user body data.
//hand:
float LeftHandX;
float LeftHandY;
float RightHandX;
float RightHandY;

//elbow:
float ElbowRightX;
float ElbowRightY;
float ElbowLeftX;
float ElbowLeftY;

//shoulder:
float ShoulderRightX;
float ShoulderRightY;
float ShoulderLeftX;
float ShoulderLeftY;


float WaistAxis = 90;
float HeadAxis;
float DeployAxis;

int Tall = 30;
int Short = 0;

void setup()
{
  size(1920, 1080,P3D);
  ellipseMode(CENTER);
  
  //turret = new Turret(WaistAxis, HeadAxis, DeployAxis,Laser);
  
  port = new Serial(this, Serial.list()[0], 9600);
  //arduino = new Arduino(this, Arduino.list()[0], 57600);
  kinect = new KinectPV2(this);   //create new kinect object
  kinect.enableSkeletonColorMap(true); // enable the kinect's skeleton mapping for joint tracking
  kinect.enableColorImg(true);
  kinect.init();
  
   //arduino.pinMode(WaistPort, Arduino.SERVO);
   //arduino.pinMode(HeadPort, Arduino.SERVO);

   delay(1000);
   Deploy(false,30);


  
}

void draw()
{
  
 TrackBody();
 
}


void Turret(float Waist, float Head)
{
  MoveAxis(WaistPort, int(Waist));
  MoveAxis(HeadPort, int(Head)); 
}
void exit()
{

   Deploy(false, 30);
   
}

//void mouseDragged()
//{
//  float x = mouseX;
//  float y = mouseY;
//  if(DeployEnabled == true)
//  {
//   background(255);
//   MouseMode(); 
//   Turret(WaistAxis, HeadAxis);

//  }
//  else
//  {
//    background(90);
//    x = width / 2;
//    y = height / 2; 
//  }

//   fill(0, 0, 0);
//   ellipse(x,y, 30,30);
 
//}
void MouseMode()
{
  int limitX = 200;
  int limitY = 100;
  fill(#D421FC);
  strokeWeight(8);
  noFill();
  rectMode(CENTER);
  rect(width / 2,height / 2,width - limitX, height - limitY);
  

  
  WaistAxis = map(mouseX, limitX, width - limitX, 180 ,0);
  HeadAxis = map(mouseY, limitY, height - limitY, 180 ,HeadAxisMin);
  
}
//void keyPressed()
//{
//  int speed = 5;
//  if(DeployEnabled == true)
//  {
//   DeployEnabled = false;
//   Deploy(false, speed);
//  }
//  else if(DeployEnabled == false)
//  {
//    DeployEnabled = true;
//    Deploy(true, speed);
 
//  }

//}

/*Function Name: MoveAxis
    
    Purpose: To rotate an Axis
    
    Parameters: port = The servo's port number.
                val = The rotational degree of the axis.
  */

void MoveAxis(int port, int val)
{
   //arduino.servoWrite(port, val);  
}



/*

  Function Name:LaserEnable
  
  Purpose: To control the laser
  
  Parameters: enable = true or false
  
  
*/

void LaserEnable(boolean enable)
{
  if(enable == true)
  {
    //arduino.digitalWrite(LaserPort, Arduino.HIGH);
  }
  else if(enable == false)
  {
    //arduino.digitalWrite(LaserPort, Arduino.LOW);
  }
}

/*
Function Name: Deploy

Purpose: To make the laser turret stand taller and enable the laser.

Parameters: Enable = true: //WaistAxis = 90 (center)
                            //DeployAxis = 80 (tall)
                            //HeadAxis = 80 (straight)
                            //Laser enabled 
                    false:
                           //WaistAxis = 90 (center)
                          //DeployAxis = 0 (short)
                          //HeadAxis = 0 (straight)
                          //Laser disabled
                    Speed = refred in the delay for Servo's speed.

*/

void Deploy(boolean Enable, int Speed)
{

  
  // if Speed is 0, it just makes sleep or deploy immidiate. 
  if(Enable == true)
  {
    //WaistAxis = 90 (center)
    //DeployAxis = 80 (tall)
    //HeadAxis = 80 (straight)
    //Laser enabled
    
    MoveAxis(WaistPort, 90);
    for(int deg = Short; deg <= Tall; deg++)
    {
      MoveAxis(DeployPort, deg);
      delay(Speed);
      MoveAxis(HeadPort, deg);
    }
    LaserEnable(Enable);
  }
  else if(Enable == false)
  {
    //WaistAxis = 90 (center)
    //DeployAxis = 0 (short)
    //HeadAxis = 0 (straight)
    //Laser disabled
    
     MoveAxis(WaistPort, 90);
      
    for(int deg = Tall; deg >= Short; deg--)
    {
      MoveAxis(DeployPort, deg);
      delay(Speed);
      MoveAxis(HeadPort, deg);
    }
    LaserEnable(Enable);

  }
}
void ToggleDeploy(boolean enable)
{
 
  if(enable == true)
  {
    MoveAxis(WaistPort, 90);
    WaistAxis = 90;
    MoveAxis(DeployPort, Tall);
    DeployAxis = Tall;
    MoveAxis(HeadPort, Tall);
    HeadAxis = Tall;
    Laser = 'O';
  }
  else if(enable == false)
  {
    MoveAxis(WaistPort, 90);
    WaistAxis = 90;
    MoveAxis(DeployPort, Short);
    DeployAxis = Short;
    MoveAxis(HeadPort, Short);
    HeadAxis = Short;
    Laser = 'F';
  }
  
}


void TrackBody()
{   
  imageMode(CORNER);
  image(kinect.getColorImage(), 0, 0, width, height);
  
  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();
  for (int i = 0; i < skeletonArray.size(); i++)
  {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if (skeleton.isTracked())
    {
      KJoint[] joints = skeleton.getJoints();
      drawHandState(joints[KinectPV2.JointType_HandRight]);  
 
      RightHandX = joints[KinectPV2.JointType_HandRight].getX();
      RightHandY = joints[KinectPV2.JointType_HandRight].getY();      

      if(DeployEnabled == true)
      {
        
        MoveAxis(DeployPort, Tall);
        WaistAxis = map(constrain(RightHandX,150,width- 150),600, width - 600,180, 0);
        HeadAxis = map(constrain(RightHandY,150,height- 150),0, height / 2,150, 0);
        //Turret(WaistAxis, HeadAxis);
       
      }
      else if(DeployEnabled == false)
      {
        ToggleDeploy(false);
        delay(100);
      } 
       port.write('X' + int(WaistAxis));
       port.write('Y' + int(HeadAxis));
       port.write('L'+ Laser);
    }   
  }
}

  




void drawHandState(KJoint joint) {
  noStroke();
  handState(joint.getState());
  pushMatrix();
  translate(joint.getX(), joint.getY(), joint.getZ());
  ellipse(0, 0, 70, 70);
  popMatrix();
}
void handState(int handState) {
  
  switch(handState) {
  case KinectPV2.HandState_Open:
    fill(0, 255, 0);
    DeployEnabled = true;
    break;
  case KinectPV2.HandState_Closed:
    fill(255, 0, 0);
    DeployEnabled = false;

    break;
  case KinectPV2.HandState_Lasso:
    fill(0, 0, 255);


    break;
  case KinectPV2.HandState_NotTracked:
    fill(255, 255, 255);


    break;
  }
}
