OS(CIA-1)
3.CPU SCHEDULING:

1.FCFS:
#include<stdio.h>   // Including standard input-output header file
#include<stdlib.h>  // Including standard library header file (not used in this program)

// Defining a structure to represent each process
struct node {
    int arr;   // Arrival time of the process
    int ct;    // Completion time of the process
    int bur;   // Burst time (execution time) of the process
};

int main() {
    struct node obj[100];  // Array to store up to 100 processes
    int n, i, j;           // Declaring variables for loop control and number of processes

    // Asking the user to input the number of processes
    printf("Enter the number of processes\n");
    scanf("%d", &n);  // Storing the number of processes in variable 'n'

    // Loop to input the arrival time and burst time for each process
    for(i = 0; i < n; i++) {
        printf("Enter the arrival time of process %d\n", i+1);
        scanf("%d", &obj[i].arr);  // Input arrival time for the process

        printf("Enter the burst time of process %d\n", i+1);
        scanf("%d", &obj[i].bur);  // Input burst time for the process

        obj[i].ct = 0;  // Initializing the completion time to 0
    }

    // Sorting processes based on their arrival time using bubble sort
    struct node temp;  // Temporary variable for swapping processes
    for(i = 0; i < n-1; i++) {
        for(j = i + 1; j < n; j++) {
            if(obj[i].arr > obj[j].arr) {  // If the current process arrives later than the next process
                temp = obj[j];  // Swap the processes
                obj[j] = obj[i];
                obj[i] = temp;
            }
        }
    }

    // Declaring arrays to store waiting time and turnaround time for each process
    int wt[n];   // Array for waiting time
    int tat[n];  // Array for turnaround time

    // Calculating the completion time, turnaround time, and waiting time for the first process
    obj[0].ct = obj[0].arr + obj[0].bur;  // Completion time for the first process
    tat[0] = obj[0].ct - obj[0].arr;      // Turnaround time = Completion time - Arrival time
    wt[0] = tat[0] - obj[0].bur;          // Waiting time = Turnaround time - Burst time

    // Loop to calculate the same for all remaining processes
    for(i = 1; i < n; i++) {
        obj[i].ct = obj[i-1].ct + obj[i].bur;  // Completion time = Previous process's completion time + current burst time
        tat[i] = obj[i].ct - obj[i].arr;       // Turnaround time = Completion time - Arrival time
        wt[i] = tat[i] - obj[i].bur;           // Waiting time = Turnaround time - Burst time
    }

    // Printing the results in a tabular format
    printf("AT\tBT\tCT\tWT\tTAT\n");  // Header for the table
    for(i = 0; i < n; i++) {
        printf("%d\t%d\t%d\t%d\t%d\n", obj[i].arr, obj[i].bur, obj[i].ct, wt[i], tat[i]);
        // Print Arrival Time, Burst Time, Completion Time, Waiting Time, and Turnaround Time for each process
    }

    return 0;  // End of the program, returning 0 indicates successful execution
}


2.Round Robin:
#include<stdio.h>   // Including standard input-output header file

// Defining a structure to represent each process
struct process {
    int at;  // Arrival time of the process
    int bt;  // Burst time (execution time) of the process
    int rt;  // Remaining time of the process
    int ft;  // Finish time (completion time) of the process
    int wt;  // Waiting time of the process
    int tat; // Turnaround time of the process
    int status; // Status to indicate if the process is completed
} p[10];     // Array of processes, assuming a maximum of 10 processes

int n, time_quantum;  // Variables to store the number of processes and the time quantum

// Function prototype for the dispatcher function
void dispatcher();

