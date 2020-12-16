# https://adventofcode.com/2020/day/16

import re
import sys
import math


# Part 1
def get_ticket_scanning_error_rate(input):
    ranges = [range(int(start), int(end) + 1)
              for start, end in re.findall(r"(\d+)-(\d+)", input)]
    nearby_ticket_numbers = [int(nr) for nr in re.findall(r"(\d+),?", input)]
    invalid_ticket_numbers = [
        nr for nr in nearby_ticket_numbers if not any(nr in r for r in ranges)]
    return sum(invalid_ticket_numbers)


# Part 2
def get_product_of_departure_values(input):
    fields_raw, ticket_raw, nearby_tickets_raw = input.split("\n\n")
    fields_raw = re.findall(r"([\w\s]+): (.+)\n?", fields_raw)
    fields = {field_name: [range(int(a), int(b) + 1)
                           for a, b in re.findall(r"(\d+)-(\d+)", ranges_raw)] for field_name, ranges_raw in fields_raw}
    tickets = [[int(b) for b in a.split(",")]
               for a in re.findall(r"(\d+.*)\n?", ticket_raw + "\n" + nearby_tickets_raw)]
    my_ticket = tickets[0]
    valid_tickets = [ticket for ticket in tickets if all(any(
        nr in range_1 or nr in range_2 for range_1, range_2 in fields.values()) for nr in ticket)]
    possible_mappings = {field_name: [] for field_name in fields.keys()}

    for field_name, (range_1, range_2) in fields.items():
        for idx in range(0, len(fields)):
            if all(ticket[idx] in range_1 or ticket[idx] in range_2 for ticket in valid_tickets):
                possible_mappings[field_name].append(idx)

    departure_values = []

    while cur := next(((field_name, indexes[0]) for field_name, indexes in possible_mappings.items() if len(indexes) == 1), None):
        field_name, cur_idx = cur
        if field_name.startswith('departure'):
            departure_values.append(my_ticket[cur_idx])
        possible_mappings = {field_name: [idx for idx in indexes if idx != cur_idx]
                             for (field_name, indexes) in possible_mappings.items()}

    return math.prod(departure_values)


assert get_ticket_scanning_error_rate("""
    class: 1-3 or 5-7
    row: 6-11 or 33-44
    seat: 13-40 or 45-50

    your ticket:
    7, 1, 14

    nearby tickets:
    7, 3, 47
    40, 4, 50
    55, 2, 20
    38, 6, 12
    """) == 71, "Part 1 failed"

if len(sys.argv) > 1:
    input = sys.argv[1]
    print(get_ticket_scanning_error_rate(input))
    print(get_product_of_departure_values(input))
