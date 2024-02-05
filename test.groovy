Semaphore P = new Semaphore(1)
Semaphore Q = new Semaphore(0)
Semaphore R = new Semaphore(0)
Semaphore S = new Semaphore(0)

Thread.start { // P
    while (true) {
    P.acquire()
	print("a")
    Q.release
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

