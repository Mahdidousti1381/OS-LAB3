#include "types.h"
#include "stat.h"
#include "user.h"

#define LOOP 10000000
#define N 5 // number of RR processes to spawn

// Simulate computation to stay RUNNABLE
void busywork(int ticks, int n)
{
    volatile int x = 0;
    for (int k = 0; k < ticks; k++)
    {
        for (int i = 0; i < LOOP; i++)
        {
            x += i % 3;
        }
    }
    printf(1, "  busyjob %d finished. \n", n);
}

int main()
{
    int pid;

    for (int i = 0; i < N; i++)
    {
        pid = fork();
        if (pid == 0)
        {

            busywork(5,getpid());
            print_sched_info(); // Watch RR rotation, quantum, etc.
            exit();
        }
        change_sched_level(pid, 1); // Level 1 = RR
    }

    for (int i = 0; i < N; i++)
        wait();

    busywork(10 , 8008);
    print_sched_info();
    printf(1, "RR test complete\n");
    exit();
}
