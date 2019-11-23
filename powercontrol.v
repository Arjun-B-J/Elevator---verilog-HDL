
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
input [12:0]weight;

//outputs
output [2:0]powerlevel;
output [7:0]motor;

reg [2:0]pl;

DeCoder8 d1(1,pl,motor); 

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