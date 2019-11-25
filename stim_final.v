module aastim_final;

reg [2:0]req_floor1,req_floor2;
reg clk;
reg [10:0] weight;
reg [7:0]temperature_input;

wire [1:0]fan_speed;
wire [11:0]fan_rpm;
wire [2:0]powerlevel;
wire [7:0]turnover1,turnover2;
wire [1:0]direction1,direction2;
wire complete1,complete2;wire over_weight1,over_weight2;
wire [2:0]out_floor1,out_floor2;

main_ m1(req_floor1,req_floor2,,weight,clk,complete1,complete2,direction1,direction2,over_weight1,over_weight2,out_floor1,out_floor2,powerlevel,fan_speed,fan_rpm,temperature_input,turnover1,turnover2);

initial
begin
#2 clk=1'b0;
end

always
begin
#1 clk=~clk;
end

initial
begin
	//normal
	/*req_floor1=3;temperature_input=30;weight=250;req_floor2=3;
	#1; req_floor1=5;temperature_input=40;weight=500;req_floor2=5;
	#4; req_floor1=4;temperature_input=20;weight=350;req_floor2=4;
	#8 req_floor1=7;temperature_input=30;weight=250;req_floor2=7;*/

	//diff between algorithms turnover better for 2nd
	/*req_floor1=4;temperature_input=30;weight=250;req_floor2=4;
	#1 req_floor1=7;temperature_input=20;weight=350;req_floor2=7;
	#5 req_floor1=2;temperature_input=40;weight=500;req_floor2=2;*/

	//overweight
	/*req_floor1=4;temperature_input=30;weight=250;req_floor2=4;
	#2 req_floor1=7;temperature_input=20;weight=1000;req_floor2=7;
	#3 req_floor1=2;temperature_input=40;weight=500;req_floor2=2;*/

  	//turnover better for 1st
	/*req_floor1=3;temperature_input=40;weight=500;req_floor2=3;
	#1 req_floor1=7;temperature_input=40;weight=200;req_floor2=7;
	#3 req_floor1=1;temperature_input=40;weight=700;req_floor2=1;
	#10 req_floor1=2;temperature_input=50;weight=500;
	#10 req_floor2=2;*/

	req_floor1=4;temperature_input=45;weight=300;req_floor2=4;
	#2 req_floor1=2;temperature_input=45;weight=500;req_floor2=2;
	#2 req_floor1=1;temperature_input=60;weight=700;req_floor2=1;
	#2 req_floor1=6;temperature_input=45;weight=400;req_floor2=6;
	#2 req_floor1=2;temperature_input=70;weight=300;req_floor2=2;
	
end
endmodule









