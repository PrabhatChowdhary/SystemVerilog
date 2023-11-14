//sequence detector code for memryX interview question
// Code your testbench here
// or browse Examples
module fsm(
  input logic cycle,
  input logic trig_a,
  input logic rst,
  input logic leave_c,
  output logic start_of_a,
  output logic end_of_b
);
  //for 4 states we need 2 bits
  logic[1:0] present_state,next_state;
  //defining state names
  parameter IDLE=2'b00, A=2'b01, B=2'b11, C=2'b10;
  //defining cycle_counter
  logic[3:0] cycle_counter=0;//4 bits because we would need to calculate max 8 cycles(0 to 7)
  
  
  always@(posedge cycle, posedge rst) begin
    if(rst==1) begin
      present_state <= IDLE;
      next_state <= IDLE;
      cycle_counter <= 0;
      start_of_a <= 0;
      end_of_b <= 0; 
    end
    else 
      present_state <= next_state;
  end
  
  
  always@(present_state, cycle) begin
    case(present_state)
      IDLE:begin
        if(trig_a==1) begin
          next_state <= A;
          cycle_counter <= 0;
        end
        else
          next_state <= IDLE;
      end
      A:begin
        if(cycle_counter==0) start_of_a <= 1;
        if(cycle_counter>=4) begin
          next_state <= B;
          cycle_counter <= 0;
        end
        else begin
          next_state <= A;
          cycle_counter++;
        end
      end
      B:begin
        if(cycle_counter >=8) begin
          next_state <= C;
          cycle_counter <= 0;
        end
        else begin
          next_state <= B;
          cycle_counter++;
        end
      end
      C:begin
        if(leave_c==1) begin
          next_state <= A;
          cycle_counter <= 0;
        end        	
        else
          next_state <= C;
      end
      default: next_state <= IDLE;
    endcase
    end
  always@(*) $display("time=%0t, cycle= %b,leave_c=%d, state=%d cycle_counter=%d",$time,cycle,leave_c,present_state,cycle_counter);
endmodule

module tb;
  logic cycle, trig_a, rst, leave_c, start_of_a, end_of_b;
  fsm fsm1(
    .cycle(cycle),
    .trig_a(trig_a),
    .rst(rst),
    .leave_c(leave_c),
    .start_of_a(start_of_a),
    .end_of_b(end_of_b)
  );
  always #5 cycle=~cycle;
  initial begin
    cycle = 0;
    rst =1;
    #1 rst =0;
    #18 trig_a=1;
    //12 clocks 
    #1200 leave_c=1;
  end
endmodule