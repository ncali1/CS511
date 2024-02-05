
/*
Quiz 3 - 28 Sep 2022

You may only declare semaphores and add acquire/release instructions.
The out put should be:

a(b+c)da(b+c)da(b+c)da(b+c)da(b+c)d....

*/

import java.util.concurrent.Semaphore;

Semaphore semaphoreA = new Semaphore(1);
Semaphore semaphoreB = new Semaphore(0);
Semaphore semaphoreC = new Semaphore(0);

Thread.start { // P
    while (true) {
        semaphoreA.acquire();
        print("a");
        semaphoreB.release();
        semaphoreC.release();
        semaphoreB.acquire();
        print("(b");
    }
}

Thread.start { // Q
    while (true) {
        semaphoreB.acquire();
        print("c)");
        semaphoreA.release();
    }
}

Thread.start { // R
    while (true) {
        semaphoreC.acquire();
        print("d");
        semaphoreA.release();
    }
}
