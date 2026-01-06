module mux8 #(parameter V=32 )

(       input      [V-1:0]  a,b,c,d,e,f,g,h,
        input               s0,s1,s2,
        output reg [V-1:0]  y);

always @(*)
begin

	case({s2,s1,s0})
	
	3'b000: y=a;
	3'b001: y=b;
	3'b010: y=c;
	3'b011: y=d;
	3'b100: y=e;
	3'b101: y=f;
	3'b110: y=g;
	3'b111: y=h;
	
	endcase
	
end
endmodule
