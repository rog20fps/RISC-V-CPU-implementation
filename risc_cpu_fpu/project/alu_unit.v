module alu_unit #(parameter V=32)
(            
				input       [3:0]   alu_ctrl,
            input       [V-1:0] src_a,src_b,
				output              zero,
			   output reg  [V-1:0] alu_result,
				output              Alu_result_31 
);
				
				
always @(src_a,src_b,alu_ctrl)
begin
case(alu_ctrl)
     
	  4'b0000:alu_result <= src_a + src_b;                                // add,addi
     4'b0001:alu_result <= src_a + ~src_b + 1'b1;                           // sub,subi
     4'b0010:alu_result <= src_a << src_b[4:0];                          // sll,slli
     4'b0011:alu_result <= {31'b0,(src_a[31]==src_b[31])?(src_a<src_b):src_a[31]};   //slt,slti
     4'b0100:alu_result <= {31'b0,src_a<src_b};                          // sltu,sltui
     4'b0101:alu_result <= src_a ^ src_b;                                // xor
     4'b0110:alu_result <= src_a >> src_b[4:0];                          // srl,srli
     4'b0111:alu_result <= $signed(src_a) >>> src_b[4:0];                // sra,srai
     4'b1000:alu_result <= src_a | src_b;                                // or,ori
     4'b1001:alu_result <= src_a & src_b;                                // and,andi
     default:alu_result <= 32'bx;
endcase
end
assign zero = (alu_result==0)?1'b1:1'b0;                                   // zero flag for b type 
assign Alu_result_31 = alu_result[31];
endmodule 
