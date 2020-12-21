# https://adventofcode.com/2020/day/21

import re
import sys


# Part 1
def get_count_of_non_allergenic_ingredients(input):
    ingredient_counts = {}
    all_allergens = {}
    for line in input:
        ingredients = re.findall(r"(?:(\w+)(?<!contains))\s", line)
        allergens = re.findall(r"(\w+)[,)]", line)
        for ingredient in ingredients:
            ingredient_counts[ingredient] = ingredient_counts.get(
                ingredient, 0) + 1
        for allergen in allergens:
            all_allergens.setdefault(allergen, set(ingredients))
            all_allergens[allergen] = all_allergens[allergen].intersection(
                set(ingredients))
    for allergenic_ingredients in all_allergens.values():
        for allergenic_ingredient in allergenic_ingredients:
            if allergenic_ingredient in ingredient_counts:
                del ingredient_counts[allergenic_ingredient]
    return sum(ingredient_counts.values())


# Part 2
def get_list_of_allergenic_ingredients(input):
    all_allergens = {}
    for line in input:
        ingredients = re.findall(r"(?:(\w+)(?<!contains))\s", line)
        allergens = re.findall(r"(\w+)[,)]", line)
        for allergen in allergens:
            all_allergens.setdefault(allergen, set(ingredients))
            all_allergens[allergen] = all_allergens[allergen].intersection(
                set(ingredients))

    for allergen, ingredients in iter([a, i] for [a, i] in all_allergens.items() if len(i) > 1):
        resolved_ingredients = [
            i for i in all_allergens.values() if len(i) == 1]
        all_allergens[allergen] = ingredients.difference(*resolved_ingredients)

    return ",".join([ingredients.pop() for _, ingredients in sorted(all_allergens.items())])


assert get_count_of_non_allergenic_ingredients([
    "mxmxvkd kfcds sqjhc nhms (contains dairy, fish)",
    "trh fvjkl sbzzf mxmxvkd (contains dairy)",
    "sqjhc fvjkl (contains soy)",
    "sqjhc mxmxvkd sbzzf (contains fish)",
]) == 5, "Part 1 failed"

assert get_list_of_allergenic_ingredients([
    "mxmxvkd kfcds sqjhc nhms (contains dairy, fish)",
    "trh fvjkl sbzzf mxmxvkd (contains dairy)",
    "sqjhc fvjkl (contains soy)",
    "sqjhc mxmxvkd sbzzf (contains fish)",
]) == "mxmxvkd,sqjhc,fvjkl", "Part 2 failed"

if len(sys.argv) > 1:
    input = sys.argv[1].splitlines()
    print(get_count_of_non_allergenic_ingredients(input))
    print(get_list_of_allergenic_ingredients(input))
