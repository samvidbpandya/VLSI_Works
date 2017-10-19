`timescale 1ns/10ps

module dut (intf.idut ifx);

 

default clocking @(posedge (ifx.clk));

endclocking
always @(posedge ifx.clk)
begin
    $display("ix.cp2");
end 
  covergroup cg2 @(posedge(ifx.clk));
    cp2: coverpoint ifx.state {
      bins state_0_to_1 = (0=>1,4);
      bins state_1_to_2 = (1=>2,4);
      bins state_2_to_3 = (2=>3);
      bins state_3_to_5 = (3=>5,1);
      bins state_4_to_5 = (4=>5);
      bins state_5_to_1 = (5=>1,6);
	bins state_6_to_7 = (6=>7);
      bins state_7_to_0 = (7=>0,8);
	bins state_8_to_2 = (8=>2,4,14,9);
      bins state_14_to_0 = (14=>0);
    }
  endgroup

  cg2 cv = new;
 


endmodule

