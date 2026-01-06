module data_hazards

(
input      [4:0] rs1_e,rs2_e,rs1_d,rs2_d,wr_adder_e,wr_adder_m,wr_adder_w,
input               Reg_write_m,Reg_write_w,Reg_write_e,branch_d,
input      [2:0] result_src_e,result_src_m,
					  
output reg [1:0] forward_A,forward_B,
output reg       forward_AD,forward_BD,
output reg       stall_f,stall_d,flush_e,enable,branch_stall

);
//added branch_stall,Reg_write_e,branch_d,result_src_m,forward_AD,forward_BD

always @(*)
begin 

  //choosing source reg1 for alu 
  if      ((rs1_e!=0) && (wr_adder_e==rs1_d) && Reg_write_m) forward_A=2'b10;
  else if ((rs1_e!=0) && (wr_adder_w==rs1_e) && Reg_write_w) forward_A=2'b01;
  else    forward_A=00;
  
  //choosing source reg2 for alu
  if      ((rs2_e!=0) && (wr_adder_m==rs2_e) && Reg_write_m) forward_B=2'b10;
  else if ((rs2_e!=0) && (wr_adder_w==rs2_e) && Reg_write_w) forward_B=2'b01;
  else    forward_B=00;
  
  //forwarding for branch instructions 
  forward_AD=((rs1_d!=0) && (rs1_d==wr_adder_m) && (Reg_write_m));
  forward_BD=((rs2_d!=0) && (rs2_d==wr_adder_m) && (Reg_write_m));
  
  //stalling 
  enable = (((rs1_d==wr_adder_e && rs1_d!=0) || (rs2_d==wr_adder_e && rs2_d!=0)) && (result_src_e==3'b001));
  
  branch_stall=(((branch_d) && (Reg_write_e)          && ((wr_adder_e==rs1_d) || (wr_adder_e==rs2_d))) ||
                ((branch_d) && (result_src_m==3'b001) && ((wr_adder_m==rs1_d) || (wr_adder_m==rs2_d))));
					 
  if(enable || branch_stall)
  begin 
    
	 stall_f<=1;
	 stall_d<=1;
	 flush_e<=1;
  end 
  
  else
  begin 
  	 stall_f<=0;
	 stall_d<=0;
	 flush_e<=0;
  end
    
end 
endmodule

