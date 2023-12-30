# https://adventofcode.com/2021/day/15
import sys
import networkx as nx


# Part 1: Set size to 1
# Part 2: Set size to 5

def get_lowest_total_risk(risk_levels, size=1):
    risk_map = []
    for yi in range(-1, size-1):
        for row in risk_levels:
            temp_row = []
            for xi in range(-1, size-1):
                for risk in row:
                    calc_risk = (int(risk) + xi) % 9 + 1
                    calc_risk = (calc_risk + yi) % 9 + 1
                    temp_row.append(calc_risk)
            risk_map.append(temp_row)

    def get_neighbors(x, y):
        if y > 0:
            yield (x, y-1)
        if x > 0:
            yield (x-1, y)
        if y < len(risk_map)-1:
            yield (x, y+1)
        if x < len(risk_map)-1:
            yield (x+1, y)

    G = nx.DiGraph()
    for y, row in enumerate(risk_map):
        for x, risk in enumerate(row):
            for neighbor in get_neighbors(x, y):
                G.add_edge(neighbor, (x, y), risk=risk)

    return nx.shortest_path_length(
        G,
        source=((0, 0)),
        target=((len(risk_map)-1, len(risk_map)-1)),
        weight="risk")


test_risk_levels = [
    "1163751742",
    "1381373672",
    "2136511328",
    "3694931569",
    "7463417111",
    "1319128137",
    "1359912421",
    "3125421639",
    "1293138521",
    "2311944581",
]
assert get_lowest_total_risk(test_risk_levels) == 40, "Part 1 failed"
assert get_lowest_total_risk(test_risk_levels, 5) == 315, "Part 2 failed"

if len(sys.argv) > 1:
    risk_levels = sys.argv[1].splitlines()
    print(get_lowest_total_risk(risk_levels))
    print(get_lowest_total_risk(risk_levels, 5))
