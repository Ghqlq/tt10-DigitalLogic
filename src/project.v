// /*
//  * Copyright (c) 2024 Your Name
//  * SPDX-License-Identifier: Apache-2.0
//  */

// `default_nettype none

// module tt_um_priority_encoder (
//     input  wire [7:0] ui_in,    // Dedicated inputs
//     output wire [7:0] uo_out,   // Dedicated outputs
//     input  wire [7:0] uio_in,   // IOs: Input path
//     output wire [7:0] uio_out,  // IOs: Output path
//     output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
//     input  wire       ena,      // always 1 when the design is powered, so you can ignore it
//     input  wire       clk,      // clock
//     input  wire       rst_n     // reset_n - low to reset
// );

//   // All output pins must be assigned. If not used, assign to 0.
//   assign uo_out  = out_data;
//   assign uio_out = 8'b00000000;
//   assign uio_oe  = 8'b00000000;

/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_priority_encoder (
    input  wire [7:0] ui_in,    // 8-bit input A
    output wire [7:0] uo_out,   // 8-bit output C
    input  wire [7:0] uio_in,   // 8-bit input B
    output wire [7:0] uio_out,  // Unused, assigned to 0
    output wire [7:0] uio_oe,   // Unused, assigned to 0
    input  wire       ena,      // Always 1 when powered, ignored
    input  wire       clk,      // Clock, not used in combinational logic
    input  wire       rst_n     // Active low reset, ignored
);

    wire [15:0] in_data;  // Combined input signal
    wire [7:0] out_data;  // Output from priority encoder

    // Combine A[7:0] and B[7:0] to form In[15:0]
    assign in_data = {ui_in, uio_in};

    // Instantiate the priority encoder module
    priority_encoder_16bit encoder (
        .in(in_data),
        .out(out_data)
    );

    // Assign outputs
    assign uo_out  = out_data;
    assign uio_out = 8'b00000000;
    assign uio_oe  = 8'b00000000;

    // Prevent warnings for unused inputs
    wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule


// Priority Encoder Module (Must be outside the first module)
module priority_encoder_16bit (
    input wire [15:0] in,  // 16-bit input
    output reg [7:0] out   // 8-bit output
);
    always @(*) begin
        if (in[15] == 1) out = 8'd15;
        else if (in[14] == 1) out = 8'd14;
        else if (in[13] == 1) out = 8'd13;
        else if (in[12] == 1) out = 8'd12;
        else if (in[11] == 1) out = 8'd11;
        else if (in[10] == 1) out = 8'd10;
        else if (in[9] == 1) out = 8'd9;
        else if (in[8] == 1) out = 8'd8;
        else if (in[7] == 1) out = 8'd7;
        else if (in[6] == 1) out = 8'd6;
        else if (in[5] == 1) out = 8'd5;
        else if (in[4] == 1) out = 8'd4;
        else if (in[3] == 1) out = 8'd3;
        else if (in[2] == 1) out = 8'd2;
        else if (in[1] == 1) out = 8'd1;
        else if (in[0] == 1) out = 8'd0;
        else out = 8'b1111_0000; // Special case: No '1' found
    end

endmodule

