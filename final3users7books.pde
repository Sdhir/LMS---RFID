#include <LiquidCrystal.h>
#include <EEPROM.h>
#include <NewSoftSerial.h>
int addr = 0;
int address=0;
int i=0;
int j=0;
int k=0;
int eeprom_buff = 0;
int r_count = 0;
int m,count=0;
int n=0;
int book_no = 0;
int user_no = 0;
int b1state = 0;
int b2state = 0;
int time_out = 0;
int user1_loc = 120;
int user2_loc = 130;
int user3_loc = 140;
int user4_loc = 150;
int user5_loc = 160;
int user6_loc = 170;
int user7_loc = 180;
int book_count = 3;
int booklimit = 7;
const int button_one = 2;
const int button_two = 3;
boolean ok_flag,r_flag,b_flag,a_flag,c_flag,run_flag,flag1 = 0;
int value=0;
int  val = 0; 
char code[10] = {
  0}; 
int bytesread,buffer = 0; 
#define rxPin 8
#define txPin 9
NewSoftSerial RFID (rxPin, txPin);
boolean issue3_flag = 0;
boolean return3_flag = 0;
boolean transaction1_flag = 0;
boolean view1_flag = 0;
boolean nocontinue2_flag = 0;
boolean continue2_flag = 0;
boolean bookenableflag = 0;
//boolean studentenableflag = 0;
LiquidCrystal lcd(11, 10, 7, 6, 5, 4);
byte armsDown[8] = {
  0b00100,
  0b01010,
  0b00100,
  0b00100,
  0b01110,
  0b10101,
  0b00100,
  0b01010
};

byte armsUp[8] = {
  0b00100,
  0b01010,
  0b00100,
  0b10101,
  0b01110,
  0b00100,
  0b00100,
  0b01010
};

char tag1[9] = "10035233";
char tag2[9] = "15751051";
char tag3[9] = "15751052";
char tag4[9] = "15751046";
char tag5[9] = "15760691";
char tag6[9] = "10037127";
char tag7[9] = "15739593";
char tag8[9] = "15751036";
char tag9[9] = "15760636";
char tag10[9] = "15751050";
char tag11[9] = "24010953";
char tag12[9] = "15310119";
char tag13[9] = "01023C01";
char tag14[9] = "01023101";


void checkTag(char tag[])
{
  ///////////////////////////////////
  //Check the read tag against known tags
  ///////////////////////////////////

  if(strlen(tag) == 0) return; //empty, no need to contunue

  if(compareTag(tag, tag1))
  {
    lcd.print("10VV1A0401");
    r_flag = 1;
    user_no = 1;
  }
  else if(compareTag(tag, tag2))
  {
    lcd.print("10VV1A0402");
    r_flag = 1;
    user_no = 2;
  }
  else if(compareTag(tag, tag3))
  {
    lcd.print("10VV1A0403");
    r_flag = 1;
    user_no = 3;
  }
  else if(compareTag(tag, tag6))
  {
    if(r_flag ==1)
    {
      lcd.print("Book 1          ");
      b_flag = 1;
      book_no = 1;
    }
  }
  else if(compareTag(tag, tag4))
  {
    if(r_flag ==1)
    {
      lcd.print("Book 6          ");
      b_flag = 1;
      book_no = 6;
    }
  }
  else if(compareTag(tag, tag5))
  {
    if(r_flag ==1)
    {
      lcd.print("Book 7          ");
      b_flag = 1;
      book_no = 7;
    }
  }
  else if(compareTag(tag, tag7))
  {
    if(r_flag ==1)
    {
      lcd.print("Book 2          ");
      b_flag = 1;
      book_no = 2;
    }
  }
  else if(compareTag(tag, tag8))
  {
    if(r_flag ==1)
    {
      lcd.print("Book 3          ");
      b_flag = 1;
      book_no = 3;
    }
  }
  else if(compareTag(tag, tag9))
  {
    if(r_flag ==1)
    {
      lcd.print("Book 4          ");
      b_flag = 1;
      book_no = 4;
    }
  }
  else if(compareTag(tag, tag10))
  {
    if(r_flag ==1)
    {
      lcd.print("Book 5          ");
      b_flag = 1;
      book_no = 5;
    }
  }
  else
  {
    lcd.setCursor(0, 0);
    lcd.print("INVALID CARD");
    delay(1000);
    lcd.setCursor(0, 0);
    lcd.print("Scanning.....  ");
  }

}

