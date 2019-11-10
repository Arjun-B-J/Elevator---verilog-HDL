module elevator_sim;

//regs
reg[2:0]req_floor;
reg[2:0]in_floor;
reg clk,reset,weight;

//wires
wire  [1:0]direction;
wire  complete;
wire over_weight;
wire [2:0]out_floor;

elevator M1 (req_floor,in_floor,weight,clk,reset,complete,direction,over_weight,out_floor);

always
  begin
   #50 clk = ~clk;
  end

initial
   begin
      #0 clk=1'b0; reset = 1'b1; weight = 800;
      #50 reset = 1'b0;
      #50 reset = 1'b1;
      #50 req_floor = 6; in_floor =0;
      #50 reset =1;
      #50 reset =0;
      #50 req_floor = 1;
      #50 reset = 1'b1;
      #50 reset = 1'b0;
      #50 weight =1024;
      #50 reset = 1'b1;

   end
endmodule

