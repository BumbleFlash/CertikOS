#ifndef _KERN_MM_MALOP_H_
#define _KERN_MM_MALOP_H_

#ifdef _KERN_

/**
 * You can import functions (if any) from MATIntro here.
 */

/** The highest page number of available physical pages. */
unsigned int get_nps(void);
unsigned int is_free(unsigned int);
void set_free(int , int);
unsigned int is_valid(unsigned int);
unsigned int get_latest_allocated_page(void);
void set_latest_allocated_page(int);


#endif /* _KERN_ */

#endif /* !_KERN_MM_MALOP_H_ */
