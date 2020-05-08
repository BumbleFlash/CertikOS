#ifndef _KERN_MM_MALINIT_H_
#define _KERN_MM_MALINIT_H_

#ifdef _KERN_

/**
 * Premitives that are already implemented in this lab.
 */
void set_nps(unsigned int); // Sets the number of available pages.
void set_permission(int, int);
void set_valid(int , int);
void set_free(int , int);
void set_latest_allocated_page(int);
#endif /* _KERN_ */

#endif /* !_KERN_MM_MALINIT_H_ */
