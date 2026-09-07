`timescale 1ns / 1ps

module tb_guardian_fsm;
  reg clk;
  reg rst;
  reg fault_in;
  reg activate_in;

  wire [1:0] state;

  // Instantiate the guardian_fsm module
  guardian_fsm uut (
    .clk(clk),
    .rst(rst),
    .fault_in(fault_in),
    .activate_in(activate_in),
    .state(state)
  );

    // Testbench logic can be added here to drive inputs and monitor outputs

    // Example testbench logic
    initial begin
      // Initialize inputs
      #10 clk = 0;
      #10 $display("State after clk asserted: %b", state);

      #10 rst = 1; // move to RESET
      #10 $display("State after rst = 1 asserted: %b", state);

      // Apply reset
      #10 rst = 0; 
      #10 $display("State after rst = 0 asserted: %b", state); // Move to IDLE

      #10 activate_in = 0;
      #10 $display("State after activate_in = 0 asserted: %b", state);

      #10 activate_in = 1;
      #10 $display("State after activate_in = 1 asserted: %b", state); // Move to ACTIVE

      // Apply test stimuli
      #10 fault_in = 1;
      #10 $display("State after fault_in = 1  asserted: %b", state);
     
      #10 fault_in = 0;
      #10 $display("State after fault_in = 0 asserted: %b", state);

      #10 $display("Final state: %b", state);
      // End simulation
      #10 $finish;
    end

    // Clock generation
    always #5 clk = ~clk;
    
endmodule