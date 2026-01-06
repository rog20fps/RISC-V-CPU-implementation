module branch_prediction
( 
   input [6:0]  opcode,
	input [2:0]  funct_3,
	input [31:0] rd1,rd2,alu_result_m,
	input        forward_AD,forward_BD,
	
	output reg [31:0] rd1_d,rd2_d,
   output reg        PC_src
);

reg [31:0] answer;
reg   answer_zero,answer_31;

always @(*)
begin
PC_src=1'b0;

rd1_d =(forward_AD==1) ? alu_result_m : rd1;
rd2_d =(forward_BD==1) ? alu_result_m : rd2;

answer = rd1_d + ~rd2_d + 1'b1;
answer_zero = (answer==0)?1'b1:1'b0;                                  
answer_31 = answer[31];


if(opcode==7'b1100011)
begin 
    
	 case(funct_3)
						    
							 3'b000:PC_src=answer_zero;                       //beq
							 3'b001:PC_src=!answer_zero;                      //bne
							 3'b100:PC_src=answer_31;              //blt
							 3'b101:PC_src=!answer_31;             //bge
							 //3'b110:PC_src=answer_31;              //bltu
							 //3'b111:PC_src=!answer_31;             //bgeu
							 3'b110:PC_src=rd1_d<rd2_d;
							 3'b111:PC_src=!(rd1_d<rd2_d);
							 default:PC_src=1'bx;
	 endcase 
					
end 

if(opcode==7'b1101111) PC_src=1;
end 
endmodule 
