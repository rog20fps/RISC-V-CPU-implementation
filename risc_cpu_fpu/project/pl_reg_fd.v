
module pl_reg_fd(
    input  				 clk,reset,stall_d,
    input      [31:0] InstrF, PCF, PCPlus4F,
    output  reg [31:0] InstrD, PCD, PCPlus4D,
	 
	 	 input        Branch,Jal,Jalr,Reg_write,Mem_write,Src2_ctrl,float_ctrl,
		 input [2:0]  imm_src,result_src,
		 //input        PC_src,
		 input [3:0]  alu_ctrl,
		 
		 output reg        BranchD,JalD,JalrD,Reg_writeD,Mem_writeD,Src2_ctrlD,float_ctrlD,
		 output reg [2:0]  imm_srcD,result_srcD,
		 //output reg        PC_srcD,
		 output reg [3:0]  alu_ctrlD
);
//removed pc_src and pc_src_d for branch prediction 
initial begin
    InstrD = 32'd0; 
	  PCD = 32'd0; 
	  PCPlus4D = 32'd0;
	  BranchD=0;
	  JalD=0;
	  JalrD=0;
	  Reg_writeD=0;
	  Mem_writeD=0;
	  Src2_ctrlD=0;
	  float_ctrlD=0;
	  imm_srcD=0;
	  result_srcD=0;
	  //PC_srcD=0;
	  alu_ctrlD=0;
	  
end

always @(posedge clk) begin
    if (reset) 
	 begin
      InstrD = 0;   PCD = 0;  PCPlus4D = 0;
		BranchD=0;
	  JalD=0;
	  JalrD=0;
	  Reg_writeD=0;
	  Mem_writeD=0;
	  Src2_ctrlD=0;
	  float_ctrlD=0;
	  imm_srcD=0;
	  result_srcD=0;
	  //PC_srcD=0;
	  alu_ctrlD=0;
    end 
	 
	 //added the stall_d condition for data hazard (stalling)
	else if(stall_d)
	 begin 
	 
	     InstrD <= InstrD; 
		  PCD <= PCD;
        PCPlus4D <= PCPlus4D;
		  BranchD<=BranchD;
	     JalD<=JalD;
	     JalrD<=JalrD;
	     Reg_writeD<=Reg_writeD;
	     Mem_writeD<=Mem_writeD;
	     Src2_ctrlD<=Src2_ctrlD;
	     float_ctrlD<=float_ctrlD;
	     imm_srcD<=imm_srcD;
	     result_srcD<=result_srcD;
	     //PC_srcD<=PC_srcD;
	     alu_ctrlD<=alu_ctrlD;
	 
	 end 
	 
	 else
	 begin
        InstrD = InstrF; 
		   PCD = PCF;
        PCPlus4D = PCPlus4F;
		  
		  	BranchD<=Branch;
	     JalD<=Jal;
	     JalrD<=Jalr;
	     Reg_writeD<=Reg_write;
	     Mem_writeD<=Mem_write;
	     Src2_ctrlD<=Src2_ctrl;
	     float_ctrlD<=float_ctrl;
	     imm_srcD<=imm_src;
	     result_srcD<=result_src;
	     //PC_srcD<=PC_src;
	     alu_ctrlD<=alu_ctrl;
    end
end

endmodule
