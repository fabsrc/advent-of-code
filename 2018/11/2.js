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

  for (let s = 1; s <= 300; s++) {
    for (let x = 1; x <= 300 - s; x++) {
      for (let y = 1; y <= 300 - s; y++) {
        let cellPower = 0

        for (let i = 0; i < s; i++) {
          for (let j = 0; j < s; j++) {
            cellPower += grid[x + i][y + j]
          }
        }

        if (cellPower > largest[0]) {
          largest = [cellPower, `${x},${y},${s}`]
        }
      }
    }
  }

  return largest[1]
}

assert(findFuelCell(18) === '90,269,16')
assert(findFuelCell(42) === '232,251,12')
if (process.argv[2]) console.log(findFuelCell(process.argv[2]))
