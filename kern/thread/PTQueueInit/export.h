#ifndef _KERN_THREAD_PTQueueINIT_H_
#define _KERN_THREAD_PTQueueINIT_H_

void tqueue_init(void);
void tqueue_enqueue(unsigned int chid, unsigned int pid);
unsigned int tqueue_dequeue(unsigned int chid);
void tqueue_remove(unsigned int chid, unsigned int pid);

#endif

