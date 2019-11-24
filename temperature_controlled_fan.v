//fan rpm
module fanrpm_control(fan_speed,rpm);

input [1:0] fan_speed;
output [11:0]rpm;

reg [11:0] temp_rpm;

assign rpm = temp_rpm;

//loop
always@(fan_speed)
begin
 //speed 1
 if(fan_speed==1)
   begin
     temp_rpm = 1000;
   end
  //speed2 
  else if(fan_speed==2)
   begin
     temp_rpm =2000;
   end
  //speed3
  else 
   begin
    temp_rpm = 3000;
   end  
end

endmodule

//temperature controller
module temperature_controlled_fan(fan_speed,fan_rpm,temperature_input);

input [7:0]temperature_input;
output [1:0]fan_speed;
output [11:0]fan_rpm;
reg [1:0]fs;

assign fan_speed = fs;
fanrpm_control f (fan_speed,fan_rpm);
always@(temperature_input)
begin

 if(temperature_input<23)
  begin
    fs = 1;
  end
 else if(temperature_input>22&&temperature_input<27)
  begin
    fs = 2;
  end
 else
  begin
    fs = 3;
  end

end 

endmodule