module elevator_sim;

//regs
reg[2:0]req_floor;
reg[2:0]in_floor;
reg clk; 
reg [10:0] weight;

//wires
wire  [1:0]direction;
wire  complete;
wire over_weight;
wire [2:0]out_floor;

elevator M1 (req_floor,in_floor,weight,clk,complete,direction,over_weight,out_floor);

initial
begin
clk = 1'b0;
end

always
  begin
   #1 clk = ~clk;
  end

initial
   begin
     req_floor = 5; in_floor =1; weight =200;
    #10 req_floor = 7; weight =300;
   end
endmodule
