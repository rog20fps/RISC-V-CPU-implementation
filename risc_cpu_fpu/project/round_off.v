module round_off(
       //input        clk,reset,
		 input [2:0]  mode,
		 input        z_s,
		 input [7:0]  z_e,
		 input [26:0] z_m,
		 output reg [31:0] Result 
);

reg gaurd,round_bit,sticky;   
reg [22:0] result_m ;


always @(z_s,z_e,z_m)
begin 

    gaurd =z_m[3];
    round_bit = z_m[2];
    sticky = (z_m[1] || z_m[0]);

    case(mode)
	 
	 3'b000: begin                  //round to nearest 
	 
	         if(gaurd==0) result_m = z_m[26:4];
				else 
				begin 
				
				   if(round_bit==0 && sticky==0)
					begin  
					
					     if(z_m[4]==1) result_m = z_m[26:4] + 1'b1;
						  else          result_m = z_m;
					end
					
					else 
					begin  
					      result_m = z_m[26:4] + 1'b1;		
					end 
				end 
	         end 
				
	 3'b001:begin                  //round towards zero 
	        
			  result_m = z_m[26:4];
	        end 
			  
	 3'b010:begin                //round towards -ve infinity 
	 
	        if(z_s==0)  result_m = z_m[26:4];       //positive numbers
			  else 
			  begin 
			  
			      if(gaurd || round_bit || sticky) result_m = z_m[26:4] - 1'b1;
					else result_m = z_m[26:4];
			  end 
			  end
			 
	 3'b011:begin                  //round towards +ve infinity 
	 
	         if(z_s==0 && (gaurd || round_bit || sticky)) result_m = z_m[26:4] + 1'b1;
				else if (z_s==0) result_m = z_m[26:4];
				else if (z_s==1) result_m = z_m[26:4] + 1'b1;
	         end  
				
	 3'b100:begin 
	 
	         if(gaurd) result_m = z_m + 1'b1;
				else      result_m = z_m;
	         end 
	  endcase 
	  
	  Result[31]    = z_s;
	  Result[30:23] = z_e;
	  Result[22:0]  =result_m;
	  
end 
endmodule 