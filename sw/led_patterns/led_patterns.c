#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <sys/mman.h> //for mmap
#include <fcntl.h> //for file open flags
#include <unistd.h> // for getting the page size
#include <signal.h>
#include <string.h>

//-------------------flags for arguement checking
bool verbose = false;
bool halp = false;
bool pattern = false;
bool file = false;

//-------------------flag for checking if we are writing
bool is_write = false;
//-------------------
static volatile int dontStop = 1;
//-------------------
char* pvalue[20]={};//creating an array for arguments
unsigned int pvalue_uns[20]={};
int command;
char* pvalue_temp;
int i=0;
int size=0;

char* file_temp;
//-------------------memory mapping variables 
uint32_t ADDRESS;
uint32_t page_aligned_addr;
uint32_t *page_virtual_addr;
uint32_t offset_in_page;
volatile uint32_t *target_virtual_addr;
uint32_t VALUE;
size_t PAGE_SIZE;
int fd;
//-------------------


void address(int reg)     //sets address to the input register, i.e. address(1) = base_rate, address(0) = hps_led_control
{
  char temp[10]="0xFF20000";
  switch (reg)
      {
      case 0:
        temp[9]='0';    //0xFF200000
        break;

      case 1:
        temp[9]='4';    //0xFF200004
        break;

      case 2:
        temp[9]='8';    //0xFF200008
        break;
      }
  // printf("Printing temp: %s\n", temp);
  ADDRESS = strtoul(temp, NULL, 0); //converting a string to unsigned long int setting ADDRESS to Register 2 which is led
  page_aligned_addr = ADDRESS & ~(PAGE_SIZE-1);  
  uint32_t *page_virtual_addr= (uint32_t *)mmap(NULL, PAGE_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, page_aligned_addr);
  offset_in_page = ADDRESS & (PAGE_SIZE-1);
  target_virtual_addr = page_virtual_addr + offset_in_page/sizeof(uint32_t*);
}

void softwareMode(void)     //writes a 1 to register 0 switching FPGA to software mode
{
  address(0);
  VALUE = 1;        
  *target_virtual_addr = VALUE; //write value to the hardware memory address
}
void hardwareMode(void)     //writes a 0 to register 0 switching FPGA to hardware mode
{
  address(0);
  VALUE = 0;        
  *target_virtual_addr = VALUE; //write value to the hardware memory address
}

void to_binary(int n)
{
  int j=0;
  int binary[8]={0,0,0,0,0,0,0,0};
  while (j <= 7) 
  {
    binary[j] = n % 2;
    n = n / 2;
    j++;
  }
    // printing binary array in reverse order
    for (j=7; j >= 0; j--)
    {
        printf("%d", binary[j]);
    }
}
void intHandler(int dummy)
{
    dontStop = 0;
    i=0;
    hardwareMode();
        printf("\nSwitching back to Hardware Mode \n Goodbye...\n"); 
    exit(0);
}

