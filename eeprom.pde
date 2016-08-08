// Arduino internal EEPROM demonstration
// Code for memory storage

#include <EEPROM.h>
int zz;
int EEsize = 250; // size in bytes of your board's EEPROM

void setup()
{
  Serial.begin(9600);
  randomSeed(analogRead(0));
}
void loop()
{
  Serial.println("Writing random numbers...");
  for (int i = 0; i < EEsize; i++)
  {
    zz=random(255);
    EEPROM.write(i, 0);
  }
  Serial.println();
  Serial.println("Reading EEprom...");
  for (int a=0; a<EEsize; a++)
  {
    zz = EEPROM.read(a);
    Serial.print("EEPROM position: ");
    Serial.print(a);
    Serial.print(" contains ");
    Serial.println(zz);
    delay(20);
  }
  Serial.println("write complete");
  while(1);
}
