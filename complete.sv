//############################################
//dut
//interface
//trasaction
//sequence or generator
//driver
//monitor
//agent and sequencer
//scoreboard
//environment
//test
//tb
//############################################

//dut
module adder(
  input [2:0] a, b,
  output [3:0] c);
  
  assign c = a + b;

endmodule

//interface
interface add_inf;
  logic [2:0] a;
  logic [2:0] b;
  logic [3:0] c;

endinterface

`include "uvm_macros.svh"
import uvm_pkg::*;

//trasaction
//###################################################################
class transaction extends uvm_sequence_item;
  rand logic[2:0] a;
  rand logic[2:0] b;
  logic [3:0] c;
  
  function new(input string path = "transaction")
    super.new(path)
  endfunction
  
  `uvm_object_utils_begin(transaction)
  `uvm_field_int(a,UVM_DEFAULT);
  `uvm_field_int(b,UVM_DEFAULT);
  `uvm_field_int(c,UVM_DEFAULT);
  `uvm_object_utils_end
  
endclass
//###################################################################  

//sequence or generator
//###################################################################
class generator extends uvm_sequence #(transaction);
  `uvm_object_utils(generator)
  
  transaction t;
  integer i;
  
  function new(input string path = "generator")
    super.new(path)
  endfunction
  
  virtual task body();//what
    t = transaction::type_id::create("t");
    repeat(10);
    begin
      start_item(t);
      t.randomize();
      `uvm_info("GEN",$sformatf("data ready for driver a: %0d, b:%0d",t.a,t.b),UVM_NONE);
      finish_item(t);
    end
  endtask
  
endclass
//###################################################################

//driver
//###################################################################
class driver extends uvm_driver #(transaction);
  `uvm_component_utils(driver)
  
  function new(input string path = "driver", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  transaction tc;
  virtual add_inf aif;
  
  virtual function void build_phase(uvm_phase phase);//what
    super.build_phase(phase);
    tc = transaction::type_id::create("tc");
    
    if(!uvm_config_db#(virtual add_inf)::get(this,"","aif",aif))//what
      `uvm_error("DRV","unable to access uvm_config_db");
  endfunction
  
  virtual task run_phase(uvm_phase phase);//what
    forever begin
      seq_item_port.get_next_item(tc);//what
      aif.a <= tc.a;
      aif.b <= tc.b;
      `uvm_info("DRV","item sent from tc to aif",UVM_NONE);
      `uvm_info("DRV",$sformatf("trigger item a=%0d, b=%0d",tc.a,tc.b),UVM_NONE);
      seq_item_port.item_done();
      #10;
    end
  endtask
endclass
//###################################################################
      
    

//monitor
//###################################################################
class monitor extends uvm_monitor
  `uvm_component_utils(monitor)
  
  uvm_analysis_port #(transaction) send;//what
  
  function new(input string path = "monitor", uvm_component parent = null)
    super.new(path, parent);
    send = new("send",this);
  endfunction
  
  transaction t;
  virtual add_inf aif;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    t = transaction::type_id::create("t");
    
    if(!uvm_config_db#(virtual add_inf)::get(this,"","aif",aif))
      `uvm_error("MON","unable to access uvm_config_db");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    forever begin
      #10;
      t.a = aif.a;
      t.b = aif.b;
      t.c = aif.c;
      `uvm_info("MON", $sformatf("data sent to scoreboard a:%0d, b:%0d, c:%0d",t.a, t.b, t.c), UVM_NONE);
      send.write(t);
    end
  endtask
  
endclass


//agent and sequencer
//###################################################################
class agent extends uvm_agent;
  `uvm_component_utils(agent)
  
  function new(input string inst = "agent", uvm_component c);
    super.new(inst, c);
  endfunction
  
  monitor m;
  driver d;
  uvm_sequencer #(transaction) seqr;	
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m = monitor::type_id::create("m", this);
    d = driver::type_id::create("d", this);
    seqr = uvm_sequencer #(transaction)::type_id::create("seqr", this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    d.seq_item_port.connect(seqr.seq_item_export);
  endfunction
  
endclass  
  

//scoreboard
class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  
  uvm_analysis_imp #(transaction, scoreboard) recv;
  
  transaction tr;
  
  function new(input string path = "scoreboard", uvm_component parent = null);
    super.new(path, parent);
    recv = new("recv", this);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build(phase);
    tr = transaction::type_id::create("tr");
  endfunction
  
  virtual function void write(inpur transaction tr);
    tr = t;//what
    `uvm_info("SCO",$sformatf("data rcvd from monitor a:%0d, b:%0d, c:%0d", tr.a, tr.b, tr.c), UVM_NONE);
    if(tr.c == tr.a + tr.b)
      $display("test passed");
    else
      $display("test failed");
  endfunction
  
endclass
  
  
  
//environment
class env extends uvm_env;
  `uvm_component_utils(env)
  
  function new(input string inst = "env", uvm_component c);
    super.new(inst, c);
  endfunction
  
  scoreboard s;
  agent a;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    s = scoreboard::type_id::create("s", this);
    a = agent::type_id::create("a", this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    a.m.send.connect(s.recv);
  endfunction
  
endclass


  
//test
class test extends uvm_test;
  `uvm_component_utils(test)
  
  function new(input string inst = "test", uvm_component c);
    super.new(inst, c);
  endfunction
  
  generator gen;
  env e;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    gen = generator::type_id::create("gen", this);
    e = environment::type_id::create("e", this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    gen.start(e.a.seqr);
    #50;
    phase.drop_objection(this);
  endtask
  
endclass
  
//tb
module tb;
  /*logic [2:0] a, b;
  logic [3:0] c;*/
  add_inf add_inf1();
  adder adder1(.a(add_inf1.a),.b(add_inf1.b),.c(add_inf1.c));
  
  initial begin
    add_inf1.a = 2; add_inf1.b = 2;
    #5;
    add_inf1.a = 3; add_inf1.b = 3;
    
  end
  always@(add_inf1.a,add_inf1.b) $display("a = %0d, b = %d, c = %d",add_inf1.a,add_inf1.b,add_inf1.c);
  
  initial begin  
    uvm_config_db #(virtual add_inf)::set(null, "uvm_test_top.e.a*", "add_inf1", add_inf1);//what
	run_test("test");
	end
endmodule