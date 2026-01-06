module pl_reg_de(
    input  				 clk,reset,flush_e,instr_5D,
    input [31:0]      rd1D, rd2D, PCD , PCPLUS4D,Imm_ExtD,
	 input [4:0]       rs1D,rs2D,rdD,
	 
		 input        BranchD,JalD,JalrD,Reg_writeD,Mem_writeD,Src2_ctrlD,float_ctrlD,
		 input [2:0]  imm_srcD,result_srcD,
		 input        PC_srcD,
		 input [3:0]  alu_ctrlD,
		 
		 output reg        instr_5E,
		 output reg [31:0] rd1E, rd2E, PCE , PCPLUS4E,Imm_ExtE,
		 output reg  [4:0] rs1E,rs2E,rdE,
       output reg        BranchE,JalE,JalrE,Reg_writeE,Mem_writeE,Src2_ctrlE,float_ctrlE,
		 output reg [2:0]  imm_srcE,
		 output reg [2:0]  result_srcE,
		 output reg        PC_srcE,
		 output reg [3:0]  alu_ctrlE,
		input [2:0]   Instr_D,
	output reg [2:0] funct_3	);

initial begin
    funct_3<=0;
    instr_5E<=0;
    rd1E = 0;
	 rd2E = 0;
	 PCE = 0;
	 PCPLUS4E=0;
	 Imm_ExtE=0;
	 rs1E=0;
	 rs2E=0;
	 rdE=0;
	 BranchE=0;
	 JalE=0;
	 JalrE=0;
	 Reg_writeE=0;
	 Mem_writeE=0;
	 Src2_ctrlE=0;
	 float_ctrlE=0;
	 imm_srcE=0;
	 result_srcE=0;
	 PC_srcE=0;
	 alu_ctrlE=0;
end

always @(posedge clk) 
begin
    if (reset || flush_e) 
	  begin
	   funct_3<=0;
	   instr_5E<=0;
      rd1E <= 0;
	   rd2E <= 0;
	   PCE <= 0;
	   PCPLUS4E <=0;
	   Imm_ExtE <=0;
	   rs1E <=0;
	   rs2E <=0;
	   rdE <=0;
	   BranchE <=0;
	   JalE <=0;
	   JalrE <=0;
	   Reg_writeE <=0;
	   Mem_writeE <=0;
	   Src2_ctrlE <=0;
	   float_ctrlE <=0;
	   imm_srcE <=0;
	   result_srcE <=0;
	   PC_srcE <=0;
	   alu_ctrlE <=0;
     end
	  
     else 
	  begin
	   funct_3<=Instr_D;
	   instr_5E<=instr_5D;
      rd1E <= rd1D;
	   rd2E <= rd2D;
	   PCE <= PCD;
	   PCPLUS4E <=PCPLUS4D;
	   Imm_ExtE <=Imm_ExtD;
	   rs1E <=rs1D;
	   rs2E <=rs2D;
	   rdE <=rdD;
	   BranchE <=BranchD;
	   JalE <=JalD;
	   JalrE <=JalrD;
	   Reg_writeE <=Reg_writeD;
	   Mem_writeE <=Mem_writeD;
	   Src2_ctrlE <=Src2_ctrlD;
	   float_ctrlE <=float_ctrlD;
	   imm_srcE <=imm_srcD;
	   result_srcE <=result_srcD;
	   PC_srcE <=PC_srcD;
	   alu_ctrlE <=alu_ctrlD;
     end
end

endmodule
