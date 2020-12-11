// https://adventofcode.com/2020/day/11

// Part 1
function getOccupiedSeatCount(input) {
  let layout = input;

  while (true) {
    let newLayout = [];
    let layoutChanged = false;

    for (let y = 0; y < layout.length; y++) {
      newLayout.push([]);

      for (let x = 0; x < layout[y].length; x++) {
        const val = layout[y][x];
        const adjacentOccupiedSeatCount = [
          [-1, 0], // UP
          [-1, +1], // UP RIGHT
          [0, +1], // RIGHT
          [+1, +1], // DOWN RIGHT
          [+1, 0], // DOWN
          [+1, -1], // DOWN LEFT
          [0, -1], // LEFT
          [-1, -1], // UP LEFT
        ].reduce(
          (count, [yChange, xChange]) =>
            count + (layout[y + yChange]?.[x + xChange] === "#"),
          0
        );

        if (val === "L" && adjacentOccupiedSeatCount === 0) {
          newLayout[y][x] = "#";
          layoutChanged = true;
        } else if (val === "#" && adjacentOccupiedSeatCount >= 4) {
          newLayout[y][x] = "L";
          layoutChanged = true;
        } else {
          newLayout[y][x] = val;
        }
      }
    }

    if (layoutChanged === false) {
      return layout.flat().reduce((count, val) => count + (val === "#"), 0);
    }

    layout = newLayout;
  }
}

// Part 2
function getOccupiedSeatCountByVisibility(input) {
  let layout = input;

  function findVisibileSeat([y, x], [yChange, xChange]) {
    do {
      y += yChange;
      x += xChange;
    } while (layout[y]?.[x] === ".");
    return layout[y]?.[x];
  }

  while (true) {
    let newLayout = [];
    let layoutChanged = false;

    for (let y = 0; y < layout.length; y++) {
      newLayout.push([]);

      for (let x = 0; x < layout[y].length; x++) {
        const val = layout[y][x];
        const visibleOccupiedSeatCount = [
          [-1, 0], // UP
          [-1, +1], // UP RIGHT
          [0, +1], // RIGHT
          [+1, +1], // DOWN RIGHT
          [+1, 0], // DOWN
          [+1, -1], // DOWN LEFT
          [0, -1], // LEFT
          [-1, -1], // UP LEFT
        ].reduce(
          (count, change) => count + (findVisibileSeat([y, x], change) === "#"),
          0
        );

        if (val === "L" && visibleOccupiedSeatCount === 0) {
          newLayout[y][x] = "#";
          layoutChanged = true;
        } else if (val === "#" && visibleOccupiedSeatCount >= 5) {
          newLayout[y][x] = "L";
          layoutChanged = true;
        } else {
          newLayout[y][x] = val;
        }
      }
    }

    if (layoutChanged === false) {
      return layout.flat().reduce((count, val) => count + (val === "#"), 0);
    }

    layout = newLayout;
  }
}

console.assert(
  getOccupiedSeatCount([
    "L.LL.LL.LL",
    "LLLLLLL.LL",
    "L.L.L..L..",
    "LLLL.LL.LL",
    "L.LL.LL.LL",
    "L.LLLLL.LL",
    "..L.L.....",
    "LLLLLLLLLL",
    "L.LLLLLL.L",
    "L.LLLLL.LL",
  ]) == 37,
  "Part 1 failed"
);

console.assert(
  getOccupiedSeatCountByVisibility([
    "L.LL.LL.LL",
    "LLLLLLL.LL",
    "L.L.L..L..",
    "LLLL.LL.LL",
    "L.LL.LL.LL",
    "L.LLLLL.LL",
    "..L.L.....",
    "LLLLLLLLLL",
    "L.LLLLLL.L",
    "L.LLLLL.LL",
  ]) == 26,
  "Part 2 failed"
);

if (process.argv[2]) {
  const input = process.argv[2].split("\n");
  console.log(getOccupiedSeatCount(input));
  console.log(getOccupiedSeatCountByVisibility(input));
}
