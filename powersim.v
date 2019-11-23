module powersim;
reg [12:0]weight;

wire [2:0]powerlevel;
wire [7:0]motor;
powersavingmotor ps1 (powerlevel,motor,weight);
initial
begin
    weight = 566;
    #10; weight = 899;

end
endmodule