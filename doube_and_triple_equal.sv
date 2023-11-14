// Code your testbench here
// or browse Examples
module compare;
  reg a,b,y;
  
  initial begin
    a=1'b1;b=1'bx;y=1'bx;
    #10
    $display("1'bx===1'b1 %d",a===b); //0
    $display("1'bx===1'bx %d",b===y); //x
    $display("1'bx!=1'b1 %d",a!=b); //x
    $display("1'bx==1'bx %d",y!=b); //x
  end
endmodule
    