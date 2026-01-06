module register_file #(parameter V=32)
(
       input          clk,Reg_write,float_ctrl,
       input  [4:0]   rs1,rs2,wr_adder,
		 input  [V-1:0] wr_data,
		 output [V-1:0] rd1,rd2 );
					  
					  
reg [V-1:0] reg_file[0:31]; // creates 32 register of 32 bit wide , reg_file name of array
integer i;

initial
begin
    for(i=0;i<32;i=i+1) 
	     reg_file[i]=0;   //initialize all the registers to zero 
end

always @(posedge clk) 
begin 
    if(Reg_write)
        reg_file[wr_adder] <= wr_data;
end

assign rd1 = (rs1 !=0) ? reg_file[rs1]:0; //rd1 holds data inside rs1
assign rd2 = (rs2 !=0) ? reg_file[rs2]:0; //rd2 holds data inside rs2 


endmodule 