void usage()
{                                       //USE THIS FOR PRINTING THINGS IF ERROR IN ASSIGNMENT OR NONE ARE GIVEN
    fprintf(stderr, "led [Option]...[Pattern] [Time]\n");
    fprintf(stderr, "    led can be used to change the leds on the FPGA.\n");
    fprintf(stderr, "    led will only write 32-bit values.\n\n");
    fprintf(stderr, "   Arguments:\n");
    fprintf(stderr, "   [Option]\n");
    fprintf(stderr, "     -h        --halp        print help text\n");
    fprintf(stderr, "     -v        --verbose     prints the pattern and display time as they happen\n");
    fprintf(stderr, "     -f        --file        operate the pattern from a file\n");
    fprintf(stderr, "     -p        --pattern     operate the leds by inputting a pattern and Time\n");
    fprintf(stderr, "   [Pattern] The hex value to display (0x55)\n");
    fprintf(stderr, "   [Time] The display time in milliseconds for that hex value (500)\n");
}
int main(int argc, char **argv)
{
  // ADDRESS = strtoul("0xFF200000", NULL, 0); //converting a string to unsigned long int setting ADDRESS to Register 2 which is led
  //this is the size of a page of memory in the system. Typically 4096 bytes.
  PAGE_SIZE = sysconf(_SC_PAGE_SIZE);
  

  if(argc==1)
  {
      //no arguments were given, so print the usage text and exit;
      //NOTE: The first arugment is actually the program name, so argv[0]
      //      is the program name, argv[1] is the first *real* argument, etc.
      usage();
      return 1;
  }
  
    // open the /dev/mem file, which is an image of the main system memory.
    fd=open("/dev/mem", O_RDWR | O_SYNC);
    if(fd==-1){     
        fprintf(stderr, "failed to open /dev/mem.\n");
        return 1;
    }

//----------arguement checking, using getopt
 while ((command = getopt (argc, argv, "hvf:p:")) != -1)
 {
    switch (command)
      {
      case 'h':
        halp = true;
        break;

      case 'v':
        verbose = true;
        break;

      case 'p':
        pattern = true;
        is_write = true;
        break;

      case 'f':             //EVALUATE THIS
        file_temp=optarg;
        file = true;
        is_write = true;
        break;

      }
 }
//------------------------------------end arguement checking

//------------------------------------begin arguement evaluating

  if ((file & pattern)== true)  //if -f and -p are given at the same time, throw an error and exit the program
  {
      fprintf(stderr, "--file and -patterns are mutually exclusive, please use one or the other. Not both.\n");
      return 1;
  }

  if (halp)                       //if the help argument is given, print the usage text
  {
      usage();
  }

  if (pattern)
  {
    softwareMode();
    
    address(2);         //addressing the led_register

    optind--;                   //optind is weird so move it back one to point to the thing we actually want
    for( ;optind < argc && *argv[optind] != '-'; optind++) //for loop using argc and optind to grab our values after p so I can do stuff with them
    {
      pvalue_temp=argv[optind];
      pvalue[i]= pvalue_temp; 
      i++;
      size++;     
    }
    if ((size%2)!=0){
      fprintf(stderr, "--you must enter both a pattern AND a time when using -p\n");
      return 1;
    }
    for(i=0; i<20; i++)            //loop to change pvalues from string to unsigned long ints
    { 
        if(pvalue[i])
        {   
          pvalue_uns[i]=strtoul(pvalue[i], NULL, 0);   //convert pvalue to an unsigned hex value ex: 
        }
    }
    signal(SIGINT, intHandler);
    while (dontStop)            //run until keyboard break
    { 
      for(i=0; i<20; i++)
      {
        if(pvalue_uns[i]!=0)
        {
          if(verbose)
          {
            printf("LED pattern= ");
            to_binary(pvalue_uns[i]);
            printf("  Display Time=%d msec\n", pvalue_uns[i+1]);
          }

          VALUE = pvalue_uns[i];        
          *target_virtual_addr = VALUE; //write value to the hardware memory address

          usleep(pvalue_uns[i+1]*1000); //pvalue_uns is in ms, but usleep takes in microseconds, so *1000
          i++;
        }
      }
    }
  }

  if(file)
  {
    softwareMode();
    address(2);   //access register 2
    char fileName[50];
    for(i=0; i<20; i++)
    {
      fileName[i]=file_temp[i];
    }
    // printf("file is: %s\n", fileName);
    FILE *fptr;
    // Open a file in read mode
    fptr = fopen(fileName, "r");
    char line[100];
    char patternArr[10];
    char time[10];
    char *token;
    int j=0;
    while(fgets(line, 100, fptr))
    { 

        token=strtok(line, " ");
        for(i=0; i<sizeof(patternArr); i++)
        {
          patternArr[i]=token[i];
        }
        token=strtok(NULL, " ");
        for(j=0; j<sizeof(time); j++)
        {
          time[j]=token[j];
        }

        VALUE = strtoul(patternArr, NULL, 0);        
        *target_virtual_addr = VALUE; //write value to the hardware memory address
        if(verbose)
        {
              printf("LED pattern= ");
              to_binary(VALUE);
              printf("  Display Time=%ld msec\n", strtoul(time, NULL, 0));
        }
        usleep(strtoul(time, NULL, 0)*1000); //time is in ms, but usleep takes in microseconds, so *1000


      // printf("pattern is: %s\n", patternArr);
      // printf("pattern sent is: 0x%X\n", VALUE);
      // printf("time is: %s\n", time);
      
    }
    hardwareMode();
  }
}