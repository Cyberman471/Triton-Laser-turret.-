#include <Servo.h>

#define WaistPort 9
#define HeadPort 7
#define DeployPort 7 
#define LaserPort 13

int WaistAxis = 90;
int DeployAxis = 0;
int HeadAxis = 20;

Servo axis;
int val = 0;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  axis.attach(WaistPort);
  axis.attach(HeadPort);
  axis.attach(DeployPort);
}
int parseDataX(String data)
{
  data.remove(0, data.indexOf("X") + 1);
  return data.toInt();
}
int parseDataY(String data)
{
  data.remove(0, data.indexOf("Y") + 1);
  return data.toInt();
}
int parseDataL(String data)
{
 data.remove(0, data.indexOf("L") + 1)
 if(data == 'O'
 {
  
 }
}
void loop() {
  // put your main code here, to run repeatedly:
  if(Serial.available())
  {
    String reader = Serial.read();
    
    
  }
}
