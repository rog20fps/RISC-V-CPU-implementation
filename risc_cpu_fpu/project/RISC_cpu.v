module RISC_cpu(
               input         clk,reset,
					input         Ext_Mem_write,
					input  [31:0] Ext_wrdata_add,Ext_wrdata,
					
					output        Mem_write,
					output [31:0] wrdata_add,wrdata,read_data_m,
					output [31:0] PC_F,Result);

wire [31:0] wrdata_add_1,wrdata_1,instr,instr_M;
wire        Mem_write_1;
wire [2:0] funct_3m;
wire Mem_write_M;

CPU #(32) cpu1(clk,  reset,  instr,  read_data_m,
	         Mem_write_M,  PC_F,wrdata_add_1,  wrdata_1,  Result,funct_3m);
				

instruction_memory #(32) ins1(PC_F, instr);


data_memory #(32) data1(clk , Mem_write_M,  funct_3m,
                        wrdata_add,  wrdata,  read_data_m);
							

assign Mem_write  =(Ext_Mem_write && reset)?32'd1: Mem_write_M;
assign wrdata_add =(Ext_Mem_write && reset)?Ext_wrdata_add:wrdata_add_1;
assign wrdata     =(reset)?Ext_wrdata:wrdata_1;

endmodule
