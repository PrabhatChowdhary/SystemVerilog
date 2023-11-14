class ABC;
  
  rand bit[3:0] a;
  constraint c1 { a>10;}
  static constraint c2 { a<15; }
  
endclass

module tb;	
  
  initial begin
    ABC a1=new;
    a1.c2.constraint_mode(0);
    for(int i=0;i<5;i++)
      begin
        a1.randomize();
        //a1.a=20;
        $display("%d",a1.a);
        //a1.a=a1.a+20;
        //$display("after adding %d",a1.a);
        end
    end
  
endmodule
	

