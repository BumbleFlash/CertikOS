#include <lib/debug.h>
#include <dev/mboot.h>
#include <lib/queue.h>
#include <lib/types.h>
#include "import.h"

#define PAGESIZE  4096
#define VM_USERLO 0x40000000
#define VM_USERHI 0xF0000000
#define VM_USERLO_PI  (VM_USERLO / PAGESIZE)   // VM_USERLO page index
#define VM_USERHI_PI  (VM_USERHI / PAGESIZE)   // VM_USERHI page index
#define MEM_RAM            1
#define MEM_RESERVED        2

void
pmem_init(pmmap_list_type *pmmap_list_p)
{
  /**
    * This variable should contain the highest available physical page number.
    * You need to calculate this value from the information in the pmmap list,
    * and save it to the nps variable before calling set_nps() function.
    */
    enum __pmmap_type {
        PMMAP_USABLE, PMMAP_RESV, PMMAP_ACPI, PMMAP_NVS
    };

    unsigned int nps;
    struct pmmap *pmmap_t, *pmmap_t1, *pmmap_t2;
    int itr = 0, length = 0;
    uint32_t startHighest = 0, endHighest = 0, highestPage;
    SLIST_FOREACH(pmmap_t, pmmap_list_p, next)
    {
        if (startHighest < pmmap_t->start)
            startHighest = pmmap_t->start;
        if (endHighest < pmmap_t->end)
            endHighest = pmmap_t->end;
        length++;
        itr++;
    }
    nps = endHighest / PAGESIZE;
    set_nps(nps);
    for (itr = 0; itr < nps; itr++) {
        if (itr <= VM_USERLO_PI || itr >= VM_USERHI_PI) {
            set_permission(itr, PMMAP_RESV);
            set_free(itr, 0);
            set_valid(itr, 1);
        } else {
            set_permission(itr, PMMAP_USABLE);
            set_free(itr, 1);
            set_valid(itr, 1);
        }
    }
    // making regions which are marked usuable in the pmmap but doesn't meet the conditions to be reserved
    SLIST_FOREACH(pmmap_t1, pmmap_list_p, next)
    {
        KERN_DEBUG("BIOS-e820: 0x%08x - 0x%08x (%s)\n",
                   pmmap_t1->start,
                   (pmmap_t1->start == pmmap_t1->end) ? pmmap_t1->end :
                   (pmmap_t1->end == 0xffffffff) ? pmmap_t1->end : pmmap_t1->end - 1,
                   (pmmap_t1->type == MEM_RAM) ? "usable" :
                   (pmmap_t1->type == MEM_RESERVED) ? "reserved" :
                   (pmmap_t1->type == MEM_ACPI) ? "ACPI data" :
                   (pmmap_t1->type == MEM_NVS) ? "ACPI NVS" :
                   "unknown");
        if (pmmap_t1->type == MEM_RAM) {
            if (pmmap_t1->end >= VM_USERLO) {
//                KERN_DEBUG("ENDD: %d\n", VM_USERLO/PAGESIZE);
                unsigned int nps_reserved = VM_USERLO / PAGESIZE;
                int i = 0;
                for (i = (pmmap_t1->start) / PAGESIZE; i <= nps_reserved; i++) {
                    set_permission(i, PMMAP_RESV);
                    set_free(i, 0);
                    set_valid(i, 1);
                }
                set_latest_allocated_page(nps_reserved);
            }
            if (pmmap_t1->start >= VM_USERHI) {
//                KERN_DEBUG("Start: %d\n", pmmap_t1->start/PAGESIZE);

            }
        } else {
            int i = 0;
            for (i = (pmmap_t1->start) / PAGESIZE; i <= (pmmap_t1->end) / PAGESIZE; i++) {
                set_permission(i, PMMAP_RESV);
                set_free(i, 0);
                set_valid(i, 1);
            }
        }


    }
    //making gaps unusable
    int i = 0, prev, next;
    unsigned int j = 0;
    SLIST_FOREACH(pmmap_t2, pmmap_list_p, next)
    {
        if (i == 0) {
            prev = pmmap_t2->end - 1;

        } else if (i == length) {
            break;
        } else {
            next = pmmap_t2->start;

            if (next - prev > 1) {

                for (j = ((prev) / PAGESIZE); j < (pmmap_t2->start / PAGESIZE); j++) {

                    set_permission(j, PMMAP_RESV);
                    set_free(j, 0);
                    set_valid(j, 1);
                }
            }
            prev = pmmap_t2->end - 1;

        }

        i++;


    }



    /* you need to make this call at some point */

}


