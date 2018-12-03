const assert = require('assert')

function countOverlaps (input) {
  const area = input
    .split('\n')
    .map(line => line
      .match(/#\d+\s@\s(\d+),(\d+):\s(\d+)x(\d+)/)
      .map(Number)
    )
    .reduce((acc, [, left, top, width, height]) => {
      for (let i = top; i < height + top; i++) {
        for (let j = left; j < width + left; j++) {
          acc[`${i},${j}`] = acc[`${i},${j}`] ? acc[`${i},${j}`] + 1 : 1
        }
      }
      return acc
    }, {})

  return Object.values(area).filter(claims => claims > 1).length
}

assert(countOverlaps('#1 @ 1,3: 4x4\n#2 @ 3,1: 4x4\n#3 @ 5,5: 2x2') === 4)
if (process.argv[2]) console.log(countOverlaps(process.argv[2]))
