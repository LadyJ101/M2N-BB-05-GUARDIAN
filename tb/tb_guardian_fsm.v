`timescale 1ns / 1ps

module tb_guardian_fsm;
  reg clk;
  reg rst;
  reg fault_in;
  reg activate_in;
  reg stop_in;
  wire active_out;
  wire fault_out;

  wire [1:0] state;

  // Instantiate the guardian_fsm module
  guardian_fsm uut (
    .clk(clk),
    .rst(rst),
    .fault_in(fault_in),
    .activate_in(activate_in),
    .state(state),
    .stop_in(stop_in),
    .active_out(active_out),
    .fault_out(fault_out)
  );


    initial begin
      $dumpfile("sim/guardian_fsm.vcd");
      $dumpvars(0, tb_guardian_fsm);

      // Initialize inputs
      clk         = 0;
      fault_in    = 0;
      activate_in = 0;
      stop_in     = 0;


        // move to RESET
      rst = 1; 
      #10 if (state == 2'b00 && active_out == 0 && fault_out == 0) begin
        #10 $display("State after rst = 1 asserted: %b", state);
        #10 $display("The value of active_out: %b", active_out);
        #10 $display("The value of fault_out: %b", fault_out);        
      end
      else begin
        #10 $display("XXXXX Test for rst = 1 failed");
        #10 $display("State after rst = 1 asserted: %b", state);
        #10 $display("The value of active_out: %b", active_out);
        #10 $display("The value of fault_out: %b", fault_out); 
        #10 $finish;         
      end


       // Start the system
      #10 rst = 0;
      #10 if (state == 2'b01 && active_out == 0 && fault_out == 0) begin
        #10 $display("State after rst = 0 asserted: %b", state);
        #10 $display("The value of active_out: %b", active_out);
        #10 $display("The value of fault_out: %b", fault_out);        
      end
      else begin
        #10 $display("XXXXX Test for rst = 0 failed");
        #10 $display("State after rst = 0 asserted: %b", state);
        #10 $display("The value of active_out: %b", active_out);
        #10 $display("The value of fault_out: %b", fault_out); 
        #10 $finish;         
      end 

      #10 activate_in = 1;
      #10 if (state == 2'b10 && active_out == 1 && fault_out == 0) begin
        #10 $display("State after activate_in = 1 asserted: %b", state); // Move to ACTIVE
        #10 $display("The value of active_out: %b", active_out);
        #10 $display("The value of fault_out: %b", fault_out);        
      end
      else begin
        #10 $display("XXXXX Test for activate_in = 1 failed");
        #10 $display("State after actvate_in = 1 asserted: %b", state);
        #10 $display("The value of active_out: %b", active_out);
        #10 $display("The value of fault_out: %b", fault_out); 
        #10 $finish;         
      end

      #10 stop_in = 1;
      #10 if (state == 2'b01 && active_out == 0 && fault_out == 0) begin
        #10 $display("State after stop_in = 1 asserted: %b", state); // Move to IDLE
        #10 $display("The value of active_out: %b", active_out);
        #10 $display("The value of fault_out: %b", fault_out);        
      end
      else begin
        #10 $display("XXXXX Test for stop_in = 1 failed");
        #10 $display("State after stop_in = 1 asserted: %b", state); // Move to IDLE
        #10 $display("The value of active_out: %b", active_out);
        #10 $display("The value of fault_out: %b", fault_out); 
        #10 $finish;         
      end
      
      // Apply fault, system move to protection mode immediately
      #10 fault_in = 1;
      #10 if (state == 2'b11 && active_out == 0 && fault_out == 1) begin
        #10 $display("State after fault_in = 1  asserted: %b", state);
        #10 $display("The value of active_out: %b", active_out);
        #10 $display("The value of fault_out: %b", fault_out);        
      end
      else begin
        #10 $display("XXXXX Test for fault_in = 1 failed");
        #10 $display("State after fault_in = 1  asserted: %b", state);
        #10 $display("The value of active_out: %b", active_out);
        #10 $display("The value of fault_out: %b", fault_out); 
        #10 $finish;         
      end
     
      // Reset the system
      #10 rst = 1;
      #10 if (state == 2'b00 && active_out == 0 && fault_out == 0) begin
        #10 $display("State after rst = 1 asserted: %b", state); // Move to RESET
        #10 $display("The value of active_out: %b", active_out);
        #10 $display("The value of fault_out: %b", fault_out);        
      end
      else begin
        #10 $display("XXXXX Test for rst_in = 1 failed");
        #10 $display("State after rst = 1 asserted: %b", state); // Move to RESET
        #10 $display("The value of active_out: %b", active_out);
        #10 $display("The value of fault_out: %b", fault_out); 
        #10 $finish;         
      end

      #10 $display("Final state: %b", state);
      // End simulation
      #10 $finish;
    end

    // Clock generation
     always #5 clk = ~clk;
    
endmodule