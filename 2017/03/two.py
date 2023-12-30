def spiral(input):
    x, y = 0, 0
    dx, dy = 1, 0
    values = {(0, 0): 1}

    while True:
        x, y = x+dx, y+dy

        if x == y or (x < 0 and x == -y) or (x > 0 and x == 1-y):
            dx, dy = -dy, dx

        neighbors = [
            (1, 1),
            (-1, -1),
            (1, -1),
            (-1, 1),
            (1, 0),
            (-1, 0),
            (0, 1),
            (0, -1)
        ]
        value = sum([values.get((x+nx, y+ny), 0) for nx, ny in neighbors])
        values[(x, y)] = value

        if value > input:
            return value

assert spiral(1) == 2
assert spiral(2) == 4
assert spiral(4) == 5
assert spiral(5) == 10
print(spiral(361527))
