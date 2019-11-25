//Main
module main_(req_floor1,req_floor2,,weight,clk,complete1,complete2,direction1,direction2,over_weight1,over_weight2,out_floor1,out_floor2,powerlevel,fan_speed,fan_rpm,temperature_input,turnover1,turnover2);

//inputs
input [2:0]req_floor1,req_floor2;
input clk;
input [10:0] weight;
input [7:0]temperature_input;

//outputs
output [1:0]fan_speed;
output [11:0]fan_rpm;
output [2:0]powerlevel;
output [7:0]turnover1,turnover2;
output [1:0]direction1,direction2;
output complete1,complete2;
output over_weight1,over_weight2;
output [2:0]out_floor1,out_floor2;


temperature_controlled_fan fan1(fan_speed,fan_rpm,temperature_input);
powersavingmotor motor1(powerlevel,weight);
Elevator_algorithm e1(req_floor1,weight,clk,complete1,direction1,over_weight1,out_floor1,turnover1);
Short_distance_algorithm e2(req_floor2,weight,clk,complete2,direction2,over_weight2,out_floor2,turnover2);

endmodule

//Elevator Algoritm
module Elevator_algorithm(req_floor,weight,clk,complete,direction,over_weight,out_floor,turnover1);

//inputs
input[2:0]req_floor;
input clk;
input [10:0] weight;

//outputs
output  [1:0]direction;
output  complete;
output  over_weight;
output  [2:0]out_floor;
output reg [7:0]turnover1;

//temps
reg [2:0]ram[7:0];
reg [10:0]ramw[7:0];
reg [1:0]temp_direction;
reg temp_complete;
reg temp_over_weight;
reg [2:0]temp_out_floor;
reg [2:0]r_floor;
reg [3:0] i,j,k,l;


//assigning temp variables
assign direction=temp_direction;
assign complete=temp_complete;
assign over_weight = temp_over_weight;
assign out_floor = temp_out_floor;

initial
begin
temp_out_floor=1;
temp_direction=0;
temp_complete=1;
r_floor=0;
temp_over_weight=0;
turnover1 =0;
end


always@(req_floor) 
 begin
   ram[req_floor]=req_floor;
   ramw[req_floor]=weight;
 end

always@(posedge clk)
 begin
   if(r_floor==0)
   begin
   /// idle or lift is moving up.
    if(temp_direction==1 || temp_direction==0)
     
     begin
        for(i=7;i>temp_out_floor;i=i-1)
          begin
          
            if(ram[i])
            begin
                r_floor=ram[i];
                temp_complete=0;
                temp_direction=1;
            end
          end
        
      
        if(r_floor==0)
         begin
             for(j=1;j<temp_out_floor;j=j+1)
             begin
                 if(ram[j])
                 begin
                  r_floor=ram[j];
                  temp_complete=0;
                  temp_direction=2;
                 end
             end
         end   end  
    /// lift moving down
     else
        begin
        for(k=1;k<temp_out_floor;k=k+1)
          begin
            if(ram[k])
            begin
                r_floor=ram[k];
                 temp_complete=0;
                //temp_direction=2;
            end
          end
        
        //if floor not found down check up;
        if(r_floor==0)
        begin
            for(l=7;l>temp_out_floor;l=l-1)
            begin
                if(ram[l])
                begin
                    r_floor=ram[l];
                    temp_complete=0;
                    temp_direction=1;
                end
            end
        end
      end
    end
   end  

 /// to assign direction and out floor
 always@(posedge clk)
 begin
   temp_complete=0;
   temp_over_weight=0;
 if(!over_weight && r_floor!=0)
   begin
     
     if (r_floor>temp_out_floor)
        begin
           // temp_direction = 1;
            temp_out_floor = temp_out_floor+1;
            turnover1 = turnover1+1;   
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
		temp_complete=1;#2;
		temp_over_weight=0;
		temp_complete=0;#2;
		ram[temp_out_floor]=0;
		ramw[temp_out_floor]=0;
  	     end 
        end
     
       if (r_floor< temp_out_floor)
        begin
           // temp_direction = 2;
            temp_out_floor = temp_out_floor-1;
            turnover1 = turnover1+1;
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
		temp_complete=1;#2;
		temp_over_weight=0;
		temp_complete=0;#2;
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
            //temp_complete = 1;
	    //temp_complete=0;#2;
           // temp_direction = 0;
            ram[r_floor]=0;
	    ramw[temp_out_floor]=0;
            r_floor=0;
        end
    
    end          

  else if (over_weight)
    begin
        //temp_weight_alert=1;
        temp_direction=0;
        temp_complete=1;#2;
        temp_out_floor <= temp_out_floor;
    end

end
endmodule


//shortest distance algorithm
module Short_distance_algorithm(req_floor,weight,clk,complete,direction,over_weight,out_floor,turnover2);

//inputs
input[2:0]req_floor;
input clk;
input [10:0] weight;

//outputs
output reg [7:0]turnover2;
output  [1:0]direction;
output  complete;
output  over_weight;
output  [2:0]out_floor;

