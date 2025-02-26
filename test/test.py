# # SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# # SPDX-License-Identifier: Apache-2.0 


# import cocotb
# from cocotb.clock import Clock
# from cocotb.triggers import ClockCycles


# @cocotb.test()
# async def test_project(dut):
#     dut._log.info("Start")

#     # Set the clock period to 10 us (100 KHz)
#     clock = Clock(dut.clk, 10, units="us")
#     cocotb.start_soon(clock.start())

#     # Reset
#     dut._log.info("Reset")
#     dut.ena.value = 1
#     dut.ui_in.value = 0
#     dut.uio_in.value = 0
#     dut.rst_n.value = 0
#     await ClockCycles(dut.clk, 10)
#     dut.rst_n.value = 1

#     dut._log.info("Test project behavior")

#     # Set the input values you want to test
#     dut.ui_in.value = 20
#     dut.uio_in.value = 30

#     # Wait for one clock cycle to see the output values
#     await ClockCycles(dut.clk, 1)

#     # The following assersion is just an example of how to check the output values.
#     # Change it to match the actual expected output of your module:
#     assert dut.uo_out.value == 50

#     # Keep testing the module by changing the input values, waiting for
#     # one or more clock cycles, and asserting the expected output values.

import cocotb
from cocotb.triggers import Timer

@cocotb.test()
async def test_priority_encoder(dut):
    dut._log.info("Starting test")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    # Full test cases covering all possible priority scenarios
    test_cases = [
        (0b10000000, 0b00000000, 15),
        (0b01000000, 0b00000000, 14),
        (0b00100000, 0b00000000, 13),
        (0b00010000, 0b00000000, 12),
        (0b00001000, 0b00000000, 11),
        (0b00000100, 0b00000000, 10),
        (0b00000010, 0b00000000, 9),
        (0b00000001, 0b00000000, 8),
        (0b00000000, 0b10000000, 7),
        (0b00000000, 0b01000000, 6),
        (0b00000000, 0b00100000, 5),
        (0b00000000, 0b00010000, 4),
        (0b00000000, 0b00001000, 3),
        (0b00000000, 0b00000100, 2),
        (0b00000000, 0b00000010, 1),
        (0b00000000, 0b00000001, 0),
        (0b00000000, 0b00000000, 0b11110000), # No bits set case
    ]

    for ui, uio, expected in test_cases:
        dut.ui_in.value = ui
        dut.uio_in.value = uio
        await Timer(2, units="ns")
        assert dut.uo_out.value == expected, f"Expected {expected}, got {int(dut.uo_out.value)}"
