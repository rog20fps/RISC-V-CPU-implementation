module CPU #(parameter V=32)
(  
    input          clk,reset,
	 input  [V-1:0] instr,read_data,
	 output         Mem_write_m,
    output [V-1:0] PC_F,wrdata_add,wrdata,Result,
	 output [3:0] funct_3m
);

wire Jalr,Reg_write,Src2_ctrl,PC_src,zero,Alu_result_31,Branch,Jal,float_ctrl;
wire [3:0] alu_ctrl;
wire [2:0] imm_src;
wire [2:0] result_src;

					 
control_unit c1(instr[6:0],  instr[14:12],  zero,  Alu_result_31,  instr[31:25],
		          Branch, Jal, Jalr,  Reg_write,  Mem_write,  Src2_ctrl,float_ctrl,
		          imm_src, result_src, PC_src, alu_ctrl);
					 

data_path d1(clk,  reset,  instr,  read_data,  Jalr,
                Reg_write,  Src2_ctrl,  Branch, Jal, float_ctrl,imm_src, result_src,
                PC_src,  alu_ctrl,
		          zero,  Alu_result_31,
		          PC_F,wrdata_add,  wrdata, Result,Mem_write_m,funct_3m);
					 
endmodule