int main() {
    int i, ctime = 0;  // Current time initialization to 0

    // Prompting the user to input the total number of processes
    printf("Enter Total Processes:\t");
    scanf("%d", &n);  // Storing the number of processes in variable 'n'

    // Loop to input the arrival time and burst time for each process
    for(i = 0; i < n; i++) {
        printf("Enter Arrival Time and Burst Time for Process Number %d: ", i+1);
        scanf("%d", &p[i].at);  // Input arrival time for the process
        scanf("%d", &p[i].bt);  // Input burst time for the process
        p[i].rt = p[i].bt;      // Initialize remaining time with burst time
        p[i].status = 0;        // Initialize status as not completed
    }

    // Prompting the user to input the time quantum
    printf("Enter Time Quantum:\t");
    scanf("%d", &time_quantum);  // Storing the time quantum in variable 'time_quantum'

    dispatcher();  // Calling the dispatcher function to simulate Round Robin scheduling

    // Printing the results in a tabular format
    printf("\n\nProcess\t|Finish Time\t|Turnaround Time|Waiting Time\n\n");
    for(i = 0; i < n; i++) {
        // Print Process ID, Finish Time, Turnaround Time, and Waiting Time
        printf("P[%d]\t|\t%d\t|\t%d\t|\t%d\n", i+1, p[i].ft, p[i].tat, p[i].wt);
    }

    return 0;  // End of the program, returning 0 indicates successful execution
}

// Function to simulate the Round Robin scheduling algorithm
void dispatcher() {
    int CT = 0, pid = 0, count = 0;  // CT - Clock time, pid - process ID, count - number of completed processes

    // Loop until all processes are completed
    while(count < n) {
        // Check if the current process is ready to execute
        if(p[pid].rt > 0 && p[pid].at <= CT) {
            // If the current process can complete within the time quantum
            if(p[pid].rt <= time_quantum) {
                CT += p[pid].rt;  // Increase clock time by the remaining time of the process
                p[pid].rt = 0;    // Set the remaining time to 0 (process completed)
                p[pid].ft = CT;   // Set the finish time for the process
                p[pid].tat = p[pid].ft - p[pid].at;  // Calculate turnaround time
                p[pid].wt = p[pid].tat - p[pid].bt;  // Calculate waiting time
                p[pid].status = 1; // Mark process as completed
                count++;           // Increment the count of completed processes
            } else {
                p[pid].rt -= time_quantum;  // Reduce remaining time by the time quantum
                CT += time_quantum;         // Increase clock time by the time quantum
            }
        }

        // Move to the next process in a round-robin manner
        pid = (pid + 1) % n;  // Circular increment of process ID
    }
}


3.SJF:
#include<stdio.h>   // Including standard input-output header file
#include<stdlib.h>  // Including standard library header file (not used in this program)

// Defining a structure to represent each process
struct node {
    int arr;  // Arrival time of the process
    int ct;   // Completion time of the process
    int bur;  // Burst time (execution time) of the process
};

