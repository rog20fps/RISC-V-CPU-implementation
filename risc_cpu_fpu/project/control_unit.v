module control_unit(   
       input  [6:0]  opcode,
		 input  [2:0]  funct_3,
		 input         zero,Alu_result_31,
       input  [6:0]  funct_7,
		 
		 output        Branch,Jal,Jalr,Reg_write,Mem_write,Src2_ctrl,float_ctrl,
		 output [2:0]  imm_src,
		 output [2:0]  result_src,
		 output        PC_src,
		 output [3:0]  alu_ctrl
);
		 
wire [1:0] alu_op;

main_decoder md(opcode,  funct_3,  zero,  Alu_result_31,
                Branch,  Jal,  Jalr,  Reg_write,  Mem_write,  Src2_ctrl,float_ctrl,
					 imm_src,  result_src,  alu_op,
					 PC_src);

alu_decoder ad(opcode[5],funct_3,  funct_7, alu_op,  
               alu_ctrl); 
				
endmodule 
