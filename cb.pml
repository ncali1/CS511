#define N 2  // 2 (resp. 3) - requires setting max_depth to 12000 (resp. 22000)
#define B 2
byte mutexE = 1;
byte mutexL = 1;
byte barrier = 0;
byte barrier2 = 0;

byte c[N]; // array for counting cycles
byte enter = 0;
byte leaving = 0;

inline acquire(s) {
    skip;
end1: atomic {
        s > 0;
        s--;
    }
}

inline release(s, n) {
   s++;
}

active [N] proctype P() {
    byte i;
    byte j;
    byte k;


    for (i: 1..100) {
        // Entry section
        acquire(mutexE);
        enter++;
        if
        :: (enter == B) ->
            release(barrier, B);
            enter = 0;
        :: else -> skip
        fi;
        release(mutexE, 1);

        // Barrier synchronization
        acquire(barrier);
        release(barrier, 1);

        // Critical Section
        c[_pid] = c[_pid] + 1;
        printf("%d reached at cycle %d\n", _pid, c[_pid]);

        // Assertion: No thread should get ahead of any other
        atomic {
            for (j: 0.. N-1) {
                for (k: 0.. N-1) {
                    if
                    :: (j != k) -> assert(c[j] <= c[k]);
                    :: else -> skip
                    fi;
                }
            }
        }

        // Exit section
        printf("%d leaves at cycle %d\n", _pid, c[_pid]);

        // Leaving section
        acquire(mutexL);
        leaving++;
        if
        :: (leaving == B) ->
            release(barrier2, B);
            leaving = 0;
        :: else -> skip
        fi;
        release(mutexL, 1);

        // Barrier2 synchronization
        acquire(barrier2);
        release(barrier2, 1);
    }
}