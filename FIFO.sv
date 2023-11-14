// Code your testbench here
// or browse Examples
module FIFO(
  input logic w_en, r_en,
  input logic [7:0] data_in,
  input logic clk,
  output full,empty,
  output [7:0] data_out
);
  logic [7:0] memory[15:0];
  
  //to track 16 memory locations we need 4 bits
  logic [3:0] w_ptr, r_ptr;
  
  //full and empty conditions for FIFO
  assign full = (r_ptr==(w_ptr+1'b1));
  assign empty = (w_ptr==r_ptr);
  
  always@(posedge clck)
    begin
      if(w_en==1 & !full) begin
        memory[w_ptr] <= data_in;
      	w_ptr++;
      end
    end
  
  always@(posedge clck)
    begin
      if(r_en==1 & !empty) begin
        data_out <= memory[w_ptr];
      	r_ptr++;
      end
    end
endmodule

  
  
  
   
  
  
      
  