# Usage
This program operates in conjunction with both the Intel Cyclone V FPGA using a DE-10 development board and my personal led_patterns bitstream without either of those this program is essentially useless.
```
led [Option]...[Pattern] [Time]\n");
    led can be used to change the leds on the FPGA.\n");
    led will only write 32-bit values.\n\n");
   Arguments:\n");
   [Option]\n");
     -h        --halp        print help text\n");
     -v        --verbose     prints the pattern and display time as they happen\n");
     -f        --file        operate the pattern from a file\n");
     -p        --pattern     operate the leds by inputting a pattern and Time\n");
   [Pattern] The hex value to display (0x55)\n");
   [Time] The display time in milliseconds for that hex value (500)\n");
   ```
   ### Usage examples
   All examples will use the verbose argument otherwise nothing can be seen.

   Pattern Example: `./led -v -p 0x01 500 0x02 1000 0x03 300`

   File Example: `./led -v -f patterns.txt`

   ## Building
   Since this program is made for an the Cyclone V we need to cross compile into a 32-bit ARM program file. Also since, as of now, we have been putting this program on an SD card to run we have to cross compile with the `-static` flag. Also note that the building of this code will only work if done in a linux based system when done in this manner, either a VM or otherwise.

To cross compile: 

Step 1: navigate to where led_patterns.c is located in a linux system.

Step 2: Open terminal in that directory

Step 3: type `arm-linux-gnueabihf-gcc -o -led -led_patterns.c`. This does the actual cross compilation

Step 4: Copy the program created from that into the EXT-4 partition of the SD card, under /home/root.

Step 5: Congraduwelldone you have done the thing.