const assert = require('assert')

const manhattanDistance = (p1, p2 = []) =>
  p1.reduce((sum, c, i) => sum + Math.abs(c - (p2[i] || 0)), 0)

function largestNumberOfNanobots (input) {
  const nanobots = input.split('\n').map(line => {
    const [, x, y, z, r] = line.match(/<(-?\d+),(-?\d+),(-?\d+)>, r=(\d+)/)
    return [+x, +y, +z, +r]
  })

  const maxPower = Math.floor(Math.log2(Math.max(...nanobots.flat())))
  const divisor = 2

  let multi = 2 ** maxPower
  let xRange = [0, 0]
  let yRange = [0, 0]
  let zRange = [0, 0]

  do {
    const currentNanobots = nanobots.map(bot =>
      bot.map(b => Math.floor(b / multi))
    )
    let currentBest = [0, 0, 0, 0]

    for (let x = xRange[0]; x <= xRange[1]; x++) {
      for (let y = yRange[0]; y <= yRange[1]; y++) {
        for (let z = zRange[0]; z <= zRange[1]; z++) {
          const nanobotsInRange = currentNanobots.filter(
            ([bx, by, bz, br]) =>
              manhattanDistance([bx, by, bz], [x, y, z]) <= br
          ).length
          const [bestX, bestY, bestZ, bestNanobotsInRange] = currentBest

          if (
            nanobotsInRange > bestNanobotsInRange ||
            (nanobotsInRange === bestNanobotsInRange &&
              manhattanDistance([x, y, z]) <
                manhattanDistance([bestX, bestY, bestZ]))
          ) {
            currentBest = [x, y, z, nanobotsInRange]
          }
        }
      }
    }

    const [bestX, bestY, bestZ] = currentBest

    if (multi === 1) {
      return manhattanDistance([bestX, bestY, bestZ])
    }

    xRange = [(bestX - 1) * divisor, (bestX + 1) * divisor]
    yRange = [(bestY - 1) * divisor, (bestY + 1) * divisor]
    zRange = [(bestZ - 1) * divisor, (bestZ + 1) * divisor]
  } while ((multi /= divisor) > 0)
}

assert(
  largestNumberOfNanobots(`pos=<10,12,12>, r=2
pos=<12,14,12>, r=2
pos=<16,12,12>, r=4
pos=<14,14,14>, r=6
pos=<50,50,50>, r=200
pos=<10,10,10>, r=5`) === 36
)
if (process.argv[2]) console.log(largestNumberOfNanobots(process.argv[2]))
