#include "types.h"
#include "stat.h"
#include "user.h"

#define NPROC 10
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
fibonacci(int n){
    if (n <= 1) {
        return n;
    }
    return fibonacci(n - 1) + fibonacci(n - 2);
}

int
main(void)
{
  int pid;
  // n = 39;

  for(int i = 0; i < NPROC; i++){
    pid = fork();
    if(pid < 0){
      printf(1, "scheduletest: fork failed\n");
      exit();
    }
    if(pid == 0){
      // if(getpid() % 3 == 0 )
      //     set_process_deadline(30+i);
      printf(1, "scheduletest: starting process %d\n", pid);
      busywork(LOOP_ITER*3  ,getpid());
      print_sched_info(); // Custom syscall
      //printf(1, "fibonacci(%d) = %d\n", n, fibonacci(n));
      exit();
    }
    
    if(pid % 3 == 0 )
      set_deadline_for_process(pid , 30+i);

    if (pid%4 == 0 && pid % 3 != 0 )
      change_sched_level(pid, 1);

    print_sched_info();
  }

  for(int i = 0; i < NPROC; i++){
    printf(1, "scheduletest: ending process %d\n", wait());
    print_sched_info();
  }

  exit();
}
