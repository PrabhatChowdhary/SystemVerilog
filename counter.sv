// Code your testbench here
// or browse Examples
module counter(
  input clk,
  output[2:0] counter
);
  
  reg [2:0] counter_reg;
  
  assign counter = counter_reg;
  
  initial begin
    counter_reg=0;
  end
  
  always@(posedge clk) begin
    counter_reg = counter_reg+1;
    $display("counter reg is %d",counter_reg);
  end
endmodule

module tb;
  reg clk;
  reg[2:0] counter;
  
  counter counter1(
    .clk(clk),
    .counter(counter)
  );
  
  always begin
    #5 clk=~clk;
  end
  
  initial begin
    clk=0;
  end
  
  always@(*) begin
    $display("time=%0t, clk=%b, counter=%d",$time,clk,counter);
  end
endmodule

  
 

  
  