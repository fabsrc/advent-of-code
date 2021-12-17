// https://adventofcode.com/2021/day/17
// Deno

// Part 1
function getHighestYPosition(input: string): number {
  const match = input.match(/x=(.+)\.\.(.+), y=(.+)\.\.(.+)/);
  const [minX, maxX, minY, maxY] = match?.slice(1).map((n) => +n) ?? [];
  let highestY = 0;

  for (let vX = Math.abs(maxX) * -2; vX <= Math.abs(maxX) * 2; vX++) {
    for (let vY = Math.abs(maxY) * -2; vY <= Math.abs(maxY) * 2; vY++) {
      let [curX, curY, curVX, curVY] = [0, 0, vX, vY];
      let curHighestY = 0;

      while (true) {
        curX += curVX;
        curY += curVY;
        curVY -= 1;
        if (curVX > 0) {
          curVX -= 1;
        } else if (curVX < 0) {
          curVX += 1;
        }

        if (curHighestY < curY) {
          curHighestY = curY;
        }

        if (curX >= minX && curX <= maxX && curY >= minY && curY <= maxY) {
          if (highestY < curHighestY) {
            highestY = curHighestY;
          }
          break;
        }

        if (
          Math.abs(curX) >= Math.abs(maxX) * 1024 ||
          Math.abs(curY) >= Math.abs(maxY) * 1024
        ) {
          break;
        }
      }
    }
  }

  return highestY;
}

// Part 2
function getDistinctVelocitiesCount(input: string): number {
  const match = input.match(/x=(.+)\.\.(.+), y=(.+)\.\.(.+)/);
  const [minX, maxX, minY, maxY] = match?.slice(1).map((n) => +n) ?? [];
  const initialVelocities = new Set();

  for (let vX = Math.abs(maxX) * -2; vX <= Math.abs(maxX) * 2; vX++) {
    for (let vY = Math.abs(maxY) * -2; vY <= Math.abs(maxY) * 2; vY++) {
      let [curX, curY, curVX, curVY] = [0, 0, vX, vY];

      while (true) {
        curX += curVX;
        curY += curVY;
        curVY -= 1;
        if (curVX > 0) {
          curVX -= 1;
        } else if (curVX < 0) {
          curVX += 1;
        }

        if (curX >= minX && curX <= maxX && curY >= minY && curY <= maxY) {
          initialVelocities.add(`${vX}_${vY}`);
          break;
        }

        if (
          Math.abs(curX) >= Math.abs(maxX) * 1024 ||
          Math.abs(curY) >= Math.abs(maxY) * 1024
        ) {
          break;
        }
      }
    }
  }

  return initialVelocities.size;
}

const testTargetArea = "target area: x=20..30, y=-10..-5";
console.assert(getHighestYPosition(testTargetArea) === 45, "Part 1 failed");
console.assert(
  getDistinctVelocitiesCount(testTargetArea) === 112,
  "Part 2 failed"
);

if (Deno.args[0]) {
  const targetArea = Deno.args[0];
  console.log(getHighestYPosition(targetArea));
  console.log(getDistinctVelocitiesCount(targetArea));
}
