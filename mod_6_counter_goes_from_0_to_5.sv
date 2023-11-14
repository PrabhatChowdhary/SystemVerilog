// Code your testbench here
// or browse Examples
//there are other ways too like a simple counter that resets with if else if count reaches 5
//another way-making a kmap and reducing the combinational logic along with 3 FFs
module mod_five(
  input clk,rst,
  output [2:0] out
);
  parameter 
  a=3'b000, 
  b=3'b001, 
  c=3'b011, 
  d=3'b010, 
  e=3'b110, 
  f=3'b100;
  
  reg[2:0] present_state, next_state, out_reg;
  assign out = out_reg;
  
  always@(posedge clk) begin
    if(rst==1)begin
      present_state <= a;
      next_state <= a;
      out_reg <= 3'b000;
    end
    else
      present_state <= next_state;
  end
  
  //always@(present_state,clk) begin
  always@(posedge clk)begin
    case(present_state)
      a: begin 
        next_state <= b;
        out_reg <= 3'b000;
      end
      b:begin
        next_state <= c;
        out_reg <= 3'b001;
      end
      c:begin
        next_state <= d;
        out_reg <= 3'b010;
      end
      d:begin
        next_state <= e;
        out_reg <= 3'b011;
      end
      e:begin
        next_state <= f;
        out_reg <= 3'b100;
      end
      f:begin
        next_state <= a;
        out_reg <= 3'b101;
      end
      default:begin
        next_state <= a;
        out_reg <= 3'b000;
      end
    endcase
  end
  always@(*) $display("####################state=%d, out_reg=%d",present_state,out_reg);
endmodule

module tb;
  reg clk,rst; reg[2:0] out;
  mod_five mod_five1(
    .clk(clk),
    .out(out),
    .rst(rst)
  );
  always #5 clk=~clk;
  
  initial begin
    clk=0;
    rst=1;
    #9 rst = 0;
  end
  always@(clk) $display("time=%0t, clk=%d, out=%d",$time, clk, out);
endmodule