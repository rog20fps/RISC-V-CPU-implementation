module mux4 #(parameter V=32 )

(       input      [V-1:0]  a,b,c,d,
        input               s0,s1,
        output reg [V-1:0]  y);

always @(*)
begin

	y = s1 ? (s0?d:c) : (s0?b:a);
	
end
endmodule
