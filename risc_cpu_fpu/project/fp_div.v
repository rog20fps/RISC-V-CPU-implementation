module fp_div(

  input             float_ctrl,
  input      [6:0]  funct_7,
  input      [31:0] reg_a,reg_b,
  output reg        c_s,
  output reg [7:0]  c_e,
  output reg [26:0] c_m
);



reg [31:0] a,b;               //to store values reg_a,reg_b after clk and reset 
reg        a_s,b_s,z_s;       //sign bit 
reg [7:0]  a_e1,b_e1,z_e1,f_e1;       //exponent bit 
reg [23:0] a_m,b_m;           //mantessa bit 
reg [26:0] z_m;               //store product with rounding bits
reg [50:0] quotient,remainder,divisor,dividend;
reg [5:0]  count;
reg [5:0]  i;
reg [26:0] quotient_1,quotient_2;
reg [13:0] c_check;
reg signed [7:0] a_e,b_e,g_e;
reg signed [8:0] z_e,f_e;

always @(*)
begin


//if(!reset)                   //if reset=0 ; the code works 
//begin


if(float_ctrl && (funct_7[3:2]==2'b11))              /* input from control unit , if floating values are present 
					                                float_ctrl=1  */
begin 

a=reg_a;
b=reg_b;

a_s=a[31];                       //sign = 1bit//
b_s=b[31];
				  
a_e=((a[30:23]) - 7'd127);          // exponent = 8bits //
b_e=((b[30:23]) - 7'd127);    
					  
a_m={1'b0,{a[22:0]}};           //mantissa after decimal point = 23 bits //
b_m={1'b0,{b[22:0]}};

 
   if(a_e==8'h80 || a_e==8'h81 || b_e==8'h80 || b_e==8'h81)  //specaial cases
	begin 
	
	     /*case 1 : a=Nan  or  b=Nan  ans=Nan */
		  if((a_e==8'h80 && a_m!=0) || (b_e==8'h80 && b_m!=0))
		  begin
		  
		      c_s=1'b1;
				c_e=8'h80 + 8'h7f;
				c_m={1'b1,{26{1'b0}}}; 
		  end 
		  
		  
		  /*case 2 : a=inf  and  b=inf  ans=Nan*/
		  else if((a_e==8'h80 && a_m==0) && (b_e==8'h80 && b_m==0))
		  begin
		  
		      c_s=1'b1;
				c_e=8'h80 + 8'h7f;
				c_m={1'b1,{26{1'b0}}};   
		  end
		  
		  
		  /*case 3 : a=inf*/
		  else if((a_e==8'h80 && a_m==0)) 
		  begin
		  
		      /*case 3a : a=inf  and  b=0  ans=Nan*/  
			   if(b_e==8'h81 && b_m==0)
				begin 
				
				     	c_s=1'b1;
				      c_e=8'h80 + 8'h7f;
				      c_m={1'b1,{26{1'b0}}};         
				end 
				
				/*case 3b : a=inf and b!=0  ans=inf*/
				else
				begin
				
				      c_s=a_s^b_s;
						c_e=8'h80 + 8'h7f;
						c_m=0;
				end
		  end 
		  
		  
		  /*case 4 : a=0 or a!=0 and b=inf  ans=0*/
		  else if((b_e==8'h80 && b_m==0)) 
		  begin 
		  
		      c_s=a_s^b_s;
            c_e=8'h7f;
            c_m=0;				
		  end
		  
		  
		  /*case 5 : a=0*/
		 else if((a_e==8'h81 && a_m==0))
		 begin
		 
		      /*case 5a : a=0  and  b=0  ans=Nan*/
		      if(b_e==8'h81 && b_m==0)
				begin
				
				      c_s=1'b1;
				      c_e=8'h80 + 8'h7f;
				      c_m={1'b1,{26{1'b0}}}; 
				end
				
				/*case 5a : a=0  and  b!=0  ans=0*/
				else
				begin
				
				      c_s=a_s^b_s;
                  c_e=8'h81+8'h7f;
                  c_m=0;
				end
		 end 
		
	     /*case 6 : a=0 or a!=0 and b=0 ans=inf*/
		  else if(b_e==8'h81 && b_m==0)
		  begin
		  
		      c_s=a_s^b_s;
				c_e=8'h80 + 8'h7f;
				c_m=0;     
		  end 
	end                            //for special cases if 
	
	
  else 
  begin
       
		 if(a_e!=8'h81)    a_m[23]=1;
		 if(b_e!=8'h81)    b_m[23]=1;
		 
       remainder=0;
		 quotient =0;
		 count    =0;
		 dividend =a_m<<27;
		 divisor  =b_m;
		 z_e=$signed(a_e)-$signed(b_e);
		 
		 for(count=0; count!=6'h31; count=count+1)    //count!=49
		 begin 
		 
		       quotient =quotient<<1;
				 remainder=remainder<<1;
				 remainder[0]=dividend[50];
				 dividend=dividend<<1;
				 
				 
				 if(remainder>=divisor)
				    begin
				    quotient[0]=1;
					 remainder=remainder-divisor;
					 end 
		 end 
		 
		 quotient_1=quotient[26:0];
		 //quotient_2=quotient_1;
		 i=6'd26;
		 for(i=6'd26; quotient_1[26]!=1 && i!=0; i=i-1)
		 begin 
		 
		      f_e=z_e-1; 
				quotient_1=quotient_1<<1;
		 end 
		 
		 
		 c_e=$signed(f_e)+$signed(8'd127);
		 c_m=quotient_1[25:0];
		 c_s=a_s^b_s;
		 c_check=c_m[25:12];
  
  
  end                            // for special cases else 

end                              //for float_ctrl
//end                             //for reset
end                             //for always block
endmodule 