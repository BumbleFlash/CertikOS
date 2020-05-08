#include <lib/debug.h>
#include "import.h"


#define VM_USERLO 0x40000000
#define VM_USERHI 0xF0000000
#define PAGESIZE  4096
#define VM_USERLO_PI  (VM_USERLO / PAGESIZE)   // VM_USERLO page index
#define VM_USERHI_PI  (VM_USERHI / PAGESIZE)   // VM_USERHI page index
/** TASK 1:
  * Allocation of a physical page.
  *
  * 1. - First, implement a naive page allocator that scans the data-structure
  *      you implemented in MATIntro.
  *
  *    Hint 1: (Q: Do you have to scan the physical pages from index 0?
  *    Recall how you have initialized the table in pmem_init.)
  *
  *    - Then mark the page as allocated in the data-structure and return the
  *      page index of the page found.
  *      In the case when there is no available page found, return 0.
  * 2. Optimize the code with the memorization techniques so that you do not
  *    have to scan the data-structure from scratch every time.
  */
unsigned int
palloc()
{
  // TODO
    unsigned int nps = get_nps();
    int itr = 0;
    unsigned int latest_allocated_page = get_latest_allocated_page();
    //KERN_DEBUG("0x%08x\n", latest_allocated_page*PAGESIZE);
    for (itr = latest_allocated_page; itr < VM_USERHI_PI; itr++) {
        if (is_free(itr) == 1 && is_valid(itr) == 1) {
            set_free(itr, 0);
            set_latest_allocated_page(itr);
            return itr;
        } else if (itr == VM_USERHI_PI) {
            for (itr = VM_USERLO_PI; itr < latest_allocated_page; itr++) {
                if (is_free(itr) == 1 && is_valid(itr) == 1) {
                    set_free(itr, 0);
                    set_latest_allocated_page(itr);
                    return itr;
                }
            }
        }
    }
  return 0;
}



/** TASK 2:
  * Free of a physical page.
  *
  * This function marks the page with given index as unallocated in your
  * data-structure.
  *
  * Hint: Simple. Check if a page is allocated and to set the allocation status
  *       of a page index.
  */
void
pfree(unsigned int pfree_index)
{
    if (is_free(pfree_index) == 0) {
        set_free(pfree_index, 1);
    }

}
