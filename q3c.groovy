
/*
Quiz 3 - 25 Sep 2023 - Topic 3

You may not add print statements.  
Declare semaphores and add ONLY acquire and release operations to the following code so that every expression in the following set of regular expresions has an interleaving that can print it:

abc*abc*abc*abc*abc*abc*....

Note: c* stands for zero or more c's

*/

import java.util.concurrent.Semaphore
// Declare semaphores here
Semaphore P = new Semaphore(1)
Semaphore Q = new Semaphore(0)
Semaphore R = new Semaphore(0)
Semaphore S = new Semaphore(0)

Thread.start { // P
    while (true) {
    P.acquire()
	print("a")
    Q.release()
    }
}

Thread.start { // Q 
    while (true) {
    Q.acquire()
	print("b")
    R.release()
    }
}

Thread.start { // R
    while (true) {
	R.acquire()
    print("c")
    S.release()
    }
}

Thread.start { // S
    while (true) {
        S.acquire()
    }
}

