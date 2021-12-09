# https://adventofcode.com/2021/day/9
import sys
import functools
import operator

# Part 1


def get_risk_level_sum(heightmap):
    matrix = [[int(height) for height in line]
              for line in heightmap]
    height, width = len(matrix), len(matrix[0])

    def get_neighbors(y, x):
        neighbors = []

        if y > 0:
            neighbors.append(matrix[y-1][x])
        if x > 0:
            neighbors.append(matrix[y][x-1])
        if y < height-1:
            neighbors.append(matrix[y+1][x])
        if x < width-1:
            neighbors.append(matrix[y][x+1])

        return neighbors

    risk_level_sum = 0

    for y in range(height):
        for x in range(width):
            current = matrix[y][x]
            neighbors = get_neighbors(y, x)
            is_low_point = all(n > current for n in neighbors)
            if is_low_point:
                risk_level_sum += current + 1

    return risk_level_sum


# Part 2


def get_basin_size_product(heightmap):
    matrix = [[0 if height == "9" else 1 for height in line]
              for line in heightmap]
    height, width = len(matrix), len(matrix[0])

    def traverse(y, x):
        matrix[y][x] = 0
        result = 1

        if y > 0 and matrix[y-1][x]:
            result += traverse(y-1, x)
        if x > 0 and matrix[y][x-1]:
            result += traverse(y, x-1)
        if y < height-1 and matrix[y+1][x]:
            result += traverse(y+1, x)
        if x < width-1 and matrix[y][x+1]:
            result += traverse(y, x+1)

        return result

    basin_sizes = []

    for y in range(height):
        for x in range(width):
            if matrix[y][x]:
                basin_sizes.append(traverse(y, x))

    return functools.reduce(operator.mul, sorted(basin_sizes)[-3:])


test_heightmap = [
    "2199943210",
    "3987894921",
    "9856789892",
    "8767896789",
    "9899965678",
]
assert get_risk_level_sum(test_heightmap) == 15, "Part 1 failed"
assert get_basin_size_product(test_heightmap) == 1134, "Part 2 failed"

if len(sys.argv) > 1:
    heightmap = sys.argv[1].splitlines()
    print(get_risk_level_sum(heightmap))
    print(get_basin_size_product(heightmap))
