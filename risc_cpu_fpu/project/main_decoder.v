module main_decoder(
 
       input [6:0]  opcode,
		 input [2:0]  funct_3,
		 input        zero,Alu_result_31,

		 
		 output       Branch,Jal,Jalr,Reg_write,Mem_write,Src2_ctrl,float_ctrl,
		 output [2:0] imm_src,result_src,
		 output [1:0] alu_op,
		 output reg   PC_src
);


reg [14:0] ctrl_signal;
always @(*)
begin
     //PC_src=1'b0;
   //7'bopcode:Branch,Jal,Jalr,Reg_write,Mem_write,Src2_ctrl,imm_src,result_src,alu_op,float_ctrl
     casez(opcode)
	       
			 7'b0000011:ctrl_signal=15'b0_0_0_1_0_1_000_001_00_0;   //opcode =3 , i-type load 
			 7'b0010011:ctrl_signal=15'b0_0_0_1_0_1_000_000_10_0;   //opcode =19, i-type addi 
			 7'b0?10111:ctrl_signal=15'b0_0_0_1_0_x_100_011_xx_0;   //opcode =23,55 u-type lui,auipc 
			 7'b0100011:ctrl_signal=15'b0_0_0_0_1_1_001_000_00_0;   //opcode =35, s-type store 
			 7'b0110011:ctrl_signal=15'b0_0_0_1_0_0_xxx_000_10_0;   //opcode =51, r-type add,and
			 7'b1100111:ctrl_signal=15'b0_0_1_1_0_1_000_010_00_0;   //opcode =103 i type jalr
			 
			 //for jump and branch instruction , PC value should be to the branched instruction
          //by selecting pc_src=1, mux takes the value from pc_target
			 
			 7'b1101111:
			     begin
				      ctrl_signal=15'b0_1_0_1_0_1_011_010_00_0;      //opcode =111 j type jal
						//PC_src=1'b1;                                //for jump ins, pc_target should be taken
				  end
				  
			 7'b1100011:                                        //opcode =99, b-type bne,bqe
			     begin
				      ctrl_signal=15'b1_0_0_0_0_0_010_000_01_0;
						/*case(funct_3)
						    
							 3'b000:PC_src=zero;                       //beq
							 3'b001:PC_src=!zero;                      //bne
							 3'b100:PC_src=Alu_result_31;              //blt
							 3'b101:PC_src=!Alu_result_31;             //bge
							 3'b110:PC_src=Alu_result_31;              //bltu
							 3'b111:PC_src=!Alu_result_31;             //bgeu
							 default:PC_src=1'bx;
							 endcase */
					end
							 
			7'b1010011:ctrl_signal=15'b0_0_0_1_0_x_xxx_100_xx_1;  //for f type instructions 		
			 
			 default: ctrl_signal=15'bx_x_x_x_x_x_xxx_xx_xx_x;     //default incase opcode is wrong
		endcase
		
end

assign {Branch,Jal,Jalr,Reg_write,Mem_write,Src2_ctrl,imm_src,result_src,alu_op,float_ctrl}=ctrl_signal;
// ctrl_signal is the combination of all the 12 bit output from the control unit

endmodule
