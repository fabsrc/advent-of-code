// https://adventofcode.com/2020/day/10

// Part 1
int getJoltDifferences(List<int> input) {
  var sortedList = input..sort();
  var maxJolt = sortedList.last;
  sortedList.add(maxJolt + 3);
  var counts = new Map();

  sortedList.asMap().forEach((idx, currJolt) {
    var diff = currJolt - [0, ...sortedList][idx];
    counts[diff] ??= 0;
    counts[diff] += 1;
  });

  return (counts[1] ?? 1) * (counts[3] ?? 1);
}

// Part 2
int getDistinctAdapterCombinations(List<int> input) {
  var sortedList = input..sort();
  var maxJolt = sortedList.last;
  var counts = new Map();

  for (var currJolt in sortedList.reversed) {
    if (currJolt == maxJolt) {
      counts[currJolt] = 1;
      continue;
    }

    var count = 0;

    for (var i = currJolt + 1; i <= currJolt + 3; i += 1) {
      count += counts[i] ?? 0;
    }

    counts[currJolt] = count;
  }

  return (counts[1] ?? 0) + (counts[2] ?? 0) + (counts[3] ?? 0);
}

void main(List<String> args) {
  if (getJoltDifferences([16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4]) != 35) {
    throw "Part 1 failed";
  }

  if (getDistinctAdapterCombinations([16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4]) !=
      8) {
    throw "Part 2 failed";
  }

  if (getDistinctAdapterCombinations([
        28,
        33,
        18,
        42,
        31,
        14,
        46,
        20,
        48,
        47,
        24,
        23,
        49,
        45,
        19,
        38,
        39,
        11,
        1,
        32,
        25,
        35,
        8,
        17,
        7,
        9,
        4,
        2,
        34,
        10,
        3
      ]) !=
      19208) {
    throw "Part 2 failed";
  }

  if (args.length > 0) {
    var input = args.first.split("\n").map(int.parse).toList();
    print(getJoltDifferences(input));
    print(getDistinctAdapterCombinations(input));
  }
}
