// https://adventofcode.com/2020/day/17

// Part 1
function getActiveCubesAfterBoot3D(input) {
  let activeGrid = {};
  input.forEach((line, y) => {
    line.split("").forEach((cube, x) => {
      if (cube === "#") {
        activeGrid[`${x}.${y}.0`] = true;
      }
    });
  });

  for (let cycle = 0; cycle < 6; cycle++) {
    let neighborCounts = {};

    Object.keys(activeGrid).forEach((coords) => {
      const [cubeX, cubeY, cubeZ] = coords.split(".");
      for (let x = -1; x <= 1; x++) {
        for (let y = -1; y <= 1; y++) {
          for (let z = -1; z <= 1; z++) {
            if (x === 0 && y === 0 && z === 0) continue;
            const coordsToCheck = `${+cubeX + x}.${+cubeY + y}.${+cubeZ + z}`;
            neighborCounts[coordsToCheck] =
              (neighborCounts[coordsToCheck] || 0) + 1;
          }
        }
      }
    });

    let newActiveGrid = {};
    Object.entries(neighborCounts).forEach(([coords, neighbors]) => {
      const isActive = activeGrid[coords];
      if (
        (isActive && (neighbors === 2 || neighbors === 3)) ||
        neighbors === 3
      ) {
        newActiveGrid[coords] = true;
      }
    });
    activeGrid = newActiveGrid;
  }

  return Object.values(activeGrid).length;
}

// Part 2
function getActiveCubesAfterBoot4D(input) {
  let activeGrid = {};
  input.forEach((line, y) => {
    line.split("").forEach((cube, x) => {
      if (cube === "#") {
        activeGrid[`${x}.${y}.0.0`] = true;
      }
    });
  });

  for (let cycle = 0; cycle < 6; cycle++) {
    let neighborCounts = {};

    Object.keys(activeGrid).forEach((coords) => {
      const [cubeX, cubeY, cubeZ, cubeW] = coords.split(".");
      for (let x = -1; x <= 1; x++) {
        for (let y = -1; y <= 1; y++) {
          for (let z = -1; z <= 1; z++) {
            for (let w = -1; w <= 1; w++) {
              if (x === 0 && y === 0 && z === 0 && w === 0) continue;
              const coordsToCheck = `${+cubeX + x}.${+cubeY + y}.${
                +cubeZ + z
              }.${+cubeW + w}`;
              neighborCounts[coordsToCheck] =
                (neighborCounts[coordsToCheck] || 0) + 1;
            }
          }
        }
      }
    });

    let newActiveGrid = {};
    Object.entries(neighborCounts).forEach(([coords, neighbors]) => {
      const isActive = activeGrid[coords];
      if (
        (isActive && (neighbors === 2 || neighbors === 3)) ||
        neighbors === 3
      ) {
        newActiveGrid[coords] = true;
      }
    });
    activeGrid = newActiveGrid;
  }

  return Object.values(activeGrid).length;
}

console.assert(
  getActiveCubesAfterBoot3D([".#.", "..#", "###"]) == 112,
  "Part 1 failed"
);
console.assert(
  getActiveCubesAfterBoot4D([".#.", "..#", "###"]) == 848,
  "Part 2 failed"
);

if (process.argv[2]) {
  const input = process.argv[2].split("\n");
  console.log(getActiveCubesAfterBoot3D(input));
  console.log(getActiveCubesAfterBoot4D(input));
}
