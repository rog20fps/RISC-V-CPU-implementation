module fp_mul(

  input             float_ctrl,
  input      [6:0]  funct_7,
  input      [31:0] reg_a,reg_b,
  output reg        c_s,
  output reg [7:0]  c_e,
  output reg [26:0] c_m
  
);

reg [31:0] a,b;               //to store values reg_a,reg_b after clk and reset 
reg        a_s,b_s,z_s;       //sign bit 
reg [7:0]  a_e,b_e,z_e;       //exponent bit 
reg [23:0] a_m,b_m;           //mantessa bit 
reg [26:0] z_m;               //store product with rounding bits
reg [47:0] product;           //product of 48 bits
reg [47:0] product_mid;     //intermediate product before shifting 




always @(reg_a,reg_b)
begin


//if(!reset)                   //if reset=0 ; the code works 
//begin


if(float_ctrl && funct_7[3:2]==2'b10)              /* input from control unit , if floating values are present 
					                                float_ctrl=1  */
begin 
product_mid=47'b0;
product=47'b0;

a=reg_a;
b=reg_b;

a_s=a[31];                       //sign = 1bit//
b_s=b[31];
					  
a_e=(a[30:23]-7'd127);          // exponent = 8bits //
b_e=(b[30:23]-7'd127);    
					  
a_m={1'b0,{a[22:0]}};           //mantissa after decimal point = 23 bits //
b_m={1'b0,{b[22:0]}};
					  
					  
					  
					  
	// speacial cases occur when exp=128 or exp=-127//				  
	if(a_e==8'h80 || a_e==8'h81 || b_e==8'h80 || b_e==8'h81)
	begin
					  
					  
					  /* case 1:if a=NaN or b=Nan return ans=Nan*/
					  if((a_e==8'h80 && a_m!=0) || (b_e==8'h80 && b_m!=0))        //h'80 = d'128
					      
							begin 
							c_s=1'b1;     
							c_e=8'h80+8'h7f;          //exp = 128+127 = 255
							c_m={1'b1,{26{1'b0}}}; //msb=1, rest 22 bits = 0 
							end 
							
							
						/* case 2:if a=inf and b=0 return Nan*/
						else if((a_e==8'h80 && a_m==0))       
						
							  if(b_e==8'h81 && b_m==0)                //h'81=d'-127
							  begin 
							  
								   c_s=1'b1;     
							      c_e=8'h80+8'h7f;          //exp = 128+127 = 255
							      c_m={1'b1,{22{1'b0}}}; //msb=1, rest 22 bits = 0 
							  end 
							  
								
							  /*case 3: if a=inf and b!=0 return inf*/
							  else  
							  begin 
							  
								   c_s=a_s ^ b_s;      //xor operation to determine sign of infinity
								   c_e=8'd128+8'd127;         //exp = 128+127 = 255
								   c_m=0;				 //mantissa 23 bits =0
							  end
							  
							  
							
						  /* case 4:if b=inf and a=0 return Nan*/
						else if((b_e==8'h80 && b_m==0))
						
						  
							  if(a_e==8'h81 && a_m==0)
							  begin 
							  
								   c_s=1'b1;     
							      c_e=8'h80+8'h7f;          //exp = 128+127 = 255
							      c_m={1'b1,{22{1'b0}}}; //msb=1, rest 22 bits = 0 
							  end 
								
							   /*case 5: if b=inf and a!=0 return inf*/
							  else 
							  begin 
							  
								   c_s=a_s ^ b_s;      //xor operation to determine sign of infinity
								   c_e=8'd128+8'h7f;         //exp = 128+127 = 255
								   c_m=0;              //mantissa 23 bits =0
							  end
						
							
							
						/*case 6: if a=0 or b=0 return zero*/
					   else  if((a_e==8'h81 && a_m==0)||(b_e==8'h81 && b_m==0))
					   begin
						
						     c_s=a_s ^ b_s;   //xor operation to determine sign of zero 
							  c_e=0+8'h7f;           //exp = -127+127 = 0 
							  c_m=0;           //mantissa 23 bits =0
						end
						
	end
				
		
   //if no special cases are involved//
	
   else 
	begin	  
						//if(a_e==$signed(-127)) a_e= -126; 
					  if(a_e!=8'h81)    a_m[23]=1;             //-127 
								              //a_e=a_e-1'b1;  end     //include the lhs of dedcimal point in mantissa

						
					  	/*case 8 : denormalised number */
						 //if(b_e==$signed(-127)) b_e= -126; 
                 if (b_e !=8'h81)   b_m[23]=1;  
								//b_e=b_e-1'b1;  end 		
						
						//else 
	 
						    //if (a_m[23]!=1) 
							 //begin                                     
							  //a_e=a_e-1'b1;                             //normalises a by shifting mantissa
							  //a_m=a_m<<1'b1;                            //left and deceasing exp by 1 
							  //end
						
						//if (b_m[23]!=1) 
							 //begin                                     
							  //b_e=b_e-1'b1;                             //normalises a by shifting mantissa
							  //b_m=b_m<<1'b1;                            //left and deceasing exp by 1 
							  //end
						  
							  
						//else 
				      //begin		
					  z_s=a_s^b_s;
					  z_e=a_e+b_e;
					  product_mid=a_m * b_m ;
					  product=product_mid;
					  
						
					  if(product[47]==0)
					  begin
					  
						    z_e=z_e-1;
							 product=product<<1'b1;
					  end
					  
						 
					  if(product[47]==0)
					  begin
					  
						     z_e=z_e-1;
							  product=product<<1'b1;
					  end
					  
						 
					 z_m=product[46:20];
					 z_e=z_e+1'b1;
						  
						  //if(z_e< $signed(-126))
						      //begin
								//z_e=z_e+1;
								//z_m=z_m>>1;
								//end
							
							
					 c_s=z_s;
					 c_e=z_e+8'd127;
                c_m=z_m;
					 
					 
						  
					 if ($signed(c_e) == -126 && c_m[26] == 0) 
					 begin
					 
                     c_e = 0;
                 end
					  
							 
					  if ($signed(c_e) > 127) 
					  begin
					  
                      c_m = 0;
                      c_e = 255;
                      c_s = z_s;
                 end
					  

	end               //end for else of special cases
	               
end                  //end for float ctrl=1                                                   
//end                  //end for reset!=0
end                  //end for always block
endmodule
