module data_memory #(parameter V=32 , ram_size=128)
( 
    input              clk , Mem_write,
	 input      [2:0]   funct_3,
	 input      [V-1:0] wrdata_add,wrdata, // wrdata_add is the address of wr_data 
	 output reg [V-1:0] read_data        
);

reg [V-1:0] data_ram[0:ram_size-1];     //data memory of 32 bit wide having 1024 address 
wire [V-1:0] word_add = wrdata_add[V-1:2] % 512; 
//assign read_data = data_ram[wrdata_add[V-1:2] % 64];

always @(*)
begin 

    casez(funct_3)
	 
	    3'b?00:begin                         //load byte (unsigned,signed)
	           case(wrdata_add[1:0])          
				     2'b00 :read_data <= funct_3[2] ? {24'b0,data_ram[word_add][7:0]}   : {{24{data_ram[word_add][7]}},data_ram[word_add][7:0]};
				     2'b01 :read_data <= funct_3[2] ? {24'b0,data_ram[word_add][15:8]}  :{{24{data_ram[word_add][15]}},data_ram[word_add][15:8]};
				     2'b10 :read_data <= funct_3[2] ? {24'b0,data_ram[word_add][23:16]} : {{24{data_ram[word_add][23]}},data_ram[word_add][23:16]};
				     2'b11 :read_data <= funct_3[2] ? {24'b0,data_ram[word_add][31:24]} : {{24{data_ram[word_add][31]}},data_ram[word_add][31:24]};
				   endcase  
				  end 
					
		3'b?01:begin                          //load half (unsigned,signed)
		       case(wrdata_add[1])
				      1'b0 :read_data <= funct_3[2] ? {16'b0,data_ram[word_add][15:0]}  : {{16{data_ram[word_add][15]}},data_ram[word_add][15:0]};
				      1'b1 :read_data <= funct_3[2] ? {16'b0,data_ram[word_add][31:16]} : {{16{data_ram[word_add][31]}},data_ram[word_add][31:16]};
				     
					endcase
					end
		3'b010: read_data=data_ram[word_add];	//load word 
		default:read_data=32'bx;			
		endcase
end

always @(posedge clk)
begin 

if(Mem_write)
begin
   case(funct_3)
	
	  3'b000:begin                //store byte 
	    case(wrdata_add[1:0])
		     2'b00:data_ram[word_add][7:0]  =wrdata[7:0];
			  2'b01:data_ram[word_add][15:8] =wrdata[7:0];
			  2'b10:data_ram[word_add][23:16]=wrdata[7:0];
			  2'b11:data_ram[word_add][31:24]=wrdata[7:0];
		 endcase 
		 end
		 
	  3'b001:begin                    //store half word 
	    case(wrdata_add[1])
		     1'b0:data_ram[word_add][15:0]  =wrdata[15:0];
			  1'b1:data_ram[word_add][31:16] =wrdata[15:0];
		 endcase 
		end 
		 
	  3'b010: data_ram[word_add] <= wrdata; //store word
	  default:data_ram[word_add] <= 32'bx;
	 endcase
end 
end
endmodule 
				   
					  
			  