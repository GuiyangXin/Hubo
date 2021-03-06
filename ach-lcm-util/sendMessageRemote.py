'''
Author: alexc89@mit.edu
SendMessageRemote
This is a remote version of the SendMessage demo contained in LCM.  Used to test the multicast.
'''

import lcm
import time

from lcmtypes import example_t

lc = lcm.LCM("udpm://239.255.76.67:7667?ttl=2")

msg = example_t()
msg.timestamp = int(time.time() * 1000000)
msg.position = (1, 2, 3)
msg.orientation = (1, 0, 0, 0)
msg.ranges = range(15)
msg.num_ranges = len(msg.ranges)
msg.name = "example string"
msg.enabled = True

lc.publish("EXAMPLE", msg.encode())
