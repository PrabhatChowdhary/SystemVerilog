module fifo#(parameter x = 8, 
             parameter width = 4*x+1)
  (input clk, rst, wr, rd, 
  input [x-1:0] Wdata,
  output full, empty,
  output [(2*x)-1:0] Rdata
);
  
  reg [(2*x)-1:0] Rdata_reg;
  reg [width-1:0] mem;
  reg full_reg, empty_reg;

  
  always@(posedge clk)begin
    if(rst == 1)begin
      Rdata_reg <= 0;
      mem <= 1;
      full_reg <= 0;
      empty_reg <= 1;
    end
    if(wr == 1 && full_reg!=1)begin
      mem <= mem<<x;
      mem[x-1:0] <= Wdata;
      empty_reg <= 0;
    end
    if(rd == 1 && empty_reg!=1)begin    
      Rdata_reg <= mem[(2*x)-1:0];
      mem <= mem>>(2*x);
      full_reg <= 0;
    end
  end
  
  always@( negedge clk)begin
    if(mem==1)begin
      empty_reg <= 1;
    end
    if (mem[width-1] == 1'b 1) 
      full_reg <= 1;
  end
    
  
  assign Rdata = Rdata_reg;
  assign full = full_reg;
  assign empty = empty_reg;
  
  always@(*)$display("time=%0t, clk=%b, mem=%b, rst=%b, wr=%b, rd=%b, Wdata=%b, full=%b, empty=%b, Rdata=%b",$time, clk, mem, rst, wr, rd, Wdata, full, empty, Rdata);
  
endmodule

module tb;
  reg clk, rst, wr, rd;
  reg [8-1:0] Wdata;
  reg full, empty;
  reg [(16)-1:0] Rdata;
  
  fifo #(8)fifo1(
  .clk(clk), .rst(rst), .wr(wr), .rd(rd), 
  .Wdata(Wdata),
  .full(full), .empty(empty),
  .Rdata(Rdata)
  );
  
  always #5 clk = ~clk;
  
  initial begin
    rst = 1;
    clk =0;
    #20 rst = 0; wr =1; rd = 0; Wdata = 8'b 11111111;
    #42 wr = 0; rd = 1;
    #20 wr = 1; rd = 0; Wdata = 8'b 11111111;
    #50 wr = 0; rd = 1;
  end
endmodule