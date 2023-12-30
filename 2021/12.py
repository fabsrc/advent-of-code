# https://adventofcode.com/2021/day/12
import sys
from collections import deque


# Part 1

def get_path_count(connections):
    caves = {}
    for connection in connections:
        src, dst = connection.split("-")
        caves.setdefault(src, []).append(dst)
        caves.setdefault(dst, []).append(src)

    path_count = 0
    queue = deque([["start"]])

    while queue:
        path = queue.popleft()
        current_cave = path[-1]

        if current_cave == "end":
            path_count += 1

        for next_cave in caves.get(current_cave, []):
            if next_cave not in path or next_cave.isupper():
                new_path = path.copy()
                new_path.append(next_cave)
                queue.append(new_path)

    return path_count


# Part 2

def get_path_count_with_new_rules(connections):
    caves = {}
    for connection in connections:
        src, dst = connection.split("-")
        if dst != "start" and src != "end":
            caves.setdefault(src, []).append(dst)
        if src != "start" and dst != "end":
            caves.setdefault(dst, []).append(src)

    path_count = 0
    queue = deque([["start"]])

    def is_visited(path, cave):
        if cave not in path:
            return False

        if cave.isupper():
            return False

        if all(path.count(cave) == 1 for cave in path if cave.islower()):
            return False

        return True

    while queue:
        path = queue.popleft()
        current_cave = path[-1]

        if current_cave == "end":
            path_count += 1

        for next_cave in caves.get(current_cave, []):
            if not is_visited(path, next_cave):
                newpath = path.copy()
                newpath.append(next_cave)
                queue.append(newpath)

    return path_count


test_connections = [
    "fs-end",
    "he-DX",
    "fs-he",
    "start-DX",
    "pj-DX",
    "end-zg",
    "zg-sl",
    "zg-pj",
    "pj-he",
    "RW-he",
    "fs-DX",
    "pj-RW",
    "zg-RW",
    "start-pj",
    "he-WI",
    "zg-he",
    "pj-fs",
    "start-RW",
]
assert get_path_count(test_connections) == 226, "Part 1 failed"
assert get_path_count_with_new_rules(
    test_connections) == 3509, "Part 2 failed"

if len(sys.argv) > 1:
    connections = sys.argv[1].splitlines()
    print(get_path_count(connections))
    print(get_path_count_with_new_rules(connections))
