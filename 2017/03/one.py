def spiral(input):
    x, y = 0, 0
    dx, dy = 1, 0

    for _ in range(1, input):
        x, y = x+dx, y+dy

        if x == y or (x < 0 and x == -y) or (x > 0 and x == 1-y):
            dx, dy = -dy, dx

    return abs(x) + abs(y)

assert spiral(1) == 0
assert spiral(12) == 3
assert spiral(23) == 2
assert spiral(1024) == 31
print(spiral(361527))
