// Code your testbench here
// or browse Examples
module mux(
  input logic sel, input logic[2:0] a, b,
  output logic[2:0] op
);
  
  always@(*)
    begin
      case(sel)
        0: op <= a;
        1: op <= b;
      endcase
    end
endmodule

//tb
module tb;
  logic[2:0] a,b,op;
  logic sel1;
  
  mux mux1(
    .sel(sel1),
    .a(a),
    .b(b),
    .op(op)
  );
  
  initial
    begin
      a=2;
      b=3'b001;
      sel1=0;
      #5 sel1=1; a=3'b101;
      #5 sel1=0; a=3'b011;
    end
  always@(*)
    begin
      $display("time= %0t, a=%h, b=%h, sel=%b, op=%h",$time, a,b,sel1,op);
    end
endmodule

  