#include <lib/x86.h>
#include <lib/debug.h>
#include "import.h"

#define VM_USERLO 0x40000000
#define VM_USERHI 0xF0000000
#define DIR_MASK    0xffc00000
#define PAGE_MASK   0x003ff000
#define OFFSET_MASK 0x00000fff
#define DIR_SHIFT   22
#define PAGE_SHIFT  12

#define PAGESIZE    4096
#define PDIRSIZE    4194304
#define VM_USERLO_PDE    (VM_USERLO / PDIRSIZE)
#define VM_USERHI_PDE    (VM_USERHI / PDIRSIZE)


/** TASK 1:
  * * Set the entire page map for process 0 as identity map.
  *
  * Hint 1: Note that part of the task is already completed by idptbl_init().
  * Hint 2: Here just set the remaining portion of process 0's page directory entry as identity map.
  *
  * * For each process from id 0 to NUM_IDS -1,
  *   set the page directory entries so that the kernel portion of the map as identity map,
  *   and the rest of page directories are unmmaped.
  *
  * Hint 3: Recall which portions are reserved for the kernel and calculate the pde_index.
  * Hint 4: Recall which function in MPTIntro layer is used to set identity map. (See import.h)
  * Hint 5: Remove the page directory entry to unmap it.
  */
void pdir_init_kern(void)
{
    idptbl_init();
    //TODO
    unsigned int process, pde;

    for (process = 0; process < 64; process++) {
        for (pde = 0; pde < 1024; pde++) {
            if (process == 0) {
                set_pdir_entry_identity(process, pde);

            } else if (pde < VM_USERLO_PDE || pde >= VM_USERHI_PDE) {
                set_pdir_entry_identity(process, pde);
            } else {
                rmv_pdir_entry(process, pde);
            }

        }
    }
}

/** TASK 2:
  * * Map the physical page # [page_index] for the given virtual address with the given permission.
  *   - In the case, when the page table for the page directory entry is not set up, you need to allocate the page table first.
  *   - In the case of error, return the constant MagicNumber defined in lib/x86.h,
  *     otherwise, return the physical page index registered in the page directory,
  *     e.g., the return value of get_pdir_entry_by_va or alloc_ptbl.
  * Hint 1: Get the pde for vadr
  * Hint 2: If pde is already set, find the pde index. (pde / PAGESIZE)
  *         Otherwise, first allocate the page table (MPTComm layer)
  *         - If there is an error during allocation, return MagicNumber.
  * Hint 3: If you have a valid pde, set the page table entry to new physical page (page_index) and perm.
  * Hint 4: Return the pde index or MagicNumber.
  */
unsigned int map_page(unsigned int proc_index, unsigned int vadr, unsigned int page_index, unsigned int perm) {
  // TODO
    unsigned int vaddr_dir = vadr >> DIR_SHIFT;
    unsigned int pdir = vaddr_dir & (DIR_MASK >> DIR_SHIFT);
    unsigned int pde = get_pdir_entry_by_va(proc_index, vadr);
    unsigned int pde_index;
    if (pde != 0) {
        pde_index = pde / PAGESIZE;
        set_ptbl_entry_by_va(proc_index, vadr, page_index, perm);
        return pde_index;
    } else {
        int result = alloc_ptbl(proc_index, vadr);
        if (result == 0)
            return MagicNumber;
        set_ptbl_entry_by_va(proc_index, vadr, page_index, perm);
        return result;
    }
}

/** TASK 3:
  * * Remove the mapping for the given virtual address (with rmv_ptbl_entry_by_va).
  * Hint 1: You need to first make sure that the mapping is still valid,
  *         by reading the page table entry (pte) for the virtual address.
  *         - Nothing should be done if the mapping no longer exists.
  * Hint 2: If pte is valid, remove page table entry for vadr.
  * Hint 3: Return the corresponding page table entry.
  */
unsigned int unmap_page(unsigned int proc_index, unsigned int vadr)
{
  // TODO

    unsigned int vaddr_dir = vadr >> DIR_SHIFT;
    unsigned int vaddr_table = vadr >> PAGE_SHIFT;
    unsigned int pdir = vaddr_dir & (DIR_MASK >> DIR_SHIFT);
    unsigned int ptbl = vaddr_table & (PAGE_MASK >> PAGE_SHIFT);
    unsigned int pte = get_ptbl_entry_by_va(proc_index, vadr);
    if (pte != 0) {
        rmv_ptbl_entry_by_va(proc_index, vadr);
        return pte;
    } else {
        return 0;
    }

}