int main() {
    struct node obj[100];  // Array to store up to 100 processes
    int n, i, j, k, m;     // Declaring variables for loop control and number of processes

    // Asking the user to input the number of processes
    printf("Enter the number of processes\n");
    scanf("%d", &n);  // Storing the number of processes in variable 'n'

    // Loop to input the arrival time and burst time for each process
    for(i = 0; i < n; i++) {
        printf("Enter the arrival time of process %d\n", i+1);
        scanf("%d", &obj[i].arr);  // Input arrival time for the process

        printf("Enter the burst time of process %d\n", i+1);
        scanf("%d", &obj[i].bur);  // Input burst time for the process

        obj[i].ct = 0;  // Initializing the completion time to 0
    }

    // Sorting processes based on their arrival time using bubble sort
    struct node temp;  // Temporary variable for swapping processes
    for(i = 0; i < n-1; i++) {
        for(j = i+1; j < n; j++) {
            if(obj[i].arr > obj[j].arr) {  // If the current process arrives later than the next process
                temp = obj[j];  // Swap the processes
                obj[j] = obj[i];
                obj[i] = temp;
            }
        }
    }

    // Implementing SJF (Shortest Job First) Non-Preemptive Scheduling
    struct node n1;  // Temporary variable for swapping based on burst time
    int wt[n];       // Array for waiting time
    int tat[n];      // Array for turnaround time

    // Calculate the completion time, turnaround time, and waiting time for the first process
    obj[0].ct = obj[0].arr + obj[0].bur;  // Completion time for the first process
    tat[0] = obj[0].ct - obj[0].arr;      // Turnaround time = Completion time - Arrival time
    wt[0] = tat[0] - obj[0].bur;          // Waiting time = Turnaround time - Burst time

    int time = obj[0].ct;  // Initialize the current time to the completion time of the first process

    // Loop to calculate the same for all remaining processes
    for(i = 0; i < n-1; i++) {
        int count = 0;
        int sum = 0;

        // Calculate the sum of arrival times of the subsequent processes until one is ready
        for(j = i+1; j < n; j++) {
            sum += obj[j].arr;
            count++;
            if(sum >= time) {  // If the next process arrives after the current time, break
                break;
            }
        }

        // Sort the processes that have arrived based on burst time (Shortest Job First)
        for(k = i+1; k <= i+count; k++) {
            for(m = i+1; m <= i+count; m++) {
                if(obj[k].bur < obj[m].bur) {  // If a process has a shorter burst time, swap it to the front
                    n1 = obj[k];
                    obj[k] = obj[m];
                    obj[m] = n1;
                }
            }
        }

        // Calculate the completion time, turnaround time, and waiting time for the next process
        obj[i+1].ct = obj[i].ct + obj[i+1].bur;  // Completion time = Previous process's completion time + current burst time
        tat[i+1] = obj[i+1].ct - obj[i+1].arr;   // Turnaround time = Completion time - Arrival time
        wt[i+1] = tat[i+1] - obj[i+1].bur;       // Waiting time = Turnaround time - Burst time
    }

    // Printing the results in a tabular format
    printf("AT\tBT\tCT\tWT\tTAT\n");  // Header for the table
    for(i = 0; i < n; i++) {
        printf("%d\t%d\t%d\t%d\t%d\n", obj[i].arr, obj[i].bur, obj[i].ct, wt[i], tat[i]);
        // Print Arrival Time, Burst Time, Completion Time, Waiting Time, and Turnaround Time for each process
    }

    return 0;  // End of the program, returning 0 indicates successful execution
}


4.SRJF:
#include<stdio.h>   // Including standard input-output header file
#include<stdlib.h>  // Including standard library header file (not used in this program)

// Defining a structure to represent each process
struct node {
    int arr;   // Arrival time of the process
    int ct;    // Completion time of the process
    int bur;   // Burst time (total execution time) of the process
    int rem;   // Remaining burst time of the process
    int stat;  // Status of the process (whether it's completed)
    int wt;    // Waiting time of the process
    int tat;   // Turnaround time of the process
};