//temps
reg [2:0]ram[7:0];
reg [10:0]ramw[7:0];
reg [1:0]temp_direction;
reg temp_complete;
reg temp_over_weight;
reg [2:0]temp_out_floor;
reg [2:0]r_floor;
reg [3:0] i,j,k,l,a,b;
reg [2:0]rd_floor,ru_floor;


//assigning temp variables
assign direction=temp_direction;
assign complete=temp_complete;
assign over_weight = temp_over_weight;
assign out_floor = temp_out_floor;

initial
begin
temp_out_floor=1;
temp_direction=0;
temp_complete=1;
r_floor=0;
temp_over_weight=0;
turnover2 =0;
end


always@(req_floor) 
 begin
   ram[req_floor]=req_floor;
   ramw[req_floor]=weight;
 end


always@(posedge clk)
 begin
   if(r_floor==0)
   begin
	ru_floor=0;
	rd_floor=0;
   /// idle or lift is moving up.
    if(temp_direction==1 || temp_direction==0)
     
     begin
        for(i=7;i>temp_out_floor;i=i-1)
          begin
          
            if(ram[i])
            begin
                ru_floor=ram[i];
            end
          end
	 for(a=1;a<temp_out_floor;a=a+1)
	 begin
		if(ram[a])
		  rd_floor=ram[a];
	 end
        
	if(ru_floor && rd_floor)
	begin
	if(ru_floor-temp_out_floor<=temp_out_floor-rd_floor) 
	begin
		r_floor=ru_floor;
		temp_complete=0;
		temp_direction=1;
	end
	else
	begin
		r_floor=rd_floor;
		temp_complete=0;
		temp_direction=2;
	end
	end
	else if(rd_floor==0)
	begin
		r_floor=ru_floor;
		temp_complete=0;
		temp_direction=1;
	end
	else if(ru_floor==0)
	begin
		r_floor=rd_floor;
		temp_complete=0;
		temp_direction=2;
	end
      end
    /// lift moving down
     else
        begin
        for(k=1;k<temp_out_floor;k=k+1)
          begin
            if(ram[k])
            begin
                rd_floor=ram[k];
            end
          end
        
	for(b=7;b>temp_out_floor;b=b-1)
	begin
		if(ram[b])
			ru_floor=ram[b];
	end
	if(ru_floor && rd_floor)
	begin
	if(ru_floor-temp_out_floor<=temp_out_floor-rd_floor)
	begin
		r_floor=ru_floor;
		temp_complete=0;
		temp_direction=1;
	end
	else
	begin
		r_floor=rd_floor;
		temp_complete=0;
		temp_direction=2;
	end
	end
	else if(ru_floor==0)
	begin
		r_floor=rd_floor;
		temp_complete=0;
		temp_direction=2;
	end
	else if(rd_floor==0)
	begin
		r_floor=ru_floor;
		temp_complete=0;
		temp_direction=1;
	end
      end
    end
   end  
 /// to assign direction and out floor
 always@(posedge clk)
 begin
   temp_complete=0;
   temp_over_weight=0;
 if(!over_weight && r_floor!=0)
   begin
     
     if (r_floor>temp_out_floor)
        begin
           // temp_direction = 1;
            temp_out_floor = temp_out_floor+1;
            turnover2 = turnover2 + 1;
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
		temp_complete=1;#2;
		temp_over_weight=0;
		temp_complete=0;#2;
		ram[temp_out_floor]=0;
		ramw[temp_out_floor]=0;
  	     end 
        end
     
       if (r_floor< temp_out_floor)
        begin
           // temp_direction = 2;
            temp_out_floor = temp_out_floor-1;
            turnover2 = turnover2 +1;
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
		temp_complete=1;#2;
		temp_over_weight=0;
		temp_complete=0;#2;
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
            //temp_complete = 1;#2;
	    //temp_complete=0;#2;
           // temp_direction = 0;
            ram[r_floor]=0;
	    ramw[temp_out_floor]=0;
            r_floor=0;
        end
    
    end          

  else if (over_weight)
    begin
        //temp_weight_alert=1;
        temp_direction=0;
        temp_complete=1;#2;
        temp_out_floor <= temp_out_floor;
    end

end

endmodule

//POWER SAVING MOTOR MODULE.
module powersavingmotor(powerlevel,weight);

//inputs
input [10:0]weight;

//outputs
output [2:0]powerlevel;


reg [2:0]pl;

assign powerlevel = pl;
//level 1

always@(weight)
begin

if(weight<200)
  begin
    pl=1;
  end

//level 2
if(weight<400&&weight>199)
  begin
    pl=2;
  end

//level 3
if(weight<600&&weight>399)
  begin
    pl=3;
  end

 //level 4
if(weight<800&&weight>599)
  begin
    pl=4;
  end

 //level 5
if(weight>799 && weight <1000)
  begin
    pl=5;
  end

end

endmodule


///temperature controlled Fan
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
