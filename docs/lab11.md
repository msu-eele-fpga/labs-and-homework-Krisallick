# Lab 11: Platform Device Driver

# Overview
In this lab we created a device driver for our LED patterns component to interact with our device tree we made in the previous lab

# Deliverables

# Questions

1. The purpose of the platform bus is to connect the hardware to the operating system so that it knows the hardware exists.
2. The device driver's compatible property is important, because it is what binds the device to our driver.
3. The purpose of the Probe function is used to do something once the hardware device is bound.
4. It knows what memory addresses are associated because we define the offsets at the beginning of the driver
5. We use both the Write and the Store functions.
6. The purpose of our struct led_patterns_dev state container is to contain everything we need to look at for the the device like addresses and such.