int main() {
    struct node obj[100];  // Array to store up to 100 processes
    int n, i, j, k, m;     // Declaring variables for loop control and number of processes

    // Asking the user to input the number of processes
    printf("Enter the number of processes\n");
    scanf("%d", &n);  // Storing the number of processes in variable 'n'

    // Loop to input the arrival time and burst time for each process
    for(i = 0; i < n; i++) {
        printf("Enter the arrival time of process %d\n", i+1);
        scanf("%d", &obj[i].arr);  // Input arrival time for the process

        printf("Enter the burst time of process %d\n", i+1);
        scanf("%d", &obj[i].bur);  // Input burst time for the process

        obj[i].ct = 0;              // Initializing the completion time to 0
        obj[i].rem = obj[i].bur;    // Remaining burst time is initially the same as burst time
        obj[i].stat = 0;            // Initializing the status to 0 (not completed)
    }

    // Sorting processes based on their arrival time using bubble sort
    struct node temp;  // Temporary variable for swapping processes
    for(i = 0; i < n-1; i++) {
        for(j = i+1; j < n; j++) {
            if(obj[i].arr > obj[j].arr) {  // If the current process arrives later than the next process
                temp = obj[j];  // Swap the processes
                obj[j] = obj[i];
                obj[i] = temp;
            }
        }
    }

    // Implementing SRJF (Shortest Remaining Job First) Scheduling
    int count = 0;  // Counter to track the number of completed processes
    int time = 0;   // Variable to track the current time

    // Main loop to execute the SRJF algorithm
    while(count != n) {
        int s = -1;  // Variable to hold the index of the process with the shortest remaining time

        // Loop through all processes to find the one with the shortest remaining time that has arrived
        for(i = 0, count = 0; i < n; i++) {
            if(obj[i].rem == 0) {  // If the process is already completed
                count++;           // Increment the count of completed processes
                obj[i].stat = 1;   // Mark the process as completed
                continue;          // Skip to the next process
            }
            if(obj[i].arr <= time) {  // If the process has arrived by the current time
                if(s == -1 || obj[i].rem < obj[s].rem) {  // If this process has the shortest remaining time
                    s = i;  // Set this process as the one to execute
                }
            }
        }

        // If no process has arrived, increment the time and continue
        if(s == -1) {
            time++;
            continue;
        }

        // Execute the process with the shortest remaining time
        obj[s].rem--;  // Decrease the remaining burst time
        time++;        // Increment the current time
        obj[s].ct = time;  // Update the completion time for the process

        // If the process is now completed, increment the count of completed processes
        if(obj[s].rem == 0) {
            count++;
        }
    }

    // Calculate Turnaround Time (TAT) and Waiting Time (WT) for each process
    for(i = 0; i < n; i++) {
        obj[i].tat = obj[i].ct - obj[i].arr;  // TAT = Completion Time - Arrival Time
        obj[i].wt = obj[i].tat - obj[i].bur;  // WT = TAT - Burst Time
    }

    // Printing the results in a tabular format
    printf("AT\tBT\tCT\tWT\tTAT\n");  // Header for the table
    for(i = 0; i < n; i++) {
        printf("%d\t%d\t%d\t%d\t%d\n", obj[i].arr, obj[i].bur, obj[i].ct, obj[i].wt, obj[i].tat);
        // Print Arrival Time, Burst Time, Completion Time, Waiting Time, and Turnaround Time for each process
    }

    return 0;  // End of the program, returning 0 indicates successful execution
}


Ex 1 - Parent Child Communication using Pipe
#include<stdio.h>
#include<sys/types.h>
#include<unistd.h>
int main()
{
int p[2];
int pid;
char inbuf[10],outbuf[10];
pipe(p); //To send message between parent and child //
pid=fork(); // Fork call to create child process //
if(pid) //// Code of Parent process
{
printf("In parent process\n");
printf("type the data to be sent to child");
scanf("%s",outbuf); // Writing a message into the pipe
write (p[1],outbuf, sizeof(outbuf)); //p[1] indicates write
sleep(2); // To allow the child to run
printf("after sleep in parent process\n");
}
else // Coding of child process //
{
sleep(2);
printf("In child process\n");
read(p[0],inbuf,10); // Read the message written by parent
printf("the data received by the child is %s\n",inbuf);
}
return 0;
}


