#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

int count_edf = 0;
int count_rr = 0;
int count_fcfs = 0;
//static int rr_index = 0;

struct
{
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int cpuid()
{
  return mycpu() - cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu *
mycpu(void)
{
  int apicid, i;

  if (readeflags() & FL_IF)
    panic("mycpu called with interrupts enabled\n");

  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i)
  {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc *
myproc(void)
{
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

// PAGEBREAK: 32
//  Look in the process table for an UNUSED proc.
//  If found, change state to EMBRYO and initialize
//  state required to run in the kernel.
//  Otherwise return 0.
static struct proc *
allocproc(void)
{

  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if (p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  // Default scheduler fields
  p->sched_class = 2; // Normal class by default
  p->sched_level = 2; // FCFS (non-interactive) default
  p->deadline = 1e9;  // Very large deadline (not used)
  p->arrival_time = 0;
  p->waited_ticks = 0;
  p->consecutive_run = 0;
  p->max_consecutive_run = 0;
  p->rr_ticks = 0;
  p->runnig_time = 0;

  release(&ptable.lock);

  // Allocate kernel stack.
  if ((p->kstack = kalloc()) == 0)
  {
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe *)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint *)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context *)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}

// PAGEBREAK: 32
//  Set up first user process.
void userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();

  p->sched_class = 2; // Normal class
  p->sched_level = 1; // Interactive (RR)

  initproc = p;
  if ((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0; // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;
  acquire(&tickslock);
  p->arrival_time = ticks;
  p->waited_ticks = 0;
  release(&tickslock);
  if (p->sched_class == 1)
    count_edf++;
  else if (p->sched_class == 2 && p->sched_level == 1)
    count_rr++;
  else if (p->sched_class == 2 && p->sched_level == 2)
    count_fcfs++;

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if (n > 0)
  {
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  else if (n < 0)
  {
    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int fork(void)
{

  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if ((np = allocproc()) == 0)
  {
    return -1;
  }

  // Copy process state from proc.
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
  {
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for (i = 0; i < NOFILE; i++)
    if (curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;
  acquire(&tickslock);
  np->arrival_time = ticks;
  np->waited_ticks = 0;
  np->last_run = ticks;
  release(&tickslock);


  if (np->sched_class == 1)
    count_edf++;
  else if (np->sched_class == 2 && np->sched_level == 1)
    count_rr++;
  else if (np->sched_class == 2 && np->sched_level == 2)
    count_fcfs++;

  release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if (curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for (fd = 0; fd < NOFILE; fd++)
  {
    if (curproc->ofile[fd])
    {
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->parent == curproc)
    {
      p->parent = initproc;
      if (p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // print_sched_info();

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();

  acquire(&ptable.lock);
  for (;;)
  {
    // Scan through table looking for exited children.
    havekids = 0;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    {
      if (p->parent != curproc)
        continue;
      havekids = 1;
      if (p->state == ZOMBIE)
      {
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if (!havekids || curproc->killed)
    {
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock); // DOC: wait-sleep
  }
}

// PAGEBREAK: 42
//  Per-CPU process scheduler.
//  Each CPU calls scheduler() after setting itself up.
//  Scheduler never returns.  It loops, doing:
//   - choose a process to run
//   - swtch to start running that process
//   - eventually that process transfers control
//       via swtch back to the scheduler.

void scheduler(void)
{
  struct proc *p , *nextrrp = ptable.proc, *chosen ;

  struct cpu *c = mycpu();
  c->proc = 0;

  for (;;)
  {
    // Enable interrupts on this processor.
    sti();
    chosen = 0;
    acquire(&ptable.lock);
    // ---------- Class 1: EDF ----------
    if (count_edf > 0)
    {
      for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
      {
        if (p->state == RUNNABLE && p->sched_class == 1)
        {
          if (chosen == 0 || p->deadline < chosen->deadline)
            chosen = p;
        }
      }
    }
    else if (count_rr > 0)
    {
      // ---------- Class 2, Level 1: RR ----------
      if (chosen == 0)
      {
        // for (int i = 0; i < NPROC; i++)
        // {
        //   int idx = (rr_index + i) % NPROC;
        //   struct proc *q = &ptable.proc[idx];
        //   if (q->state == RUNNABLE && q->sched_class == 2 && q->sched_level == 1)
        //   {
        //     chosen = q;
        //     rr_index = (idx + 1) % NPROC;
        //      //cprintf("RR found pid: %d , indx = %d \n",chosen->pid , rr_index);
        //     break;
        //   }
        // }

      // Loop over process table looking for process to run.
      p = nextrrp;
      do
      {
        if (p->state != RUNNABLE || p->sched_level != 1)
        {
          if (++p == &ptable.proc[NPROC])
            p = ptable.proc;
          continue;
        }

        chosen = p;

        if (++p == &ptable.proc[NPROC])
          p = ptable.proc;
        nextrrp = p;
        break;
      } while (p != nextrrp);

      }
    }
    else if (count_fcfs > 0)
    {
      // ---------- Class 2, Level 2: FCFS ----------
      if (chosen == 0)
      {
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
        {
          if (p->state == RUNNABLE && p->sched_class == 2 && p->sched_level == 2)
          {
            p->waited_ticks++;
            if (chosen == 0 || p->arrival_time < chosen->arrival_time)
              chosen = p;
          }
        }
      }
    }
    // ---------- Run Chosen Process ----------
    if (chosen)
    {
      c->proc = chosen;
      switchuvm(chosen);
      chosen->state = RUNNING;

      // Decrement count before switching
      if (chosen->sched_class == 1)
        count_edf--;
      else if (chosen->sched_class == 2 && chosen->sched_level == 1)
        count_rr--;
      else if (chosen->sched_class == 2 && chosen->sched_level == 2)
        count_fcfs--;
      chosen->consecutive_run = 0; // reset before a fresh run
      chosen->rr_ticks = 0;
      chosen->waited_ticks = 0;
      acquire(&tickslock);
      chosen->last_run = ticks;
      release(&tickslock);
      //cprintf("last run of pid %d is %d :", chosen->pid, temptick);
      // acquire(&tickslock);
      // p->arrival_time = ticks;
      // release(&tickslock);

      swtch(&(c->scheduler), chosen->context);
      switchkvm();

      // cprintf("%s , %d :", chosen->name, chosen->pid);
      // cprintf("cnt edf: %d ", count_edf);
      // cprintf(",cnt rr: %d ", count_rr);
      // cprintf(",cnt fcfs: %d \n", count_fcfs);

      c->proc = 0;
    }

    release(&ptable.lock);
  }
  
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void sched(void)
{
  int intena;
  struct proc *p = myproc();

  if (!holding(&ptable.lock))
    panic("sched ptable.lock");
  if (mycpu()->ncli != 1)
    panic("sched locks");
  if (p->state == RUNNING)
    panic("sched running");
  if (readeflags() & FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void yield(void)
{
  acquire(&ptable.lock); // DOC: yieldlock
  myproc()->state = RUNNABLE;

  acquire(&tickslock);
  myproc()->arrival_time = ticks;
  myproc()->waited_ticks = 0;
  myproc()->consecutive_run = 0;
  release(&tickslock);

  // Then update the counter
  if (myproc()->sched_class == 1)
  {
    count_edf++;
    //cprintf("edf++ yield\n");
  }
  else if (myproc()->sched_class == 2 && myproc()->sched_level == 1)
    count_rr++;
  else if (myproc()->sched_class == 2 && myproc()->sched_level == 2)
    count_fcfs++;

  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first)
  {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();

  if (p == 0)
    panic("sleep");

  if (lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if (lk != &ptable.lock)
  {                        // DOC: sleeplock0
    acquire(&ptable.lock); // DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;

  if (p->state == RUNNABLE)
  {
    if (p->sched_class == 1)
      count_edf--;
    else if (p->sched_class == 2 && p->sched_level == 1)
      count_rr--;
    else if (p->sched_class == 2 && p->sched_level == 2)
      count_fcfs--;
  }
  p->consecutive_run = 0;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if (lk != &ptable.lock)
  { // DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

// PAGEBREAK!
//  Wake up all processes sleeping on chan.
//  The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->state == SLEEPING && p->chan == chan)
    {
      p->state = RUNNABLE;
      acquire(&tickslock);
      p->arrival_time = ticks;
      p->waited_ticks = 0;
      release(&tickslock);
      if (p->sched_class == 1)
      {
        count_edf++;
        // cprintf("edf++ wakeup1\n");
      }
      else if (p->sched_class == 2 && p->sched_level == 1)
        count_rr++;
      else if (p->sched_class == 2 && p->sched_level == 2)
        count_fcfs++;
    }
  }
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->pid == pid)
    {
      p->killed = 1;
      // Wake process from sleep if necessary.
      if (p->state == SLEEPING)
      {
        p->state = RUNNABLE;

        acquire(&tickslock);
        p->arrival_time = ticks;
        p->waited_ticks = 0;
        release(&tickslock);

        if (p->sched_class == 1)
        {
          count_edf++;
          // cprintf("edf++ kill\n");
        }
        else if (p->sched_class == 2 && p->sched_level == 1)
          count_rr++;
        else if (p->sched_class == 2 && p->sched_level == 2)
          count_fcfs++;
      }
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

// PAGEBREAK: 36
//  Print a process listing to console.  For debugging.
//  Runs when user types ^P on console.
//  No lock to avoid wedging a stuck machine further.
void procdump(void)
{
  static char *states[] = {
      [UNUSED] "unused",
      [EMBRYO] "embryo",
      [SLEEPING] "sleep ",
      [RUNNABLE] "runble",
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"};
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if (p->state == SLEEPING)
    {
      getcallerpcs((uint *)p->context->ebp + 2, pc);
      for (i = 0; i < 10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
//////////////////////////////////my process


int set_deadline_for_process(int pid, int deadline)
{
  if (deadline < 0)
  {
    cprintf("Invalid deadline!");
    return -1;
  }

  acquire(&ptable.lock);
  struct proc *p;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->pid == pid)
    {
      if (p->state == RUNNABLE)
      {
        if (p->sched_level == 1)
        {
          count_rr--;
          count_edf++;
        }
        else if (p->sched_level == 2)
        {
          count_fcfs--;
          count_edf++;
        }
      }
      p->sched_level = 0;
      p->sched_class = 1;
      p->deadline = deadline;
      cprintf("PID %d : Deadline = %d \n", pid, p->deadline);

      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

int change_sched_level(int pid, int target_level)
{
  if (target_level != 1 && target_level != 2)
  {
    cprintf("Invalid target level!");
    return -1;
  }

  acquire(&ptable.lock);
  struct proc *p;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->pid == pid)
    {
      if (p->sched_level == target_level)
      {
        cprintf("Process is already in target level!");
        return -1;
      }
      if (p->state == RUNNABLE)
      {
        if (p->sched_level == 1)
        {
          count_rr--;
          count_fcfs++;
        }
        else
        {
          count_fcfs--;
          count_rr++;
        }
      }
      cprintf("PID %d : Level %d to %d\n", pid, p->sched_level, target_level);
      p->sched_level = (target_level == 2) ? 2 : 1;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

int update_wait_time(int osTicks)
{
  acquire(&ptable.lock);
  struct proc *p;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->state == RUNNABLE)
    {
      p->waited_ticks = osTicks - p->arrival_time;
      if (p->sched_class == 2 && p->sched_level == 2)
      {
        if (p->waited_ticks >= AGING_THRESHOLD)
        {
          release(&ptable.lock);
          change_sched_level(p->pid, 1);
          acquire(&ptable.lock);
          p->arrival_time = osTicks;
        }
      }
    }
  }
  release(&ptable.lock);
  return 0;
}

int is_higher_waiting(void)
{
  if (count_edf > 0 || count_rr > 0)
  {
    yield();
    return 1;
  }
  return 0;
}

int print_sched_info(void)
{
  static char *states[] = {
      [UNUSED] "UNUSED",
      [EMBRYO] "EMBRYO",
      [SLEEPING] "SLEEPING",
      [RUNNABLE] "RUNNABLE",
      [RUNNING] "RUNNING",
      [ZOMBIE] "ZOMBIE"};
  acquire(&tickslock);
  cprintf("-----------------------\n"
          "Tick: %d \n" , ticks);
  release(&tickslock);
  static int columns[] = {16, 8, 12, 12, 12, 12, 12, 17, 9, 10, 13};
  cprintf("-------------------------------------------------------------------------------------------------------------------------------------\n"
          "Process_Name    PID     State       Class       Algorithm   Wait_time   Deadline    Consecutive_run  Arrival  RR_time   Running_Time \n");

  struct proc *p;
  acquire(&ptable.lock);

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->state == UNUSED)
      continue;

    const char *state;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";

    char *algorithm = "FCFS";
    if (p->sched_class == 1)
      algorithm = "EDF";
    else if (p->sched_level == 1)
      algorithm = "RR";

    char *class = "Normal";
    if (p->sched_class == 1)
      class = "Real-Time";

    // Print Name
    cprintf("%s", p->name);
    printspaces(columns[0] - strlen(p->name));
    // Print PID
    cprintf("%d", p->pid);
    printspaces(columns[1] - digitcount(p->pid));
    // Print State
    cprintf("%s", state);
    printspaces(columns[2] - strlen(state));
    // Print Class
    cprintf("%s", class);
    printspaces(columns[3] - strlen(class));
    // Print Algorithm
    cprintf("%s", algorithm);
    printspaces(columns[4] - strlen(algorithm));
    // Print Wait time
    cprintf("%d", p->waited_ticks);
    printspaces(columns[5] - digitcount(p->waited_ticks));
    // Print Deadline
    cprintf("%d", p->deadline);
    printspaces(columns[6] - digitcount(p->deadline));
    // Print Consecutive run
    cprintf("%d", p->max_consecutive_run);
    printspaces(columns[7] - digitcount(p->max_consecutive_run));
    // Print Arrival
    cprintf("%d", p->arrival_time);
    printspaces(columns[8] - digitcount(p->arrival_time));
    // Print spent time in RR
    cprintf("%d", p->rr_ticks);
    printspaces(columns[9] - digitcount(p->rr_ticks));
    // Print whole running time
    cprintf("%d", p->runnig_time);
    printspaces(columns[10] - digitcount(p->runnig_time));

    cprintf("\n");
  }
  release(&ptable.lock);
  return 0;
}

