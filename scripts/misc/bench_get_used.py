import time
spans = [
    1, 2, 4, 8, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 150, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 2000, 4096
]
for startBin in [0, 1, 2, 3, 501, 1001, 2048, 2049]:
    for span in spans:
        stopBin = startBin + span
        if (stopBin <= 4096 * 2):
            t0 = time.process_time()
            assert(len(testbed.get_used('TokenA', 'TokenB', startBin, stopBin, 15)) == span)
            t1 = time.process_time()
            print('getUsed({}, {}) = {} ms'.format(startBin, stopBin, (t1-t0)*1000))
