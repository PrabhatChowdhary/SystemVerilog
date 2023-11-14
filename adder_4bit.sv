// Code your testbench here
// or browse Examples
module adder(
  input logic[3:0] a,b,
  output logic[3:0] c
);
  
  //assign c=a+b;
 
  always_comb
    begin
      c<=a+b;
    end
    
endmodule

module tb;
  logic[3:0] a,b1,c;
  adder adder1(
    .a(a), .b(b1), .c(c)
  );
  
  initial begin
    #1 a=4;b1=4;
    #1 a=1;b1=3;
    #1 a=15; b1=4;
  end
  
  always@(a,b1,c) begin
    $display("a=%d, b=%d, c=%d",a,b1,c);
  end
endmodule
