module pl_reg_mw ( 
              input clk,reset,
				  input [31:0]      Utype_res_M,PC_M,rd2_M,
				  input             reg_writeM, 
				  input [2:0]       result_scrM, 
				  input [31:0]      alu_resultM, 
				  input [4:0]       rdM, //rdm=wr_adder
				  input [31:0]      PC_PLUS4M,  
				  
				  output reg [31:0] PC_W,Utype_res_W,rd2_W,
				  output reg        reg_writeW, 
				  output reg [2:0]  result_scrW, 
				  output reg [31:0] alu_resultW, 
				  output reg [4:0]  rdW,
				  output reg [31:0] PC_PLUS4W,
				  input [31:0] read_data_m,
				  output reg [31:0] read_data_w );
				  
initial 
     begin
     PC_W=0;
     Utype_res_W=0;
	  rd2_W=0;
     reg_writeW =0;
	  result_scrW =0;
	  alu_resultW =0;
	  rdW =0;
	  PC_PLUS4W =0;
	  read_data_w=0;
	  end
	  
always@(posedge clk) begin
      if(reset)
		  begin
		  PC_W=0;
		   Utype_res_W<=0;
		   rd2_W<=0;
		   reg_writeW <=0;
	      result_scrW <=0;
	      alu_resultW <=0;
	      rdW <=0;
	      PC_PLUS4W <=0;
			read_data_w<=0;
		  end
		else
		  begin
		   PC_W<=PC_M;
		   Utype_res_W<=Utype_res_M;
		   rd2_W<=rd2_M;
		   reg_writeW <=reg_writeM;
	      result_scrW <=result_scrM;
	      alu_resultW <=alu_resultM;
	      rdW <=rdM;
	      PC_PLUS4W <=PC_PLUS4M;
			read_data_w<=read_data_m;
		  end
end
endmodule
		  
		
				  
				  