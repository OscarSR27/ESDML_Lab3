# Vectorized Multiply

## Goal
The objective of this project is to develop an array multiplier that operates without Booth encoding or tree structures. The focus is on computing partial products through bit-by-bit or bit-by-bit_vector multiplication, utilizing Ripple Carry Adder (RCA) technique for addition. Additionally, the project aims to enhance the adder's functionality to accurately process the sign bit using two's complement and introduce vectorization. This involves strategically splitting and connecting the adders to sum the appropriate partial products and multiplexing the adder outputs for efficient computation.

## Files
Source file location: [multiplier.vhd](Lab3/Lab3.srcs/sources_1/imports/lab3_template_v2)

Simulation file location: [tb_multiplier.vhd](Lab3/Lab3.srcs/sim_1/imports/lab3_template_v2)

