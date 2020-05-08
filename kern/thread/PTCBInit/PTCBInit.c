#include <lib/x86.h>

#include "import.h"

/** TASK 1: 
  * * Initialize the TCB for all NUM_IDS threads with the
  *   state TSTATE_DEAD, and with two indices being NUM_IDS (which represents NULL).
  * 
  *  Hint 1:
  *  - Use function tcb_init_at_id, defined in PTCBIntro.c
  */
void tcb_init(void)
{
    int pid = 0;
    for(pid = 0; pid < NUM_IDS; pid++){
        tcb_init_at_id(pid);
    }
}
