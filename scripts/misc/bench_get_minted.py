import time
for startTub in [ 0, 1, 2, 3, 501, 1001, 2048, 2049]:
    for span in [1, 2, 4, 8, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 150, 200, 300, 400, 500, 1000, 2000, 4096]:
        stopTub = startTub + span
        if (stopTub <= 4096):
            t0 = time.process_time()
            assert(len(testbed.get_minted('TokenA', 'TokenB', startTub, stopTub, 15)) == span)
            t1 = time.process_time()
            print('getMinted({}, {}) = {} ms'.format(startTub, stopTub, (t1-t0)*1000))

