import sys
import math
from collections import namedtuple


def largest_number_of_doors(input):
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

    return max(room.dist for room in map.values())


assert largest_number_of_doors("^ENWWW(NEEE|SSE(EE|N))$") == 10
assert largest_number_of_doors(
    "^ENNWSWW(NEWS|)SSSEEN(WNSE|)EE(SWEN|)NNN$") == 18
assert largest_number_of_doors(
    "^ESSWWN(E|NNENN(EESS(WNSE|)SSS|WWWSSSSE(SW|NNNE)))$") == 23
assert largest_number_of_doors(
    "^WSSEESWWWNW(S|NENNEEEENN(ESSSSW(NWSW|SSEN)|WSWWN(E|WWS(E|SS))))$") == 31
if len(sys.argv) > 1:
    print(largest_number_of_doors(sys.argv[1]))
