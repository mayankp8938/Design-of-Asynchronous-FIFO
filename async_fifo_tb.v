`timescale 1ns / 1ps

module async_fifo_tb;

  // Parameters
  parameter WRITE_CLK_PERIOD = 20; // Time period for the write clock in ps
  parameter READ_CLK_PERIOD = 25;  // Time period for the read clock in ps

  // Inputs
  reg wclk, rclk, wrst, rrst, w_en, r_en;
  reg [7:0] data_in;

  // Outputs
  wire [7:0] data_out;
  wire full, empty;

  // Instantiate the async_fifo module
  async_fifo uut (
    .wclk(wclk),
    .rclk(rclk),
    .wrst(wrst),
    .rrst(rrst),
    .w_en(w_en),
    .r_en(r_en),
    .data_in(data_in),
    .data_out(data_out),
    .full(full),
    .empty(empty)
  );

  // Clock Generation
  reg wclk_gen = 0;
  reg rclk_gen = 0;
  always #((WRITE_CLK_PERIOD)/2) wclk_gen = ~wclk_gen;
  always #((READ_CLK_PERIOD)/2) rclk_gen = ~rclk_gen;

  // Initial block
  initial begin
    // Initialize inputs
    wclk = 0;
    rclk = 0;
    wrst = 1;
    rrst = 1;
    w_en = 0;
    r_en = 0;
    data_in = 8'b0;

    // Apply reset
    wrst = 0;
    rrst = 0;
    #10 wrst = 1;
    #10 rrst = 1;

    // Test scenario - Write and read multiple times
    repeat (5) begin
      // Write data to FIFO
      w_en = 1;
      data_in = $random;
      #10 w_en = 0;

      // Read data from FIFO
      r_en = 1;
      #10 r_en = 0;
    end

    // Stop simulation
    #50 $stop;
  end

  // Clock generation
  always #((WRITE_CLK_PERIOD)/2) wclk = wclk_gen;
  always #((READ_CLK_PERIOD)/2) rclk = rclk_gen;

endmodule
