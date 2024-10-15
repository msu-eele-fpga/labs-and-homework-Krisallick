# Lab 7: Verifying Your Custom Component Using System Console and /dev/mem
## Overview
In this lab, we took our Soc_system component, added the JTAG master component to it, and ran the FPGA through software rather than hardware via JTAG and UART.
Then created a devmem executable to put onto the SD card that the
FPGA can boot from. This allowed for the UART portion of the lab, where we accessed the linux kernal 
system within the SD card to run devmem. 
# Deliverables
There were no deliverables for this lab.
# Questions
1. 0x1 was written to base_period to give it a value of 0.125, because that would make base_period 0000 0001 within our led_patterns and the four least significant bits are the fractional bits.
2. 0x9 was written to base_period to give it a value of 0.5625, for the same reason as in 1, but base_period would be 0000 1001 in our led_patterns instead.