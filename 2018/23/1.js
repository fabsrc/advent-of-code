const assert = require("assert");

function nanobotsInRange(input) {
  const nanobots = input.split("\n").map((line) => {
    const [, x, y, z, r] = line.match(/<(-?\d+),(-?\d+),(-?\d+)>, r=(\d+)/);
    return [+x, +y, +z, +r];
  });
  const strongestNanobot = nanobots.sort((a, b) => b[3] - a[3])[0];
  const [sx, sy, sz, sr] = strongestNanobot;
  const nanobotsInRange = nanobots.filter(([x, y, z]) => {
    return Math.abs(x - sx) + Math.abs(y - sy) + Math.abs(z - sz) <= sr;
  });
  return nanobotsInRange.length;
}

assert(
  nanobotsInRange(`pos=<0,0,0>, r=4
pos=<1,0,0>, r=1
pos=<4,0,0>, r=3
pos=<0,2,0>, r=1
pos=<0,5,0>, r=3
pos=<0,0,3>, r=1
pos=<1,1,1>, r=1
pos=<1,1,2>, r=1
pos=<1,3,1>, r=1`) === 7
);
if (process.argv[2]) console.log(nanobotsInRange(process.argv[2]));
