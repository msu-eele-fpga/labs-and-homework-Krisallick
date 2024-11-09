ifneq ($(KERNELRELEASE),)
	obj-m := hello.o

else
	KDIR ?= ../../../Documents/Intel_linux/linux-socfpga

default:
	$(MAKE) -C $(KDIR) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- M=$$PWD

clean:
	$(MAKE) -C $(KDIR) M=$$PWD clean
endif
