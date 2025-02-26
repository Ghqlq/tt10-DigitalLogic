// `default_nettype none
// `timescale 1ns / 1ps

// /* This testbench just instantiates the module and makes some convenient wires
//    that can be driven / tested by the cocotb test.py.
//    Lab2
// */

// module tb ();

//   // Dump the signals to a VCD file. You can view it with gtkwave or surfer.
//   initial begin
//     $dumpfile("tb.vcd");
//     $dumpvars(0, tb);
//     #1;
//   end

//   // Wire up the inputs and outputs:
//   reg clk;
//   reg rst_n;
//   reg ena;
//   reg [7:0] ui_in;
//   reg [7:0] uio_in;
//   wire [7:0] uo_out;
//   wire [7:0] uio_out;
//   wire [7:0] uio_oe;
// `ifdef GL_TEST
//   wire VPWR = 1'b1;
//   wire VGND = 1'b0;
// `endif

//   // Replace tt_um_example with your module name:
//   tt_um_example user_project (

//       // Include power ports for the Gate Level test:
// `ifdef GL_TEST
//       .VPWR(VPWR),
//       .VGND(VGND),
// `endif

//       .ui_in  (ui_in),    // Dedicated inputs
//       .uo_out (uo_out),   // Dedicated outputs
//       .uio_in (uio_in),   // IOs: Input path
//       .uio_out(uio_out),  // IOs: Output path
//       .uio_oe (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
//       .ena    (ena),      // enable - goes high when design is selected
//       .clk    (clk),      // clock
//       .rst_n  (rst_n)     // not reset
//   );

// endmodule


`timescale 1ns/1ps
module testbench;
    reg [7:0] ui_in;
    reg [7:0] uio_in;
    wire [7:0] uo_out;

    // Instantiate the priority encoder
    tt_um_priority_encoder uut (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(uio_in),
        .uio_out(),
        .uio_oe(),
        .ena(1'b1),
        .clk(1'b0),
        .rst_n(1'b1)
    );

    initial begin
        // Test Cases
        ui_in = 8'b00101010; uio_in = 8'b11110001; #10; // Expected Output: 13
        $display("Input: %b%b, Output: %d", ui_in, uio_in, uo_out);

        ui_in = 8'b00000000; uio_in = 8'b00000001; #10; // Expected Output: 0
        $display("Input: %b%b, Output: %d", ui_in, uio_in, uo_out);

        ui_in = 8'b00000000; uio_in = 8'b00000000; #10; // Expected Output: 1111_0000
        $display("Input: %b%b, Output: %b", ui_in, uio_in, uo_out);

        ui_in = 8'b10000000; uio_in = 8'b00000000; #10; // Expected Output: 15
        $display("Input: %b%b, Output: %d", ui_in, uio_in, uo_out);

        $stop;
    end
endmodule

