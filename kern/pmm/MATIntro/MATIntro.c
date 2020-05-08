#include <lib/gcc.h>
#include <lib/queue.h>
#include <lib/types.h>


/** ASSIGNMENT OVERVIEW:
  * ASSIGNMENT INFO:
  * - In this section, you will design and implement data-structure
  *   that performs bookkeeping for each physical page. You are
  *   free to design the data-structure to keep track of as many or
  *   as few pieces of information that you believe are essential.
  */

/** The highest available physical physical page number
  * available in the machine.
  */
static unsigned int NUM_PAGES;
static unsigned int LATEST_ALLOCATED_PAGE;
/**
 * TODO: Data-Structure representing information for one physical page.
 */
struct MATPage {
    uintptr_t startAddress;    //start address of process
    unsigned int accessRights;    //access rights
    unsigned int isFree;       // is free or not
    unsigned int isValid;       // is it a valid page or is it invalidated
    unsigned int permission;    // permission
    unsigned int pid;           // process id

};
static struct MATPage MATPage_t[1048576]; //2^20


unsigned int
get_permission(int i) {
    return MATPage_t[i].permission;
}

void
set_permission(int i, int permission) {
    MATPage_t[i].permission = permission;
}

unsigned int
is_free(int i) {
    return MATPage_t[i].isFree;
}

void
set_free(int i, int isFree) {
    MATPage_t[i].isFree = isFree;
}

unsigned int
is_valid(int i) {
    return MATPage_t[i].isValid;
}

void
set_valid(int i, int isValid) {
    MATPage_t[i].isValid = isValid;
}
/** The getter function for NUM_PAGES. */
unsigned int
get_nps(void)
{
  return NUM_PAGES;
}

/** The setter function for NUM_PAGES. */
void
set_nps(unsigned int nps)
{
  NUM_PAGES = nps;
}

void
set_latest_allocated_page(unsigned int page) {
    LATEST_ALLOCATED_PAGE = page;
}

unsigned int
get_latest_allocated_page(void) {
    return LATEST_ALLOCATED_PAGE;
}