module mux2 #(parameter 	V=32)
(     input      [V-1:0] a,b,
      input              s,
      output reg [V-1:0] y
);

always @(*)
begin
	y = s ? b : a ;
end
endmodule