void clearTag(char one[]){
  ///////////////////////////////////
  //clear the char array by filling with null - ASCII 0
  //Will think same tag has been read otherwise
  ///////////////////////////////////
  for(int i = 0; i < strlen(one); i++){
    one[i] = 0;
  }
}

boolean compareTag(char one[], char two[])
{
  ///////////////////////////////////
  //compare two value to see if same,
  //strcmp not working 100% so we do this
  ///////////////////////////////////

  if(strlen(one) == 0) return false; //empty

  for(int i = 0; i < 8; i++){
    if(one[i] != two[i]) return false;
  }

  return true; //no mismatches
}




void setup() 
{
  lcd.begin(16, 2);
  Serial.begin(9600);
  RFID.begin(2400);
  pinMode(rxPin,INPUT); 
  pinMode(txPin,OUTPUT); 
  pinMode(button_one,INPUT);
  pinMode(button_two,INPUT);
  lcd.createChar(3, armsDown);  
  // create a new character
  lcd.createChar(4, armsUp); 
  lcd.setCursor(2, 0);
  lcd.print("Welcome To");
  lcd.setCursor(2,1);
  lcd.print("JNTUK (VZM)");
  for(i=0;i<8;i++)
  {
    lcd.setCursor(15, 1);
    // draw the little man, arms down:
    lcd.write(3);
    lcd.setCursor(0, 1);
    // draw the little man, arms down:
    lcd.write(3);
    delay(300);
    lcd.setCursor(15,1);
    // draw him arms up:
    lcd.write(4);
    lcd.setCursor(0,1);
    // draw him arms up:
    lcd.write(4);
    delay(300);    
  }  
  //delay(2000);
  lcd.clear();
  lcd.setCursor(0,0);  
  lcd.print("Scanning.....");
  issue3_flag = 0;
  return3_flag = 0;
  transaction1_flag = 0;
  view1_flag = 0;
  nocontinue2_flag = 0;
  continue2_flag = 0;
  bookenableflag=0;
}

void loop() 
{
  lcd.clear();
  lcd.setCursor(0,0);  
  lcd.print("Scanning.....");
  lcd.setCursor(0,1);
  rfid();
  checkTag(code); //Check if it is a match
  clearTag(code); //Clear the char of all value  
  delay(1000);
  if(r_flag == 1)
  {
    transaction();
    run_flag = 0;
    flag1 = 0;
    b_flag = 0;
    r_flag = 0;
  }
}

void invalied(void)
{
  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print("Invalid card      ") ;
  lcd.setCursor(0,1);
  lcd.print("Try Again      ") ;
  delay(2000);
  lcd.clear();
  lcd.setCursor(0,0);  
  lcd.print("Scanning.....");
}  

