module fp_sub(
                     input float_ctrl,
							input [6:0]  funct_7,
                     input [31:0] inp1, inp2,
                     output reg  z_s,
                     output reg [7:0]  z_e,
                     output reg [26:0] z_m );
  reg [7:0] sign_diff;
  reg [31:0] a, b;
  reg [23:0] a_m, b_m;
  reg [7:0] a_e, b_e;
  reg       a_s, b_s;
  reg [24:0] presum;
  
 always @(inp1,inp2)
 begin
 //if (!reset)
 //begin

 if (float_ctrl && funct_7[3:2]==2'b01)
 begin
     a = inp1;
     b = inp2;
     a_m = {1'b0, a[22:0]};            
     b_m = {1'b0, b[22:0]};
     a_e = a[30:23] - 7'd127;
     b_e = b[30:23] - 7'd127;
     a_s = a[31];
     b_s = b[31];

     // Flip the sign of the second operand for subtraction
     b_s = ~b_s;
     
     // Handle special cases
     if (a_e == 8'h80 || a_e == 8'h81 || b_e == 8'h80 || b_e == 8'h81)
     begin
         if ((a_e == 8'h80 && a_m != 0) || (b_e == 8'h80 && b_m != 0))
         begin
             z_s = 1;
             z_e = 8'h80 + 8'h7f;
             z_m = {1'b1, {26{1'b0}}};
         end
         else if (a_e == 8'h80 && a_m == 0)
         begin
             z_s = a_s;
             z_e = 8'hff;
             z_m = 0;
         end
         else if (b_e == 8'h80 && b_m == 0)
         begin
             z_s = b_s;
             z_e = 8'h80 + 8'h7f;
             z_m = 0;
         end
         else if (a_e == 8'h80 && b_e == 8'h80 && a_s != b_s)
         begin
             z_s = a_s;
             z_e = 8'h80 + 8'h7f;
             z_m = {1'b1, {26{1'b0}}};
         end
         else if (((a_e == 8'h81) && (a_m == 0)) && ((b_e == 8'h81) && (b_m == 0)))
         begin
             z_s = a_s & b_s;
             z_e = 8'h7f;
             z_m = 0;
         end
         else if ((a_e == 8'h81) && (a_m == 0))
         begin
             z_s = b_s;
             z_e = b_e;
             z_m = b_m;
         end
         else if ((b_e == 8'h81) && (b_m == 0))
         begin
             z_s = a_s;
             z_e = a_e;
             z_m = a_m;
         end
     end
     else if (($signed(b_e)) > ($signed(a_e)) || ($signed(a_e)) > ($signed(b_e)) || ($signed(a_e)) == ($signed(b_e)))
     begin
         if (a_e != 8'h81)  a_m[23] = 1;     
         if (b_e != 8'h81)  b_m[23] = 1;

         if (($signed(b_e)) > ($signed(a_e)))
         begin
             sign_diff = b_e - a_e;
             a_e = a_e + sign_diff;
             a_m = a_m >> sign_diff;
             z_e = b_e;
         end
         else if (($signed(a_e)) > ($signed(b_e)))
         begin
             sign_diff = a_e - b_e;
             b_e = b_e + sign_diff;
             b_m = b_m >> sign_diff;
             z_e = a_e;
         end
         else if (($signed(a_e)) == ($signed(b_e))) // a_e == b_e
         begin
             z_e = a_e;
         end

         // Perform subtraction
         if (a_s == b_s)
         begin
             presum = a_m + b_m;
             z_s = a_s;
         end 
         else 
         begin
             if (a_m >= b_m) 
             begin
                 presum = a_m - b_m;
                 z_s = a_s;
             end
             else
             begin
                 presum = b_m - a_m;
                 z_s = b_s;
             end
         end
                             
         if (presum[24]) 
         begin
             z_m = presum[23:0];
             z_e = z_e + 1;
         end 
         else if (!presum[24])       
         begin
             z_m = presum[23:0];
         end
         else if (z_m[23] == 0 && $signed(z_e) > -126)
         begin
             z_e = z_e - 1'b1;
             z_m = z_m << 1;
         end 
         else if ($signed(z_e) < -126)
         begin
             z_e = z_e + 1;
             z_m = z_m >> 1;
         end
     end
 end
 //end
end
endmodule 