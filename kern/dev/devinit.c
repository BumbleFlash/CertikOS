#include <lib/x86.h>
#include <lib/types.h>
#include <lib/debug.h>
#include <lib/seg.h>

#include "console.h"
#include "mboot.h"
#include "intr.h"
#include "tsc.h"

void intr_init(void);

void
devinit (void)
{
	seg_init ();

	cons_init ();
	KERN_DEBUG("cons initialized.\n");

  	tsc_init();

	intr_init();

  	/* enable interrupts */
  	intr_enable (IRQ_TIMER);
  	intr_enable (IRQ_KBD);
  	intr_enable (IRQ_SERIAL13);

}
