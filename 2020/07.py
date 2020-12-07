# https://adventofcode.com/2020/day/7

import re
import sys


class Bag:
    def __init__(self, name):
        self.name = name
        self.contained_bags = []

    def __repr__(self):
        return self.name

    def add_contained_bag(self, bag, amount):
        self.contained_bags.append((bag, amount))


def parse_bags(input):
    bags = dict()

    for rule in input:
        [current_bag_str, contained_bags_str] = rule.split(" contain ")
        current_bag_name = current_bag_str.replace(" bags", "")
        current_bag = bags.setdefault(current_bag_name, Bag(current_bag_name))

        for contained_bag_str in contained_bags_str.removesuffix(".").split(", "):
            match = re.match("(\d+) (.*) bags?", contained_bag_str)
            if match:
                contained_bag_name = match.group(2)
                contained_bag = bags.setdefault(
                    contained_bag_name, Bag(contained_bag_name))
                current_bag.add_contained_bag(
                    contained_bag, int(match.group(1)))

    return bags


# Part 1
def get_bags_count(input):
    bags = parse_bags(input)

    def contains_bag(bag):
        return any(
            contained_bag.name == "shiny gold" or
            contains_bag(contained_bag)
            for (contained_bag, _) in bag.contained_bags
        )

    return sum(contains_bag(bag) for bag in bags.values())


# Part 2
def get_all_containing_bags_count(input):
    bags = parse_bags(input)

    def count_containing_bags(bag, amount=1):
        return sum(
            amount * contained_amount +
            count_containing_bags(contained_bag, amount * contained_amount)
            for (contained_bag, contained_amount) in bag.contained_bags
        )

    return count_containing_bags(bags["shiny gold"])


assert get_bags_count([
    "light red bags contain 1 bright white bag, 2 muted yellow bags.",
    "dark orange bags contain 3 bright white bags, 4 muted yellow bags.",
    "bright white bags contain 1 shiny gold bag.",
    "muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.",
    "shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.",
    "dark olive bags contain 3 faded blue bags, 4 dotted black bags.",
    "vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.",
    "faded blue bags contain no other bags.",
    "dotted black bags contain no other bags.",
]) == 4, "Part 1 failed"

assert get_all_containing_bags_count([
    "shiny gold bags contain 2 dark red bags.",
    "dark red bags contain 2 dark orange bags.",
    "dark orange bags contain 2 dark yellow bags.",
    "dark yellow bags contain 2 dark green bags.",
    "dark green bags contain 2 dark blue bags.",
    "dark blue bags contain 2 dark violet bags.",
    "dark violet bags contain no other bags.",
]) == 126, "Part 2 failed"

if len(sys.argv) > 1:
    input = sys.argv[1].splitlines()
    print(get_bags_count(input))
    print(get_all_containing_bags_count(input))
