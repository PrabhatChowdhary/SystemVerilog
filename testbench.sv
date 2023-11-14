// Code your testbench here
// or browse Examples
module Testbench;
  logic d, clk, rst, q;
  Dff dff1(.d(d), .clk(clk), .rst(rst), .q(q));
  
  //setting the clk
  always #10 clk = ~clk;
  
  initial
    begin
      clk=0;
      rst=0;
      
      //first test case
      #2 d= 1;
      #18 d= 0;
      #7 d= 1;
      #10 d= 0;
      #15 d=1;
      #10 $finish;
    end
  
  always @(* )begin
    $display("clkTime=%0t, d=%b, q=%b",$time,d,q);
  end
endmodule

    
      
     
      
  
