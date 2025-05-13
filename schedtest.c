#include "types.h"
#include "stat.h"
#include "user.h"

#define NPROC 10
#define LOOP_ITER 100000000
int fibonacci(int n)
{
    if (n <= 1)
    {
        return n;
    }
    return fibonacci(n - 1) + fibonacci(n - 2);
}
// Simulate computation to stay RUNNABLE
void busywork(int ticks, int n)
{
    volatile int x = 0;
    for (int k = 0; k < ticks; k++)
    {
        for (int i = 0; i < LOOP_ITER; i++)
        {
            x++;
            x--;
        }
    }
    printf(1,"fib: %d - " ,fibonacci(30));
    printf(1, "  busyjob %d finished. \n", n);
}



int main(void)
{
    int pid;

    for (int i = 0; i < NPROC; i++)
    {
        pid = fork();
        if (pid < 0)
        {
            printf(1, "scheduletest: fork failed\n");
            exit();
        }
        if (pid == 0)
        {
            printf(1, "scheduletest: starting process %d\n", getpid());
            busywork(5, getpid());
            print_sched_info(); // Custom syscall
            exit();
        }

        if (pid % 3 == 0)
            set_deadline_for_process(pid, 400 + i*10 );

        if (pid % 4 == 0 && pid % 3 != 0)
            change_sched_level(pid, 1);

        print_sched_info();
    }
    for (int j = 0; j < 50; j++)
        busywork(1, 8008);

    for (int i = 0; i < NPROC; i++)
    {
        printf(1, "scheduletest: ending process %d\n", wait());
        print_sched_info();
    }

    exit();
}
