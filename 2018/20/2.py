import sys
import math
from collections import namedtuple


def paths_with_at_least_1000_doors(input):
    Room = namedtuple('Room', ['x', 'y', 'dist'], defaults=[0, 0, 0])

    map = dict()
    stack = list()
    current = Room()

    def add(dx, dy):
        nonlocal current
        room = map.get((current.x + dx, current.y + dy),
                       Room(x=current.x + dx, y=current.y + dy, dist=math.inf))
        current = room._replace(dist=min(room.dist, current.dist + 1))
        map.setdefault((current.x, current.y), current)

    for c in input:
        if c == 'N':
            add(0, -1)
        if c == 'W':
            add(-1, 0)
        if c == 'S':
            add(0, 1)
        if c == 'E':
            add(1, 0)
        if c == '(':
            stack.append(current)
        if c == ')':
            current = stack.pop()
        if c == '|':
            current = stack[-1]

    return sum(room.dist >= 1000 for room in map.values())


if len(sys.argv) > 1:
    print(paths_with_at_least_1000_doors(sys.argv[1]))
