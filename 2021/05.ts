// https://adventofcode.com/2021/day/5
// Deno

type Point = [number, number];

function coordRange([x1, y1]: Point, [x2, y2]: Point) {
  return {
    *[Symbol.iterator]() {
      while (true) {
        yield [x1, y1];
        if (x1 === x2 && y1 === y2) {
          return [x1, y1];
        }
        if (x1 !== x2) {
          x1 += x1 < x2 ? 1 : -1;
        }
        if (y1 !== y2) {
          y1 += y1 < y2 ? 1 : -1;
        }
      }
    },
  };
}

// Part 1
function getOverlapCount(lines: string[]): number {
  const area: Record<string, number> = {};

  lines.forEach((line) => {
    const [, ...matches] = line.match(/(\d+),(\d+) -> (\d+),(\d+)/) ?? [];
    const [x1, y1, x2, y2] = matches.map((i) => +i);

    if (x1 === x2 || y1 === y2) {
      for (const [x, y] of coordRange([x1, y1], [x2, y2])) {
        area[`${x},${y}`] = (area[`${x},${y}`] ?? 0) + 1;
      }
    }
  });

  return Object.values(area).filter((n) => n > 1).length;
}

// Part 2
function getOverlapCountWithDiagonals(lines: string[]): number {
  const area: Record<string, number> = {};

  lines.forEach((line) => {
    const [, ...matches] = line.match(/(\d+),(\d+) -> (\d+),(\d+)/) ?? [];
    const [x1, y1, x2, y2] = matches.map((i) => +i);

    for (const [x, y] of coordRange([x1, y1], [x2, y2])) {
      area[`${x},${y}`] = (area[`${x},${y}`] ?? 0) + 1;
    }
  });

  return Object.values(area).filter((n) => n > 1).length;
}

const testLines = [
  "0,9 -> 5,9",
  "8,0 -> 0,8",
  "9,4 -> 3,4",
  "2,2 -> 2,1",
  "7,0 -> 7,4",
  "6,4 -> 2,0",
  "0,9 -> 2,9",
  "3,4 -> 1,4",
  "0,0 -> 8,8",
  "5,5 -> 8,2",
];
console.assert(getOverlapCount(testLines) === 5, "Part 1 failed");
console.assert(getOverlapCountWithDiagonals(testLines) === 12, "Part 2 failed");

if (Deno.args[0]) {
  const lines = Deno.args[0].split("\n");
  console.log(getOverlapCount(lines));
  console.log(getOverlapCountWithDiagonals(lines));
}
