`timescale 1ns/10ps
// This is a simple driver for a set of assertions used in EE272
// it is a state machine that will move through 8 states...
//

interface intf;
  logic clk,rst;
  logic [2:0] state;
  logic [2:0] old_state;

  modport itb(output clk,output rst,output state);
  modport idut(input clk,input rst,input state);

endinterface

module testbench;

intf ifx();
event fun;

default clocking clk1 @(posedge(ifx.clk));
endclocking

dut d(ifx.idut);

covergroup cg1 @(posedge(ifx.clk));
  cp1: coverpoint ifx.state {
    bins svals[] = { [0:7]};
  }
endgroup

covergroup cg2 @(posedge(ifx.clk));
  cp2: coverpoint ifx.state;
  option.at_least=30;
endgroup

covergroup cg3 @(posedge(ifx.clk));
  cp3: cross ifx.old_state,ifx.state;
endgroup

cg1 cv = new;
cg2 cv2= new;
cg3 cv3= new;

initial begin
  ifx.state=0;
  ifx.clk=0;
  ifx.rst=1;
  ##10;
  cv.start();
  ifx.rst=0;
//  while(cv2.cp2.get_coverage()<25) ##5;
  ##310;
  $display("\n\n\nAt the end of the run\n\n\n");
  cv.stop();
  $display("Coverage thing cp1 ",cv.cp1.get_coverage());
  $display("Coverage thing cp2 ",cv2.cp2.get_coverage());
  $display("Time is ",$time);
  $finish;
end

initial begin
  ifx.clk=0;
  forever #5 begin
    ifx.clk=~ifx.clk;
    if(ifx.clk==1) #1 -> fun;
  end
end

always @(fun) begin
  ifx.old_state=ifx.state;
  if(ifx.rst || ifx.state==9) begin
    ifx.state=0;
  end else begin
    case(ifx.state)
      0: ifx.state=1;
      1: randcase
           2: ifx.state=2;
           2: ifx.state=4;
         endcase //ifx.state=(($random%2)>0)?2:4;
      2: ifx.state=3;
      3: ifx.state=(($random%10)>8)?5:1;
      4: ifx.state=5;
      5: ifx.state=(($random%20)>9)?1:6;
      6: ifx.state=7;
      7: randcase
           5: ifx.state=0;
           3: ifx.state=5;
         endcase //ifx.state=(($random%3)>1)?0:5;
    endcase
    // an occasional error
//    if(($random&32'h0ff)>150) begin
//      ifx.state=ifx.state+1;
//      $display("----------- bugged");
//    end
  end
end




endmodule




