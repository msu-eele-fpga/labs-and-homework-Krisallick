#include <linux/init.h>
#include <linux/module.h>


//------------------------------------------------------Modules
MODULE_AUTHOR("Kristoffer Allick\n");
MODULE_DESCRIPTION("Prints hello world on init and goodbye, cruel world on exit\n");
MODULE_VERSION("v0.0\n");
MODULE_LICENSE("GPL");
//------------------------------------------------------Init and cleanup funtions
static int __init initialize(void)
{
    printk("Hello World\n");
    return 1;
}
static void __exit cleanup(void)
{
    printk("Goodbyte, Cruel World\n");
}
//------------------------------------------------------"main"

module_init(initialize);
module_exit(cleanup);
