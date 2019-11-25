import serial
import time
 # open the port , set bandrate as 9600
serial_monitor = serial.Serial('/dev/ttyACM1', 9600 )
# open the file to write
f = open('temp_readings.log', 'w') 
while True:
    # wait for 1000 seconds
    time.sleep(1000) 
    # read the temparature value
    temp = serial_monitor.readline() 
    # write the integer temparature value to file
    f.write(int(temp)) 