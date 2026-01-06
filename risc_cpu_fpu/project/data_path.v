module data_path(
      
		input         clk,reset,
		input  [31:0] instr,
		input  [31:0] read_data_m,
		input         Jalr,Reg_write,Src2_ctrl,Branch,Jal,float_ctrl,
		input  [2:0]  imm_src,
		input  [2:0]  result_src,
		input         PC_src,
		input  [3:0]  alu_ctrl,
		
		output        zero,Alu_result_31,
		output [31:0] PC_F,wrdata_add,wrdata,Result,
	   output        Mem_write_M,
		output [2:0] funct_3m//pc removed (replaced by pc_f)
);


wire [31:0] PC_plus4, PC_target, alu_result, PC_out, immext, rd1, rd2, src_b, 
            AUIPC, Utype_res,result_fp;
wire [31:0] InstrD, PCD, PCPlus4D;

//pipelining wires 
wire [31:0] Instr_D, PC_D, PC_plus4_D,rd1_d,rd2_d;
wire [31:0] rd1_E, rd2_E, PC_E , PC_plus4_E,immext_E,Utype_res_W,rd2_M,rd2_W;
wire [31:0] PC_M,immext_M,alu_result_m,PC_plus4_M,PC_plus4_W,alu_result_W,PC_W;

wire [4:0]  rs1_E,rs2_E,wr_adder_M,wr_adder_E,wr_adder_W;
wire [4:0]  rs1_DHE,rs2_DHE;

wire        Branch_E,Jal_E,Jalr_E,Reg_write_E,Mem_write_E,Src2_ctrl_E,float_ctrl_E,PC_src_E;
wire        instr_5E,instr_5M,reg_write_M,reg_write_W,Mem_write;

wire [2:0]  imm_src_E,result_src_E,result_src_M, result_src_W;
wire [3:0]  alu_ctrl_E;
wire [1:0]  forward_A,forward_B;
wire        stall_f,stall_d,flush_e,enable,forward_AD,forward_BD,branch_stall;

wire [31:0] rd1_DHE,rd2_DHE;

wire        Branch_D, Jal_D,Jalr_D,Reg_write_D,Mem_write_D,Src2_ctrl_D,float_ctrl_D,PC_src_D;
wire [2:0]  imm_src_D,result_src_D;
wire [3:0]  alu_ctrl_D;
wire [2:0]  funct_3;

data_hazards d1(rs1_E,rs2_E,instr[19:15],instr[24:20],wr_adder_E,wr_adder_M,wr_adder_W,
                 reg_write_M,reg_write_W,Reg_write_E,Branch_D,result_src_E,result_src_M,
					  forward_A,forward_B,forward_AD,forward_BD,stall_f,stall_d,flush_e,enable,branch_stall);


//4x1 mux infront of clk,pc output as PC , select lines as jalr and pc_src
mux4  #(32)  PC_mux(PC_plus4,PC_target,alu_result,32'bx,PC_src_D,Jalr,PC_out);
//changed PC_src to PC_src_D 

//reset flip flop 
//technically reset ff is the 1st reg file in pipelining process 
//changes made: pc replaced by pc_f
reset_ff #(32) f1(clk,reset,stall_f,PC_out,PC_F);


//adder for pc as pc + 4 
adder #(32)  adder_4(PC_F,32'd4,PC_plus4); 

                            
//adder for pc_target where the instruction should branch as pc+jump instuction
//adder #(32)  adder_jump(PC_F,immext,PC_target); commented out during pipelinning 


//---->>>>>> PIPELINED REG FETECH | DECODE
//removing pc_src and pc_src_d
pl_reg_fd fd(clk,reset,stall_d,instr,PC_F,PC_plus4,Instr_D, PC_D,PC_plus4_D,
Branch, Jal,Jalr,Reg_write,Mem_write,
Src2_ctrl,float_ctrl,imm_src,result_src,alu_ctrl,
Branch_D, Jal_D,Jalr_D,Reg_write_D,Mem_write_D,
Src2_ctrl_D,float_ctrl_D,imm_src_D,result_src_D,alu_ctrl_D);


         
//calling register_file (ResulT=wrdata)
register_file #(32) a1(clk,reg_write_W,float_ctrl,Instr_D[19:15],Instr_D[24:20],wr_adder_W,Result,rd1,rd2);

