#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
extern int set_process_deadline(int deadline);
extern int change_sched_level(int pid, int target_class);
extern int print_sched_info(void);
extern int update_wait_time(int osTicks);
extern int is_higher_waiting(void);
extern int set_deadline_for_process(int pid, int deadline);

int
sys_set_process_deadline(void)
{
  int deadline;
  if (argint(0, &deadline) < 0)
    return -1;
  return set_process_deadline(deadline);
}

int
sys_set_deadline_for_process(void)
{
  int pid, deadline;
  if (argint(0, &pid) < 0 || argint(1, &deadline) < 0)
    return -1;
  return set_deadline_for_process(pid, deadline);
}

int sys_change_sched_level(void) {
  int pid, target;
  if (argint(0, &pid) < 0 || argint(1, &target) < 0)
    return -1;
  return change_sched_level(pid, target);
}

int
sys_print_sched_info(void)
{
  return print_sched_info();
}

int
sys_update_wait_time(void){
  int osTicks;
  if (argint(0, &osTicks) < 0)
    return -1;
  return update_wait_time(osTicks);
}

int
sys_is_higher_waiting(void){
  return  is_higher_waiting();
}
