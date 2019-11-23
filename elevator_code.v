
module elevator(req_floor,in_floor,weight,clk,complete,direction,over_weight,out_floor);

//inputs
input[2:0]req_floor;
input[2:0]in_floor;
input clk;
input [10:0] weight;

//outputs
output  [1:0]direction;
output  complete;
output  over_weight;
output  [2:0]out_floor;

//temps
reg [2:0]ram[7:0];
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
end


always@(req_floor) 
 begin
   ram[req_floor]=req_floor;
  // temp_out_floor <= in_floor;
 end

always@(weight)
 begin
    if(weight>899)
    temp_over_weight=1;
    else
    temp_over_weight=0;
 end

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



always@(posedge clk)
 begin
   if(r_floor==0)
   begin
   /// idle or lift is moving up.
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
             for(j=temp_out_floor;j>0;j=j-1)
             begin
                 if(ram[j])
                 begin
                  r_floor=ram[j];
                  temp_complete=0;
                  temp_direction=2;
                 end
             end
         end     
    /// lift moving down
     else
        begin
        for(k=temp_out_floor;k>0;k=k-1)
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
            for(l=temp_out_floor;l<8;l=l+1)
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
 end
 /// to assign direction and out floor
 always@(posedge clk)
 begin
 if(!over_weight && r_floor!=0)
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