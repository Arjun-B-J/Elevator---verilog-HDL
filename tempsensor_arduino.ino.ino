void setup() {
  Serial.begin(9600);
}

void loop() {
  // read from the pin 7, where LM35 is connected
  float reading = analogRead(7);
  // scale the value to temp as per datasheet
  float temp = reading * 0.49; 
  // send the data to serial
  Serial.print(temp);
  delay(1000*1000);//wait for 1000 seconds
}
