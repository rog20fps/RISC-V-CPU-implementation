module fp_main(

       input clk,Reg_write,float_ctrl,
		 input [31:0] instr,
		 output [31:0] result_fp
);

fp_data_path a10(clk,Reg_write,float_ctrl,instr,result_fp);

endmodule 