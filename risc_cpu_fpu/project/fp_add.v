module fp_add(
                     input float_ctrl,
							input [6:0]  funct_7,
							input [31:0] inp1,inp2,
							//input [31:0] val,
						   output reg  z_s,
                     output reg [7:0]  z_e,
                     output reg [26:0] z_m );
  reg [7:0] sign_diff;
  reg [31:0] a,b;
  reg [26:0] a_m,b_m;
  reg [7:0] a_e,b_e;
  reg        a_s,b_s;
  reg [27:0] presum;
  
 always@(*)
begin
//if(!reset)
//begin

if(float_ctrl && (funct_7[3:2]== 2'b00))
begin
 a =  inp1;
 b =  inp2;
 a_m ={{1'b0},{a[22:0]},3'b0};            
 b_m ={{1'b0},{b[22:0]},3'b0};
 a_e = {a[30:23] - 7'd127};
 b_e = {b[30:23] - 7'd127};
 a_s = a[31];
 b_s = b[31];
 
  //special_cases:
 
if(a_e==8'h80 || a_e==8'h81 || b_e==8'h80 || b_e==8'h81)
begin
// both is nan
if ((a_e== 8'h80 && a_m!=0) || (b_e== 8'h80 && b_m!=0))
   begin
   z_s=1;
   z_e=8'h80+8'h7f;
   z_m = {1'b1,{26{1'b0}}};
 // if a is inf
  end
else if (a_e== 8'h80 && a_m==0) 
  begin
   z_s=a_s;
   z_e=8'hff;
   z_m=0;
  end	
	
// if b is infinity
else if (b_e== 8'h80 && b_m==0 )
          begin 
          z_s=b_s;
          z_e=8'h80+8'h7f;
          z_m=0;
          end
			 // a and b have opp sign
else if (a_e==8'h80 && b_e==8'h80 && a_s!=b_s)
             begin 
             z_s= a_s;
             z_e=8'h80+8'h7f;
             z_m= {1'b1,{26{1'b0}}};
				 end
	  
	// if a and b are zero 
else if (((a_e==8'h81) && (a_m==0)) && ((b_e==8'h81) && (b_m==0)))
         begin
			z_s= a_s & b_s;
			z_e= 8'h7f;
			z_m= 0;
			
			end
// if a is zero return b
else if ((a_e==8'h81) && (a_m==0))
         begin
		   z_s=b_s;
		   z_e= b_e;
			z_m= b_m;
			end
// if b is zero return a
else if ((b_e==8'h81) && (b_m==0))
         begin
		   z_s=a_s;
		   z_e= a_e;
			z_m= a_m;
			end
end
else if (($signed(b_e))>($signed(a_e)) || ($signed(a_e))>($signed(b_e)) || ($signed(a_e))==($signed(b_e)))
    
    begin 

                  if (a_e!= 8'h81)  a_m[26]=1;	 
			         if (b_e!= 8'h81)  b_m[26]=1;
				           		
                            if (($signed(b_e))>($signed(a_e)))
                                       begin
                                       sign_diff = b_e - a_e;
                                       a_e= a_e+sign_diff;
                                       a_m=a_m>>sign_diff;
			                              z_e = b_e;
			                              end 
	  
	  
                           else if (($signed(a_e))>($signed(b_e)))
                                      begin
                                      sign_diff = a_e - b_e;
	                                   b_e= b_e+sign_diff;
	                                   b_m=b_m>>sign_diff;
			                             z_e = a_e;
			                             end
       
		                    else if (($signed(a_e))==($signed(b_e))) // a_e==b_e
                                      begin
                                      z_e = a_e ;
			                             end
                            if (a_s==b_s)
                                      begin
                                      presum = a_m + b_m ;
                                      z_s = a_s;
                                      end 
                            else 
                                      begin
                                      if (a_m >= b_m) 
                                           begin
                                           presum= a_m - b_m ;
                                           z_s = a_s;
                                           end
                                      else
                                            begin
                                            presum = b_m - a_m ;
                                            z_s = b_s;
                                           end
                                     end
                                
                           if (presum[27]) 
                                        begin
                                        z_m = presum[26:0];
                                        z_e = z_e + 1;
                                        end 
                           else if (!presum[27]) 	   
                                        begin
                                        z_m = presum[26:0];
                                        end
                           //else  if (z_m[26]==0 && $signed(z_e)>-126)
                                        //begin
                                        //z_e =z_e-1'b1;
                                        //z_m = z_m << 1 ;
                                        //end 
                           //else if ( $signed(z_e) <-126)
                                        //begin
                                        //z_e =z_e + 1;
                                        //z_m = z_m >> 1 ;
                                        //end
													                               
   end //else block 
   end // float=1
//end //reset
end //always block 
endmodule 