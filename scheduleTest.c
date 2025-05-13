#include "types.h"
#include "stat.h"
#include "user.h"

#define LOOP_ITER 100000000

// Simulate computation to stay RUNNABLE
void busywork(int ticks , int n) {
  volatile int x = 0;
  for (int i = 0; i < ticks; i++) {
    x += i % 3;
  }
  printf(1,"busyjob %d finished. \n" , n);
}

int
main(void)
{
  int pid;

  // Create one EDF process
  pid = fork();
  if (pid == 0) {
    //set_process_deadline(20); // Custom syscall: marks this as EDF
    change_sched_level(getpid(), 1); // Class 1
    for (int i = 0; i < 2; i++) {
      busywork(LOOP_ITER*3  , 1);
      print_sched_info(); // Custom syscall
    }
    exit();
  }
    print_sched_info();

  // Create one RR process
  printf(1,"second \n");
  pid = fork();
  if (pid == 0) {
    set_process_deadline(40);
    //change_sched_level(getpid(), 1); // Class 1
    // default sched_level = 1 (RR)
    for (int i = 0; i < 3; i++) {
      busywork(LOOP_ITER *3,2);
      print_sched_info();
    }
    exit();
  }
  printf(1,"third \n");

  // Create one FCFS process
  pid = fork();
  if (pid == 0) {
    //change_sched_level(getpid(), 2);
    // Manually downgrade to FCFS
   // change_sched_level(getpid(), ); // <- you need this syscall
    //set_process_deadline(40); // Custom syscall: marks this as EDF

    for (int i = 0; i < 2; i++) {
      busywork(LOOP_ITER ,3);
      print_sched_info();
    }
    printf(1, "Child %d exiting\n", getpid());
    exit();

  }
    print_sched_info();

  // Wait for all children
  wait(); wait(); wait();
        busywork(LOOP_ITER ,0);

        print_sched_info();

  exit();
}
