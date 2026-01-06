module pl_reg_em (
          input  clk,reset,instr_5E,                                                                  //wr_adder
          input [31:0] rd2_E,PC_E,immext_E,
			 input        reg_writeE, 
			 input [2:0]  result_srcE, 
			 input        mem_writeE, 
			 input [31:0] alu_resultE, 
			 input [4:0]  write_dataE, 
			 input [31:0] PC_PLUS4E,
			 
			 output reg instr_5M,
			 output reg [31:0] rd2_M,PC_M,immext_M,
			 output reg reg_writeM, 
			 output reg [2:0] result_srcM, 
			 output reg mem_writeM, 
			 output reg [31:0] alu_resultM, 
			 output reg [4:0]  write_dataM, 
			 output reg [31:0] PC_PLUS4M,
			 input [2:0] funct_3,
			 output reg [2:0] funct_3m
);
			 
initial begin
          instr_5M=0;
			 rd2_M=0;
          PC_M=0;
			 immext_M=0;
          reg_writeM=0;
			 result_srcM=0;
			 mem_writeM=0; 
			 alu_resultM=0;
			 write_dataM=0; 
			 PC_PLUS4M=0;
			 funct_3m=0;
		  end 
  
 always@(posedge clk)
   begin
	     if (reset)
		  begin
		    instr_5M=0;
			 rd2_M=0;
		    PC_M=0;
			 immext_M=0;
          reg_writeM <=0;
			 result_srcM <=0;
			 mem_writeM <=0; 
			 alu_resultM <=0;
			 write_dataM <=0; 
			 PC_PLUS4M <=0;
			 funct_3m<=0;
        end
		  
		  
		 else
		 begin
		    instr_5M=instr_5E;
			 rd2_M<=rd2_E;
		    PC_M=PC_E;
			 immext_M=immext_E;
		    reg_writeM <=reg_writeE;
			 result_srcM <=result_srcE;
			 mem_writeM <=mem_writeE; 
			 alu_resultM <=alu_resultE;
			 write_dataM <=write_dataE;  
			 PC_PLUS4M <=PC_PLUS4E;
			 funct_3m<=funct_3;
   	end
   end
endmodule