Ex 2A - Interprocess Communication using Shared
Memory
SERVER:
#include<stdio.h>
#include<sys/types.h>
#include<sys/ipc.h>
#include<sys/shm.h>
#include<unistd.h>
#include<string.h>
#define SHMSZ 50
void main()
{
char c;
int shmid;
key_t key;
char*shm,*s;
key=5678; // A random number used as key
shmid=shmget(key,SHMSZ,IPC_CREAT|0666); // Create shared
//memory
shm=(char*)shmat(shmid,NULL,0); //Attach shared memory
s=shm; // Temporary pointer to avoid moving shm from base address of
//shared memory
printf("Enter the message you want to send: ");
scanf("%s", s); // Message copied into Shared memory directly through
//spointer
while(*shm!='*') // Sender waits until received acknowledge it has read
//by appending * into shared memory
sleep(1);
}
CLIENT:
#include <stdio.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#define SHMSZ 50
void main()
{
int shmid;
key_t key;
char *shm, *s;
key = 5678;
shmid = shmget(key, SHMSZ, 0666);
shm = (char*)shmat(shmid, NULL, 0);
for (s = shm; *s != '\0'; s++)
putchar(*s);
*shm = '*';
}
Ex 2B - Interprocess Communication using Message
Queue
SENDER:
#include <stdio.h>
#include <sys/ipc.h>
#include <sys/msg.h>
#include <string.h>
// structure for message queue
struct mesg_buffer {
long mesg_type;
char mesg_text[100];
} message;
int main()
{
key_t key;
int msgid;
// ftok to generate unique key
key = ftok("progfile", 65);
// msgget creates a message queue
// and returns identifier
msgid = msgget(key, 0666 | IPC_CREAT);
//message.mesg_type = 1;
printf("Writing Data : ");
printf("\nEnter the message:");
scanf("%s",message.mesg_text);
do
{
printf("\nEnter the type for message:");
scanf("%ld",&message.mesg_type);
// msgsnd to send message
msgsnd(msgid, &message, sizeof(message), 0);
// display the message
//printf("Data send is : %s \n", message.mesg_text);
printf("\nEnter the message:");
scanf("%s",message.mesg_text);
}while(strcmp(message.mesg_text,"end")!=0);
return 0;
}
RECEIVER:
#include <stdio.h>
#include <sys/ipc.h>
#include <sys/msg.h>
#include <string.h>
// structure for message queue
struct mesg_buffer {
long mesg_type;
char mesg_text[100];
} message;
int main()
{
key_t key;
int msgid,type;
char choice[10];
key = ftok("progfile", 65);
msgid = msgget(key, 0666 | IPC_CREAT);
printf("Read Data : ");
do{
printf("\nEnter the type of the message: ");
scanf("%d",&type);
msgrcv(msgid, &message, sizeof(message),type, 0);
printf("\nMessage is : %s \n", message.mesg_text);
printf("Do you want to continue: ");
scanf("%s",choice);
}while(strcmp(choice,"no")!=0);
msgctl(msgid, IPC_RMID, NULL);
return 0;
}
#include <stdio.h>

struct process {
    int at;      // Arrival Time
    int st;      // Service Time (Burst Time)
    int cpu;     // CPU assigned
    int status;  // Status of the process (0 for not completed, 1 for completed)
    int ft;      // Finish Time
} ready_list[10];

int n;

// Dispatcher function to find the next process to execute
int dispatcher(int time) {
    int i, index = -1;
    for (i = 0; i < n; i++) {
        if (ready_list[i].status != 1 && ready_list[i].at <= time) {
            index = i;
            return index;
        }
    }
    return index;
}

int main() {
    int i, j, pid, h;
    
    printf("Enter number of processes: ");
    scanf("%d", &n);
    
    printf("Enter number of CPUs: ");
    scanf("%d", &h);

    // Collect process details
    for (i = 0; i < n; i++) {
        printf("Process %d\n", i + 1);
        printf("*\n");
        printf("Enter Arrival Time: ");
        scanf("%d", &ready_list[i].at);
        printf("Enter Service Time: ");
        scanf("%d", &ready_list[i].st);
        ready_list[i].status = 0;
    }

    int cur_time[h]; // Current time for each CPU
    for (j = 0; j < h; j++) {
        cur_time[j] = 0;
    }

    i = 0;
    while (i < n) {
        for (j = 0; j < h && i < n; j++) {
            pid = dispatcher(cur_time[j]);
            while (pid == -1) {
                cur_time[j]++;
                pid = dispatcher(cur_time[j]);
            }
            if (pid != -1) {
                ready_list[pid].ft = cur_time[j] + ready_list[pid].st;
                ready_list[pid].status = 1;
                ready_list[pid].cpu = j + 1;
                cur_time[j] += ready_list[pid].st;
                i++;
            }
        }
    }

    // Display process details and metrics
    printf("Process\tArrival Time\tBurst Time\tFinish Time\tCPU\tTT\tWT\n");
    printf("\t\t*\t\t\t*\t*\n");
    
    for (i = 0; i < n; i++) {
        int tt = ready_list[i].ft - ready_list[i].at; // Turnaround Time
        int wt = tt - ready_list[i].st;              // Waiting Time
        printf("%d\t%d\t\t%d\t\t%d\t\t%d\t%d\t%d\n", 
               i + 1, ready_list[i].at, ready_list[i].st, 
               ready_list[i].ft, ready_list[i].cpu, tt, wt);
    }

    return 0;
}
