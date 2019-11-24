//Main
module main_(req_floor,weight,clk,complete,direction,over_weight,out_floor,powerlevel,motor,fan_speed,fan_rpm,temperature_input,algorithm_selector);

//inputs
input [2:0]req_floor;
input clk;
input [10:0] weight;
input [7:0]temperature_input;
input algorithm_selector;

//outputs
output [1:0]fan_speed;
output [11:0]fan_rpm;
output [2:0]powerlevel;
output [7:0]motor;
output reg [1:0]direction;
output reg complete;
output reg over_weight;
output reg [2:0]out_floor;

wire [2:0] out1,out2;
wire cmpt1,cmpt2;
wire ovweight1,ovweight2;
wire [1:0]d1,d2;


temperature_controlled_fan fan1(fan_speed,fan_rpm,temperature_input);
powersavingmotor motor1(powerlevel,motor,weight);
Elevator_algorithm e1(req_floor,weight,clk,cmpt1,d1,ovweight1,out1);
Short_distance_algorithm e2(req_floor,weight,clk,cmpt2,d2,ovweight2,out2);

always@(clk)
begin
if(algorithm_selector==1)
begin
     complete=cmpt1;
     direction=d1;
     over_weight=ovweight1;
     out_floor=out1;
end

else 
begin
     complete=cmpt2;
     direction=d2;
     over_weight=ovweight2;
     out_floor=out2;
end
end

endmodule
//Elevator Algoritm
module Elevator_algorithm(req_floor,weight,clk,complete,direction,over_weight,out_floor);

//inputs
input[2:0]req_floor;
input clk;
input [10:0] weight;

//outputs
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








//shortest distance algorithm
module Short_distance_algorithm(req_floor,weight,clk,complete,direction,over_weight,out_floor);

//inputs
input[2:0]req_floor;
input clk;
input [10:0] weight;

//outputs
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
end


always@(req_floor) 
 begin
   ram[req_floor]=req_floor;
   ramw[req_floor]=weight;
 end

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



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
                //temp_complete=0;
                //temp_direction=1;
            end
          end
	 for(a=1;a<temp_out_floor;a=a+1)
	 begin
		if(ram[a])
		  rd_floor=ram[a];
	 end
        
      
        /*if(r_floor==0)
         begin
             for(j=temp_out_floor;j>0;j=j-1)
             begin
                 if(ram[j])
                 begin
                  ru_floor=ram[j];
                  //temp_complete=0;
                  //temp_direction=2;
                 end
             end
         end   end */
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
                 //temp_complete=0;
                //temp_direction=2;
            end
          end
        
        //if floor not found down check up;
        /*if(r_floor==0)
        begin
            for(l=temp_out_floor;l<8;l=l+1)
            begin
                if(ram[l])
                begin
                    r_floor=ram[l];
                    temp_complete=0;
                    temp_direction=1;
                end
            end
        end*/
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


///Power control Module

module not_gate (c1,a1);
output c1;
input a1;
nand(c1,a1,a1);
endmodule

module and_gate(c2,a2,b2);
output c2;
input a2,b2;
wire x2;
nand(x2,a2,b2);
nand(c2,x2,x2);
endmodule

module or_gate(c3,a3,b3);
output c3;
input a3,b3;
wire x3,y3;
nand(x3,a3,a3);
nand(y3,b3,b3);
nand(c3,x3,y3);
endmodule

module DeCoder2(e,i,o) ;

output [1:0] o ;
input e,i ;
wire i_ ;

NotGate Ne(i,i_) ;
AndGate O1(i_,e,o[0]) ;
AndGate O2(i,e,o[1]) ;

endmodule 

module DeCoder4(e,i,o) ;

output [3:0] o ;
input [1:0] i ;
input e ;
wire [1:0] t ;

DeCoder2 D1(e,i[1],t[1:0]) ;
DeCoder2 D2(t[1],i[0],o[3:2]) ;
DeCoder2 D3(t[0],i[0],o[1:0]) ;

endmodule 

module DeCoder8(e,i,o) ;

output [7:0] o ;
input [2:0] i ;
input e ;
wire [1:0] t ;

DeCoder2 D1(e,i[2],t[1:0]);
DeCoder4 D2(t[0],i[1:0],o[3:0]) ;
DeCoder4 D3(t[1],i[1:0],o[7:4]) ;

endmodule 

//POWER SAVING MOTOR MODULE.
module powersavingmotor(powerlevel,motor,weight);

//inputs
input [10:0]weight;

//outputs
output [2:0]powerlevel;
output [7:0]motor;

reg [2:0]pl;

DeCoder8 d1(1'b1,pl,motor); 

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