void transaction()
{
  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print("Press 1 for Issue ") ;
  lcd.setCursor(0,1);
  lcd.print("Press 2 for Return") ;
  while(!flag1)
  {
    b1state = digitalRead(button_one);
    b2state = digitalRead(button_two);
    if(b1state == LOW)
    {
      while(!b_flag)
      {
        if(c_flag == 0)
          issue();
        if(c_flag == 1)
        {
          lcd.clear();
          lcd.setCursor(0,0);
          lcd.print("Issue  ") ;
          lcd.setCursor(0,1);
          lcd.print("Scan the Book  ") ;
        }
        lcd.setCursor(0,1);
        rfid(); 
        checkTag(code); //Check if it is a match
        clearTag(code); //Clear the char of all value  
        delay(1000);
        lcd.clear();
        lcd.setCursor(0,0);
        lcd.print("Accept Press 1  ") ;
        lcd.setCursor(0,1);
        lcd.print("Cancel Press 2 ") ;
        lcd.setCursor(0,0);
      }
      while(!run_flag) 
      {
        b1state = digitalRead(button_one);
        b2state = digitalRead(button_two);
        if(b1state == LOW)
        {
           eeprom_buff = EEPROM.read(user1_loc+(book_no));
            if(eeprom_buff == book_no)
            {
              lcd.clear();
              lcd.setCursor(0,0);
              lcd.print("Already issued") ;
              lcd.setCursor(0,1);
              lcd.print("Take Another") ;
              delay(2000);
              run_flag = 1;
              flag1 = 1;
              c_flag = 0;
              return;
            }
             eeprom_buff = EEPROM.read(user2_loc+(book_no));
            if(eeprom_buff == book_no)
            {
              lcd.clear();
              lcd.setCursor(0,0);
              lcd.print("Already issued") ;
              lcd.setCursor(0,1);
              lcd.print("Take Another") ;
              delay(2000);
              run_flag = 1;
              flag1 = 1;
              c_flag = 0;
              return;
            }
             eeprom_buff = EEPROM.read(user3_loc+(book_no));
            if(eeprom_buff == book_no)
            {
              lcd.clear();
              lcd.setCursor(0,0);
              lcd.print("Already issued") ;
              lcd.setCursor(0,1);
              lcd.print("Take Another") ;
              delay(2000);
              run_flag = 1;
              flag1 = 1;
              c_flag = 0;
              return;
            }
          
          if(user_no == 1)
          {
            eeprom_buff = EEPROM.read(user1_loc);
            if(eeprom_buff >= book_count)
            {
              lcd.clear();
              lcd.setCursor(0,0);
              lcd.print("Account is Full") ;
              lcd.setCursor(0,1);
              lcd.print("Return some Books") ;
              delay(2000);
              delay(1000);
              run_flag = 1;
              flag1 = 1;
              c_flag = 0; 
            }  
            if(eeprom_buff < book_count)
            {  
              eeprom_buff = EEPROM.read(user1_loc);
              lcd.clear();
              lcd.setCursor(0,0);
              lcd.print("Books in Account") ;
              Serial.println(eeprom_buff+1);
              Serial.println(book_count);
              EEPROM.write(user1_loc,eeprom_buff+1);
              lcd.setCursor(0,1);
              eeprom_buff = EEPROM.read(user1_loc);
              lcd.write((0x30+eeprom_buff));                                   
              EEPROM.write(user1_loc+(book_no),book_no);
              delay(1000);
              run_flag = 1;
              flag1 = 1;
              c_flag = 0;
            } 
          }   

          if(user_no == 2)
          {
            eeprom_buff = EEPROM.read(user2_loc);
            lcd.clear();
            lcd.setCursor(0,0);
            if(eeprom_buff >= book_count)
            {
              lcd.clear();
              lcd.setCursor(0,0);
              lcd.print("Account is Full") ;
              lcd.setCursor(0,1);
              lcd.print("Return some Books") ;
              delay(2000);
              delay(1000);
              run_flag = 1;
              flag1 = 1;
              c_flag = 0; 
            }                 
            if(eeprom_buff < book_count)
            { 
              lcd.print("Books in Account") ;
              EEPROM.write(user2_loc,eeprom_buff+1);
              Serial.println(eeprom_buff+1);
              Serial.println(book_count);
              lcd.setCursor(0,1);
              eeprom_buff = EEPROM.read(user2_loc);
              lcd.write((0x30+eeprom_buff));

              EEPROM.write(user2_loc+(book_no),book_no);
              delay(1000);
              run_flag = 1;
              flag1 = 1;
              c_flag = 0;
            }
          }  

          if(user_no == 3)
          {
            eeprom_buff = EEPROM.read(user3_loc);
            if(eeprom_buff >= book_count)
            {
              lcd.clear();
              lcd.setCursor(0,0);
              lcd.print("Account is Full") ;
              lcd.setCursor(0,1);
              lcd.print("Return some Books") ;
              delay(2000);
              delay(1000);
              run_flag = 1;
              flag1 = 1;
              c_flag = 0; 
            }
            if(eeprom_buff < book_count)
            {  
              eeprom_buff = EEPROM.read(user3_loc);
              lcd.clear();
              lcd.setCursor(0,0);
              lcd.print("Books in Account") ;
              Serial.println(eeprom_buff+1);
              Serial.println(book_count);
              EEPROM.write(user3_loc,eeprom_buff+1);
              lcd.setCursor(0,1);
              eeprom_buff = EEPROM.read(user3_loc);
              lcd.write((0x30+eeprom_buff));

              EEPROM.write(user3_loc+(book_no),book_no);
              delay(1000);
              run_flag = 1;
              flag1 = 1;
              c_flag = 0;
            } 
          }


        }
        if(b2state == LOW)
        {
          lcd.clear();
          lcd.setCursor(0,0);
          lcd.print("Task Aborded") ;
          delay(1000);
          run_flag = 1;
          flag1 = 1;
          c_flag = 0;
        }    
      } 
    }
    if(b2state == LOW)
    {
      while(!b_flag)
      {
        lcd.clear();
        lcd.setCursor(0,0);
        lcd.print("Return  ") ;
        lcd.setCursor(0,1);
        lcd.print("Scan the Book  ") ;
        lcd.setCursor(0,1);
        rfid(); 
        checkTag(code); //Check if it is a match
        clearTag(code); //Clear the char of all value  
        delay(1000);
        lcd.clear();
        lcd.setCursor(0,0);
        lcd.print("Accept Press 1  ") ;
        lcd.setCursor(0,1);
        lcd.print("Cancel Press 2  ") ;
      } 
      while(!run_flag) 
      {
        b1state = digitalRead(button_one);
        b2state = digitalRead(button_two);
        if(b1state == LOW)
        {
          if(user_no == 1)
          {
            eeprom_buff = EEPROM.read(user1_loc+(book_no));
            if(eeprom_buff != book_no)
            {
              lcd.clear();
              lcd.setCursor(0,0);
              lcd.print("Registry Inc__") ;
              lcd.setCursor(0,1);
              lcd.print("Task Aborted") ;
              delay(1500);
              run_flag = 1;
              flag1 = 1;
              return;
            }
            eeprom_buff = EEPROM.read(user1_loc);
            lcd.clear();
            lcd.setCursor(0,0);
            lcd.print("Books in Account") ;
            EEPROM.write(user1_loc,eeprom_buff-1);
            lcd.setCursor(0,1);
            eeprom_buff = EEPROM.read(user1_loc);
            lcd.write((0x30+eeprom_buff));
            EEPROM.write(user1_loc+(book_no),0x00);
            delay(1000);
            run_flag = 1;
            flag1 = 1;
          }   
          if(user_no == 2)
          {
            eeprom_buff = EEPROM.read(user2_loc+(book_no));
            if(eeprom_buff != book_no)
            {
              lcd.clear();
              lcd.setCursor(0,0);
              lcd.print("Registry Inc__") ;
              lcd.setCursor(0,1);
              lcd.print("Task Aborted") ;
              delay(1500);
              run_flag = 1;
              flag1 = 1;
              return;
            }
            eeprom_buff = EEPROM.read(user2_loc);
            lcd.clear();
            lcd.setCursor(0,0);
            lcd.print("Books in Account") ;
            EEPROM.write(user2_loc,eeprom_buff-1);
            lcd.setCursor(0,1);
            eeprom_buff = EEPROM.read(user2_loc);
            lcd.write((0x30+eeprom_buff));

            EEPROM.write(user2_loc+(book_no),0x00);
            delay(1000);
            run_flag = 1;
            flag1 = 1;
          }   

          if(user_no == 3)
          {
            eeprom_buff = EEPROM.read(user3_loc+(book_no));
            if(eeprom_buff != book_no)
            {
              lcd.clear();
              lcd.setCursor(0,0);
              lcd.print("Registry Inc__") ;
              lcd.setCursor(0,1);
              lcd.print("Task Aborted") ;
              delay(1500);
              run_flag = 1;
              flag1 = 1;
              return;
            }
            eeprom_buff = EEPROM.read(user3_loc);
            lcd.clear();
            lcd.setCursor(0,0);
            lcd.print("Books in Account") ;
            EEPROM.write(user3_loc,eeprom_buff-1);
            lcd.setCursor(0,1);
            eeprom_buff = EEPROM.read(user3_loc);
            lcd.write((0x30+eeprom_buff));

            EEPROM.write(user3_loc+(book_no),0x00);
            delay(1000);
            run_flag = 1;
            flag1 = 1;
          }   

         /* if(user_no == 4)
          {
            eeprom_buff = EEPROM.read(user4_loc+(book_no));
            if(eeprom_buff != book_no)
            {
              lcd.clear();
              lcd.setCursor(0,0);
              lcd.print("Registry Inc__") ;
              lcd.setCursor(0,1);
              lcd.print("Task Aborted") ;
              delay(1500);
              run_flag = 1;
              flag1 = 1;
              return;
            }
            eeprom_buff = EEPROM.read(user4_loc);
            lcd.clear();
            lcd.setCursor(0,0);
            lcd.print("Books in Account") ;
            EEPROM.write(user4_loc,eeprom_buff-1);
            lcd.setCursor(0,1);
            eeprom_buff = EEPROM.read(user4_loc);
            lcd.write((0x30+eeprom_buff));

            EEPROM.write(user4_loc+(book_no),0x00);
            delay(1000);
            run_flag = 1;
            flag1 = 1;
          }   

          if(user_no == 5)
          {
            eeprom_buff = EEPROM.read(user5_loc+(book_no));
            if(eeprom_buff != book_no)
            {
              lcd.clear();
              lcd.setCursor(0,0);
              lcd.print("Registry Inc__") ;
              lcd.setCursor(0,1);
              lcd.print("Task Aborted") ;
              delay(1500);
              run_flag = 1;
              flag1 = 1;
              return;
            }
            eeprom_buff = EEPROM.read(user5_loc);
            lcd.clear();
            lcd.setCursor(0,0);
            lcd.print("Books in Account") ;
            EEPROM.write(user5_loc,eeprom_buff-1);
            lcd.setCursor(0,1);
            eeprom_buff = EEPROM.read(user5_loc);
            lcd.write((0x30+eeprom_buff));

            EEPROM.write(user5_loc+(book_no),0x00);
            delay(1000);
            run_flag = 1;
            flag1 = 1;
          } */  
        }
        if(b2state == LOW)
        {
          lcd.clear();
          lcd.setCursor(0,0);
          lcd.print("Task Aborted") ;
          delay(1000);
          run_flag = 1;
          flag1 = 1;
        }
      } 

    } 
  }
  //delay(2000);
}

