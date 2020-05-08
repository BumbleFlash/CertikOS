#include <lib/debug.h>
#include <lib/types.h>
#include <lib/monitor.h>
#include <dev/devinit.h>
#include <dev/mboot.h>
#include <vmm/MPTKern/export.h>
#include <pmm/MContainer/export.h>
#include <pmm/MATInit/export.h>
#include <vmm/MPTIntro/export.h>
#include <thread/PThread/export.h>

#ifdef TEST
extern bool test_PKCtxNew(void);
extern bool test_PTCBInit(void);
extern bool test_PTQueueInit(void);
extern bool test_PThread(void);
#endif

static void
kern_main (void)
{
    KERN_DEBUG("In kernel main.\n\n");

    #ifdef TEST
    dprintf("Testing PKCtxNew ...\n");
    if(test_PKCtxNew() == 0)
      dprintf("All tests passed.\n");
    else
      dprintf("Test failed.\n");
    dprintf("\n");

    dprintf("Testing PTCBInit ...\n");
    if(test_PTCBInit() == 0)
      dprintf("All tests passed.\n");
    else
      dprintf("Test failed.\n");
    dprintf("\n");

    dprintf("Testing PTQueueInit ...\n");
    if(test_PTQueueInit() == 0)
      dprintf("All tests passed.\n");
    else
      dprintf("Test failed.\n");
    dprintf("\n");

    dprintf("Testing PThread ...\n");
    if(test_PThread() == 0)
      dprintf("All tests passed.\n");
    else
      dprintf("Test failed.\n");
    dprintf("\n");
    dprintf("\nTest complete. Please Use Ctrl-a x to exit qemu.");
    #else
    monitor(NULL);
    #endif
}

void
kern_init (uintptr_t mbi_addr)
{
    pmmap_list_type pmmap_list;

    devinit();

    pmmap_init (mbi_addr, &pmmap_list);

    pmem_init(&pmmap_list);

    container_init();

    pdir_init_kern();
    set_pdir_base(0);
    enable_paging();

    thread_init();

    KERN_DEBUG("Kernel initialized.\n");

    kern_main ();
}
