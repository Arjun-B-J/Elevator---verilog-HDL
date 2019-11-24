module fansim;
wire  [1:0]fan_speed;
wire  [11:0] fan_rpm;
reg [7:0] temperature_input;
temperature_controlled_fan fan1(fan_speed,fan_rpm,temperature_input);
initial
begin
    temperature_input = 22; #10;
    temperature_input =25; #10;
end
endmodule