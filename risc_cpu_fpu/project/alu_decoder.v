module alu_decoder(
       input        opcode_5,
		 input  [2:0] funct_3,
		 input  [6:0] funct_7,
		 input  [1:0] alu_op,
		 output reg [3:0] alu_ctrl
);

always @(*)
begin
     
	  case(alu_op)
	      
			2'b00:alu_ctrl=4'b0000;   // addation from i type 
			2'b01:alu_ctrl=4'b0001;   //subtraction from b type 
			
			2'b10:begin
			      case(funct_3)
					
					3'b000: alu_ctrl=(funct_7[5] && opcode_5)? 4'b0001 : 4'b0000; //add,addi,sub
					3'b001: alu_ctrl=4'b0010;                         //sll shift left logical  
					3'b010: alu_ctrl=4'b0011;                         //slt set less than 
					3'b011: alu_ctrl=4'b0100;                         // sltu set less than unsigned 
					3'b100: alu_ctrl=4'b0101;                         //xor
					3'b101: alu_ctrl=(funct_7[5])? 4'b0111 : 4'b0110; //sra , srl shift right(arthematical,logical)
					3'b110: alu_ctrl=4'b1000;                         //or 
					3'b111: alu_ctrl=4'b1001;                         //and 
					default :alu_ctrl=4'bxxxx;
					endcase
					end
					
	 default:alu_ctrl=4'bxxxx;				
    endcase					    
end 
endmodule
