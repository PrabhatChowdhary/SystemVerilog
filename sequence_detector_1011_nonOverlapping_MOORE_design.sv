//https://www.fpga4student.com/2017/09/verilog-code-for-moore-fsm-sequence-detector.html
// Code your testbench here
// or browse Examples

module sequence_detector(
  input logic inp, 
  input logic clk, 
  input logic rst,
  output logic seq_found
);
  
  reg [2:0] present_state, next_state;
 
  parameter a=3'b000,
  b=3'b001,
  c=3'b011,
  d=3'b010,
  e=3'b110;
 
  always@(posedge clk, posedge rst)
    begin
      if(rst==1)
        present_state <= a;
      else
        present_state <= next_state;
    end
  
  always@(present_state,inp)
    begin
      case(present_state)
        a:begin
          if(inp == 1)
            next_state = b;
          else
            next_state = a;
        end
        b:begin
          if(inp == 0)
            next_state = c;
          else
            next_state = b;
        end
        c:begin
          if(inp == 1)
            next_state = d;
          else
            next_state = a;
        end
        d:begin
          if(inp == 1)
            next_state = e;
          else
            next_state = c;
        end
        e:begin
          if(inp == 1)
            next_state = b;
          else
            next_state = a;
        end
        default:next_state = a;
      endcase
    end
  
  always@(present_state)
    begin
      case(present_state)
        a:begin
          seq_found = 0;
        end
        b:begin
          seq_found = 0;
        end
        c:begin
          seq_found = 0;
        end
        d:begin
          seq_found = 0;
        end
        e:begin
          seq_found = 1;
        end
        default:seq_found = 0;
      endcase
    end
endmodule

//tb
module tb;
  
  logic inp,clk,rst,seq_found;

sequence_detector seq_det1(
  .inp(inp), 
  .clk(clk), 
  .rst(rst),
  .seq_found(seq_found)
);

  always #5 clk=~clk;
  
  initial 
    begin
      rst=1;//without this present state won't be initialized to a;
      clk=1;
      #1 rst=0;
      #8
      inp=1;
      #10
      inp=0;
      #10
      inp=1;
      #10
      inp=1; // output should go 1 here @ time = 39 , since clk goes 1 at t=40 so at t=50 op should be 1
    //  #10
    //  inp=0;
      #10
      inp=1;
      #10
      inp=0;
      #10
      inp=1;
      #10
      inp=1; //output should become here 1 sec after t=79 i.e. t=80
    end
  
  always@(*)
    begin
      if($time<200)
        $display("time = %0t, clk=%b, inp=%b, seq_found=%b",$time, clk, inp, seq_found);
    end
endmodule

  
  
      
     
  
