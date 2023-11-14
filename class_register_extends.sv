  class C;
    int x;
    task set(int i);//can add delay in task. Use input output to return.
      x=i;
    endtask
    function int get;//can't add delay in fnc
      return x;
    endfunction
  endclass

class Register;// #(parameter int N=1);
  logic [7:0] data;
endclass

//class ShiftRegister #(parameter int N=1) extends Register;
class ShiftRegister extends Register;
  task shiftleft; data=data>>1; endtask
  task shiftright; data=data<<1; endtask
endclass

module tb();
  C c1 = new;
  //Register #(8) R8= new;
  Register R8= new;
  ShiftRegister s1 = new;
  //ShiftRegister #(8) s1 = new;
  logic [2:0] test;
  initial 
    begin
      //test = 3'b101;
      test = 3;
      //R8=8'b00001000;
      R8.data=8'b101;
      c1.set(9);
      $display("c1 is %0d ",c1.get());
      $display("test is %0h ",test);
      $display("R8 is %0h ",R8.data);
      
      s1.data=8'b111;
      $display("s1 is %0h ",s1.data);
      s1.shiftleft();
      $display("s1 is %0h ",s1.data);
      
    end
endmodule