//calling sign_extend 
sign_extend i1(Instr_D[31:0],imm_src,immext);
                         


//for branch instruction, forwarding 

//write comparator block 
branch_prediction bp1(Instr_D[6:0],Instr_D[14:12],rd1,rd2,alu_result_m,
                      forward_AD,forward_BD,rd1_d,rd2_d,PC_src_D);


//adder should be present here during pipelinnng 
adder #(32)  adder_jump(PC_D,immext,PC_target); 


//pipeline 2nd reg decode --->>> execute 	
// memwrite pending 
// nothing changed in input / output / wires in the main datapath 
	
pl_reg_de de(clk,reset,flush_e,instr[5],rd1_d, rd2_d, PC_D, PC_plus4_D, 
immext,Instr_D[19:15],Instr_D[24:20],Instr_D[11:7],Branch_D, Jal_D,Jalr_D,Reg_write_D,Mem_write_D,
Src2_ctrl_D,float_ctrl_D,imm_src_D,result_src_D,PC_src_D,alu_ctrl_D,

instr_5E,rd1_E, rd2_E, PC_E , PC_plus4_E,immext_E,rs1_E,rs2_E,wr_adder_E,Branch_E,Jal_E,Jalr_E,Reg_write_E,Mem_write_E,
Src2_ctrl_E,float_ctrl_E,imm_src_E,result_src_E,PC_src_E,alu_ctrl_E,Instr_D[14:12],funct_3);
		 

//calling floatig point unit 
fp_main fp1(clk,Reg_write,float_ctrl,instr,result_fp);


//mux for data hazard (forward_A)
mux4  #(32) m3(rd1_E,Result,alu_result_m,32'bx,forward_A[0],forward_A[1],rd1_DHE); //changed rs1_dhe to rd1_dhe


//mux for data hazard (forward_B)
mux4  #(32) m4(rd2_E,Result,alu_result_m,32'bx,forward_B[0],forward_B[1],rd2_DHE);




//selecting second operand(b) from register or sign_extend 
mux2  #(32) b(rd2_DHE,immext_E,Src2_ctrl_E,src_b);


//calling alu_unit 
alu_unit  u1(alu_ctrl_E,rd1_DHE,src_b,zero,alu_result,Alu_result_31); //rd1 cahnged to rd1_dhe


//pipeline 3nd reg execute --->>> memory
pl_reg_em em(clk,reset,instr_5E,rd2_DHE,PC_E,immext_E,Reg_write_E,result_src_E,Mem_write_E,alu_result,wr_adder_E,PC_plus4_E,
				 instr_5M,rd2_M,PC_M,immext_M,reg_write_M, result_src_M, Mem_write_M, alu_result_m, wr_adder_M, PC_plus4_M,funct_3,funct_3m);

//auipc adder with pc,
adder #(32) auipc_adder(PC_M,immext_M,AUIPC);


//mux to select auipc or luipc 
mux2  #(32) m1(AUIPC,immext_M,instr_5M,Utype_res);

//pipeline 4th reg memory --->>> write back
									
pl_reg_mw mw(clk,reset,Utype_res,PC_M,rd2_M,reg_write_M ,result_src_M,alu_result_m , wr_adder_M , 
PC_plus4_M,PC_W,Utype_res_W,rd2_W, reg_write_W, result_src_W, alu_result_W, wr_adder_W, PC_plus4_W,read_data_m,read_data_w);

//mux to select result 
mux8  #(32) m2(alu_result_W,read_data_w,PC_plus4_W,Utype_res_W,result_fp,32'bx,32'bx,32'bx,result_src_W[0],result_src_W[1],result_src_W[2],Result);

assign wrdata_add = alu_result_m;
assign wrdata = rd2_M;

endmodule

