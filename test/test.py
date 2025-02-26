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
from cocotb.result import TestFailure

@cocotb.test()
async def test_priority_encoder(dut):
    """Test the priority encoder with multiple inputs"""
    
    # Define test cases: (input, expected output)
    test_cases = [
        (0b0010101011110001, 13),
        (0b0000000000000001, 0),
        (0b0000000000000000, 0b11110000),
        (0b1000000000000000, 15)
    ]
    
    for inp, expected in test_cases:
        dut.ui_in.value = (inp >> 8) & 0xFF  # Upper 8 bits
        dut.uio_in.value = inp & 0xFF       # Lower 8 bits
        
        await Timer(10, units="ns")  # Wait for logic to settle

        if dut.uo_out.value != expected:
            raise TestFailure(f"Test failed: Input={inp:016b}, Expected={expected}, Got={dut.uo_out.value}")
        else:
            print(f"✅ PASS: Input={inp:016b}, Output={dut.uo_out.value}")

