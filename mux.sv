// Code your testbench here
// or browse Examples
module mux(
  input logic sel, a, b,
  output logic op
);
  
  always@(sel,a,b)
    begin
      op <= (~sel && a) + (sel && b);
    end
endmodule

//tb
module tb;
  logic a,b,sel1,op;
  
  mux mux1(
    .sel(sel1),
    .a(a),
    .b(b),
    .op(op)
  );
  
  initial
    begin
      a=0;
      b=1;
      sel1=0;
      #5 sel1=1;
      #5 sel1=0;
    end
  always@(*)
    begin
      $display("time= %0t, a=%b, b=%b, sel=%b, op=%b",$time, a,b,sel1,op);
    end
endmodule

  