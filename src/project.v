/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_priority_encoder (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  wire [15:0] in_data;
  reg [7:0] out_data;

  // Combine A[7:0] and B[7:0] to form In[15:0]
  assign in_data = {ui_in, uio_in};

  always @(*) begin
    casez (in_data) // Prioritizes highest bit first
      16'b1???????????????: out_data = 8'd15;
      16'b01??????????????: out_data = 8'd14;
      16'b001?????????????: out_data = 8'd13;
      16'b0001????????????: out_data = 8'd12;
      16'b00001???????????: out_data = 8'd11;
      16'b000001??????????: out_data = 8'd10;
      16'b0000001?????????: out_data = 8'd9;
      16'b00000001????????: out_data = 8'd8;
      16'b000000001???????: out_data = 8'd7;
      16'b0000000001??????: out_data = 8'd6;
      16'b00000000001?????: out_data = 8'd5;
      16'b000000000001????: out_data = 8'd4;
      16'b0000000000001???: out_data = 8'd3;
      16'b00000000000001??: out_data = 8'd2;
      16'b000000000000001?: out_data = 8'd1;
      16'b0000000000000001: out_data = 8'd0;
      16'b0000000000000000: out_data = 8'b1111_0000; // Special case: No 1s found
      default: out_data = 8'd0;
    endcase
  end

  // Assign output
  assign uo_out  = out_data;
  assign uio_out = 8'b00000000;
  assign uio_oe  = 8'b00000000;

  // Prevent warnings for unused inputs
  wire _unused = &{ena, clk, rst_n, 1'b0};
endmodule

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
