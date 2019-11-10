module elevator(req_floor,in_floor,weight,clk,reset,complete,direction,over_weight,out_floor);

//inputs
input[2:0]req_floor;
input[2:0]in_floor;
input clk,reset;
input [10:0] weight;

//outputs
output  [1:0]direction;
output  complete;
output over_weight;
output [2:0]out_floor;

//temps
reg [2:0]ram[7:0];
reg [1:0]temp_direction;
reg temp_complete;
reg temp_over_weight;
reg [2:0]temp_out_floor;
reg [2:0]r_floor;
reg [2:0] i;

//clocks
reg [12:0] clk_count;
reg clk_200;
reg clk_trigger;

//assigning temp variables
assign direction=temp_direction;
assign complete=temp_complete;
assign over_weight = temp_over_weight;
assign out_floor = temp_out_floor;

initial
begin
temp_out_floor=0;
temp_direction=0;
temp_complete=1;
end

always@(negedge reset)
begin
    clk_200=1'b0;
    clk_count=0;
    clk_trigger=1'b0;

   // temp_complete=1'b0;
   // temp_weight_alert=1'b0;
end

//clock generator block
always@(posedge clk)
begin
    if(clk_trigger)
    begin
        clk_count=clk_count+1;
    end
    if(clk_count==5000)
    begin
        clk_200=~clk_200;
        clk_count=0;
    end
end

always@(req_floor) 
 begin
   clk_trigger=1;
   clk_200 = ~clk_200;

   ram[req_floor]=req_floor;
  // temp_out_floor <= in_floor;
 end

 always@(weight)
 begin
    if(weight>1000)
    temp_over_weight=1;
    else
    temp_over_weight=0;
end

always@(posedge clk)
begin
    
 if(temp_complete==1)
 begin
    if(temp_direction==1 || temp_direction==0)
    begin
        for(i=temp_out_floor;i<8;i=i+1)
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
            for(i=temp_out_floor;i<8;i=i-1)
            begin
                if(ram[i])
                begin
                r_floor=ram[i];
                 temp_complete=0;
                temp_direction=2;
            end
        end
    end
    else
    begin
        for(i=temp_out_floor;i<8;i=i-1)
        begin
            if(ram[i])
            begin
                r_floor=ram[i];
                 temp_complete=0;
                //temp_direction=2;
            end
        end
        if(r_floor==0)
        begin
            for(i=temp_out_floor;i<8;i=i+1)
            begin
                if(ram[i])
                begin
                    r_floor=ram[i];
                     temp_complete=0;
                    temp_direction=1;
                end
            end
        end
    end
end



 if(!reset&&!over_weight)
   begin
     if (r_floor>temp_out_floor)
        begin
           // temp_direction = 1;
            temp_out_floor <= temp_out_floor+1; 
        end
     else if (r_floor< temp_out_floor)
        begin
           // temp_direction = 2;
            temp_out_floor = temp_out_floor-1;
        end
     else if (r_floor == temp_out_floor)
        begin
            temp_complete = 1;
           // temp_direction = 0;
            ram[r_floor]=0;
            r_floor=0;
        end
    end          

 else if (!reset && over_weight)
    begin
        //temp_weight_alert=1;
        temp_direction=0;
        temp_complete=1;
        temp_out_floor <= temp_out_floor;
    end

end
end
endmodule

