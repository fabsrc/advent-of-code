const assert = require('assert')

function findFuelCell (input) {
  const grid = []

  for (let x = 1; x <= 300; x++) {
    grid[x] = []
    for (let y = 1; y <= 300; y++) {
      const rackId = x + 10
      let powerLevel = (rackId * y) + +input
      powerLevel *= rackId
      powerLevel = String(powerLevel).split('').reverse()[2] || 0
      grid[x][y] = +powerLevel - 5
    }
  }

  let largest = [0, '']

  for (let x = 1; x <= 300 - 3; x++) {
    for (let y = 1; y <= 300 - 3; y++) {
      let cellPower =
        grid[x][y] + grid[x + 1][y] + grid[x + 2][y] +
        grid[x][y + 1] + grid[x + 1][y + 1] + grid[x + 2][y + 1] +
        grid[x][y + 2] + grid[x + 1][y + 2] + grid[x + 2][y + 2]

      if (cellPower > largest[0]) {
        largest = [cellPower, `${x},${y}`]
      }
    }
  }

  return largest[1]
}

assert(findFuelCell(18) === '33,45')
assert(findFuelCell(42) === '21,61')
if (process.argv[2]) console.log(findFuelCell(process.argv[2]))
