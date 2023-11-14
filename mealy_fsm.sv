// Code your testbench here
// or browse Examples
/*

 --> a(0)                 -->b(1)
 |0                       |0
 |                        |
-----        1          -----
| a |----------------->|  b |
-----                  ------
                         |
                         |1
                         |-->b(0)

*/
module fsm(
  input ip, clk,rst,
  output out_wire
);
  reg present_state, next_state;
  reg out;
  assign out_wire = out;
  //state names
  parameter a=0, b=1;
  //setting state sequence on clock
  always@(posedge clk) begin
    if(rst==1) begin
      present_state <= a;
      next_state <= a;
      out <= 0;
    end
    else begin
      present_state <= next_state;
    end
  end
  //setting next state and output sequence on  clk
  always@(present_state,ip) begin
    case(present_state) 
      a:begin
        if(ip==1) begin
          next_state <= b;
          out <= 1;
        end
        else begin
          next_state <= a;
          out <= 0;
        end
      end
      b:begin
        next_state <= b;
        if(ip==0) 
          out <= 1;
        else 
          out <= 0;
      end
      default: begin
        next_state <= a;
        out <= 0;
      end
      endcase
    end
  
  always@(*) $display("time=%0t,state = %b, ip=%d, out=%b",$time,present_state,ip,out);
endmodule

module tb;
  reg ip,out,clk,rst;
  fsm fsm1(
    .ip(ip),
    .out_wire(out),
    .clk(clk),
    .rst(rst)
  );
  always #5 clk=~clk;
  
  initial begin
    clk=0;
    rst=1;
    #9 rst = 0; ip = 1;
    #10 ip = 0;
    #10 ip = 1;
    #10 ip = 1;
    #10 ip = 0;
  end
  always@(*) 
    $display("time = %0t, clk=%b, ip=%b, out=%b",$time, clk, ip, out);
  
endmodule
      
      
      
       
        
  