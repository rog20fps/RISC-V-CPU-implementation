module reset_ff #(parameter V = 32) (
    input       clk, rst,stall_f,
    input       [V-1:0] d,
    output reg  [V-1:0] q
);

always @(posedge clk or posedge rst)
begin
    if (rst) q <= 0;
    else if(stall_f) q <= q; //if pipeline should be stalled , previous value should be retained . 
	 else q<=d;
end

endmodule