void issue()
{
  if(user_no == 1)
  {
    eeprom_buff = EEPROM.read(user1_loc);
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("Books in Acc: ") ;
    lcd.write(0x30+eeprom_buff);
    lcd.setCursor(0,1);
    delay(1000);
    if(eeprom_buff > book_count)
    {
      lcd.clear();
      lcd.setCursor(0,0);
      lcd.print("Account is Full") ;
      lcd.setCursor(0,1);
      lcd.print("Return some Books") ;
      delay(2000);
      run_flag = 1;
      flag1 = 1;
      b_flag = 1;
      return;
    }
    for(unsigned char z=1;z<=booklimit;z++)
    {
      eeprom_buff = EEPROM.read(user1_loc+z);
      if(eeprom_buff != 0)
      {
        lcd.write(0x30+eeprom_buff);
      }                    
    }
    delay(2000); 
    c_flag = 1;
  }


  if(user_no == 2)
  {
    eeprom_buff = EEPROM.read(user2_loc);
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("Books in Acc: ") ;
    lcd.write(0x30+eeprom_buff);
    lcd.setCursor(0,1);
    delay(1000);
    if(eeprom_buff > book_count)
    {
      lcd.clear();
      lcd.setCursor(0,0);
      lcd.print("Account is Full") ;
      lcd.setCursor(0,1);
      lcd.print("Return some Books") ;
      delay(2000);
      run_flag = 1;
      flag1 = 1;
      b_flag = 1;
      return;
    }
    for(unsigned char z=0;z<=booklimit;z++)
    {
      eeprom_buff = EEPROM.read((user2_loc+1)+z);
      if(eeprom_buff != 0)
      {
        lcd.write(0x30+eeprom_buff);
      }                    
    }
    delay(2000); 
    c_flag = 1;
  }

  if(user_no == 3)
  {
    eeprom_buff = EEPROM.read(user3_loc);
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("Books in Acc: ") ;
    lcd.write(0x30+eeprom_buff);
    lcd.setCursor(0,1);
    delay(1000);
    if(eeprom_buff > book_count)
    {
      lcd.clear();
      lcd.setCursor(0,0);
      lcd.print("Account is Full") ;
      lcd.setCursor(0,1);
      lcd.print("Return some Books") ;
      delay(2000);
      run_flag = 1;
      flag1 = 1;
      b_flag = 1;
      return;
    }
    for(unsigned char z=0;z<=booklimit;z++)
    {
      eeprom_buff = EEPROM.read((user3_loc+1)+z);
      if(eeprom_buff != 0)
      {
        lcd.write(0x30+eeprom_buff);
      }                    
    }
    delay(2000); 
    c_flag = 1;
  }

 /* if(user_no == 4)
  {
    eeprom_buff = EEPROM.read(user4_loc);
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("Books in Acc: ") ;
    lcd.write(0x30+eeprom_buff);
    lcd.setCursor(0,1);
    delay(1000);
    if(eeprom_buff > book_count)
    {
      lcd.clear();
      lcd.setCursor(0,0);
      lcd.print("Account is Full") ;
      lcd.setCursor(0,1);
      lcd.print("Return some Books") ;
      delay(2000);
      run_flag = 1;
      flag1 = 1;
      b_flag = 1;
      return;
    }
    for(unsigned char z=0;z<=booklimit;z++)
    {
      eeprom_buff = EEPROM.read((user4_loc+1)+z);
      if(eeprom_buff != 0)
      {
        lcd.write(0x30+eeprom_buff);
      }                    
    }
    delay(2000); 
    c_flag = 1;
  }

  if(user_no == 5)
  {
    eeprom_buff = EEPROM.read(user5_loc);
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("Books in Acc: ") ;
    lcd.write(0x30+eeprom_buff);
    lcd.setCursor(0,1);
    delay(1000);
    if(eeprom_buff > book_count)
    {
      lcd.clear();
      lcd.setCursor(0,0);
      lcd.print("Account is Full") ;
      lcd.setCursor(0,1);
      lcd.print("Return some Books") ;
      delay(2000);
      run_flag = 1;
      flag1 = 1;
      b_flag = 1;
      return;
    }
    for(unsigned char z=0;z<=booklimit;z++)
    {
      eeprom_buff = EEPROM.read((user5_loc+1)+z);
      if(eeprom_buff != 0)
      {
        lcd.write(0x30+eeprom_buff);
      }                    
    }
    delay(2000); 
    c_flag = 1;
  }*/

}



void return_b()
{
  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print("Scan the book") ;
  while(1);
}

void view()
{
  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print("Books in your Acc") ;
  while(1);
}

void rfid(void)
{
  address=0;
  if(RFID.available() > 0)
  {  
    bytesread = 0; 
    while(bytesread<9)
    {  
      if(RFID.available() > 0)
      {     
        val = RFID.read(); 
        if((val == 10)||(val == 13))
        { 
          code[bytesread] = ' ';  
          bytesread++;                  
        } 
        else
        {   
          code[bytesread] = val;                  
          bytesread++;                  
        } 
      }
      if(bytesread == 9)
      {  
        ok_flag = 1;
      }
    }
    bytesread = 0; 
  } 

}














