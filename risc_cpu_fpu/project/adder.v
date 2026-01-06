module adder #(parameter V=32)

(     input   [V-1:0] a,b,
      output  [V-1:0] y);

assign y=a+b;

endmodule
