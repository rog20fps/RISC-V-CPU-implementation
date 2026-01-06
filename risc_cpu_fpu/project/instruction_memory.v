module instruction_memory #(parameter V=32 , ram_size=512)
(
   input  [V-1:0] instr_address,       //address where the instructions are stored 
	output [V-1:0] instr                //instructions from hex file to binary
);

reg [V-1:0] instr_ram [0:ram_size-1];  //1024 instructions of 32 bt wide held in array of inst_ram


initial 
begin 
     
	  $readmemh("formatted_output_4.hex", instr_ram);           //reads the text file 
	  
end 

assign instr=instr_ram[instr_address[V-1:2]];  //fetches the instruction from inst_ram

endmodule
