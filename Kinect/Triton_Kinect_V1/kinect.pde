/*kinect practice project.
 Developed by Jester Cornejo
 2020-12-06, Sunday

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
 
*/

import KinectPV2.KJoint;
import KinectPV2.*;
import cc.arduino.*;
import org.firmata.*;
import processing.serial.*;
boolean Mode = false;
int Laser = 6;
int Xser = 9;
int Yser = 8;
KinectPV2 kinect;
Serial myPort;
Arduino arduino;
void setup()
{
  size(1920, 1080,P3D);
    arduino = new Arduino(this, Arduino.list()[0], 57600);
  ellipseMode(CENTER);
  rectMode(CENTER);
  
  
  //set the kinect defaults

  kinect = new KinectPV2(this);   //create new kinect object
  kinect.enableSkeletonColorMap(true); // enable the kinect's skeleton mapping for joint tracking
  kinect.enableColorImg(true);
  kinect.init();
   arduino.pinMode(Xser, Arduino.SERVO);
   arduino.pinMode(Yser, Arduino.SERVO);
   arduino.pinMode(Laser, Arduino.OUTPUT);
}

void draw()
{
  background(0);
  
  TrackHand();
     if(Mode == false)
         {
           arduino.digitalWrite(Laser, Arduino.HIGH);
         }
         else
         {
           arduino.digitalWrite(Laser, Arduino.LOW);
         }
  
}

void TrackHand()
{
  imageMode(CORNER);
  image(kinect.getColorImage(), 0, 0, width, height); // display the kinect's camera live feed to the max size.
    ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();
  for(int i = 0; i < skeletonArray.size(); i++)
  {
      KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
      if(skeleton.isTracked())
      {
        KJoint[] joints = skeleton.getJoints();

        color col  = skeleton.getIndexColor();
        joints[KinectPV2.JointType_HandRight].getX();
        
         drawHandState(joints[KinectPV2.JointType_HandRight]);
        
        strokeWeight(3);
        //shoulder right to elbow
        ellipse(joints[KinectPV2.JointType_ShoulderRight].getX(), joints[KinectPV2.JointType_ShoulderRight].getY(),50,50);
        strokeWeight(8);
        line(joints[KinectPV2.JointType_ShoulderRight].getX(), joints[KinectPV2.JointType_ShoulderRight].getY(),
         joints[KinectPV2.JointType_ElbowRight].getX(), joints[KinectPV2.JointType_ElbowRight].getY());
         
        //elbow to hand
         strokeWeight(3);
        ellipse(joints[KinectPV2.JointType_ElbowRight].getX(), joints[KinectPV2.JointType_ElbowRight].getY(),50,50);  
        
        strokeWeight(8);
        line(joints[KinectPV2.JointType_HandRight].getX(), joints[KinectPV2.JointType_HandRight].getY(),
         joints[KinectPV2.JointType_ElbowRight].getX(), joints[KinectPV2.JointType_ElbowRight].getY());

       //hand
        
        
        ellipse(joints[KinectPV2.JointType_HandRight].getX(), joints[KinectPV2.JointType_HandRight].getY(), 30,30);
        textSize(30);
        fill(0);
        int XVal = int(map(constrain(joints[KinectPV2.JointType_HandRight].getX(),150,width- 150),600, width - 600,180, 0));
        int YVal = int(map(constrain(joints[KinectPV2.JointType_HandRight].getY(),150,height- 150),0, height / 2,150, 0));
      
         arduino.servoWrite(Xser, XVal);
         arduino.servoWrite(Yser, YVal);
         
      
               
      }
  }
}
void drawHandState(KJoint joint) {
  noStroke();
  handState(joint.getState());
  pushMatrix();
  translate(joint.getX(), joint.getY(), joint.getZ());
  ellipse(0, 0  , 70, 70);
  popMatrix();
}
void handState(int handState) {
  switch(handState) {
  case KinectPV2.HandState_Open:
    fill(0, 255, 0);
    Mode = true;
    break;
  case KinectPV2.HandState_Closed:
    fill(255, 0, 0);
    Mode = false;
  
    break;
  case KinectPV2.HandState_Lasso:
    fill(0, 0, 255);
    Mode = false;
         
    break;
  case KinectPV2.HandState_NotTracked:
    fill(255, 255, 255);
    Mode = false;
          
    break;
  }
}
