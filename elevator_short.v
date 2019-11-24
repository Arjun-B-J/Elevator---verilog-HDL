//Elevator Algorithm
module elevator_5(req_floor,powerlevel,motor,weight,temperature_input,fan_speed,fan_rpm,clk,complete,direction,over_weight,out_floor);

//inputs
input[2:0]req_floor;
input clk;
input [10:0] weight;
input [7:0] temperature_input;

//output
output  complete;
output  over_weight;
output  [2:0]out_floor;
output  [2:0]powerlevel;
output  [7:0]motor;
output  [1:0]fan_speed;
output  [11:0]fan_rpm;

//temps
reg [2:0]ram[7:0];
reg [10:0]ramw[7:0];
reg temp_complete;
reg temp_over_weight;
reg [2:0]temp_out_floor;
reg [2:0]r_floor;
reg [3:0] i,j,k,l;
reg [2:0]min;


//assigning temp variables
assign direction=temp_direction;
assign complete=temp_complete;
assign over_weight = temp_over_weight;
assign out_floor = temp_out_floor;

powersavingmotor power1(powerlevel,motor,weight);
temperature_controlled_fan fan1(fan_speed,fan_rpm,temperature_input);

initial
begin
temp_out_floor=1;
temp_complete=1;
r_floor=0;
temp_over_weight=0;
end

always@(req_floor) 
 begin
   ram[req_floor]=req_floor;
   ramw[req_floor]=weight;
 end

/*always@(weight)
 begin
    if(weight>899)
    temp_over_weight=1;
    else
    temp_over_weight=0;
 end*/

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//short elevator algorithm.


 /// to assign direction and out floor
 always@(posedge clk)
 begin
   //temp_complete=0;
 if(!over_weight && r_floor!=0)
   begin
     
     if (r_floor>temp_out_floor)
        begin
           // temp_direction = 1;
            temp_out_floor <= temp_out_floor+1;

	     if(ram[temp_out_floor])
	     begin
          if(ramw[temp_out_floor]>900)
	    	begin
			temp_over_weight=1;
	    	end
		  else
		    begin
			temp_over_weight=0;
		    end
		  temp_complete=1;
		  ram[temp_out_floor]=0;
		  ramw[temp_out_floor]=0;
  	     end 
        end
     
       if (r_floor< temp_out_floor)
        begin
           // temp_direction = 2;
            temp_out_floor = temp_out_floor-1;
	     if(ram[temp_out_floor])
	     begin
		  if(ramw[temp_out_floor]>900)
		   begin
			temp_over_weight=1;
	       end
		  else
		   begin
			temp_over_weight=0;
		   end
		 temp_complete=1;
		 ram[temp_out_floor]=0;
		 ramw[temp_out_floor]=0;
  	     end 
        end
     
        if (r_floor == temp_out_floor)
        begin
	    if(ramw[temp_out_floor]>900)
	    begin
			temp_over_weight=1;
	    end
	    else
	    begin
			temp_over_weight=0;
        end
           temp_complete = 1;
           ram[r_floor]=0;
	       ramw[temp_out_floor]=0;
           r_floor=0;
        end
    
    end          

  else if (over_weight)
    begin
        //temp_weight_alert=1;
        temp_complete=1;
        temp_out_floor <= temp_out_floor;
    end

end
/*always@(temp_out_floor)
begin
//for(k=0;k<8;k++)
if(r_floor==0)
temp_complete=1;
end*/
endmodule