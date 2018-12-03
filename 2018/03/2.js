const assert = require('assert')

function findIntactClaimId (input) {
  const area = {}
  let ids = []

  input
    .split('\n')
    .map(line => line
      .match(/#(\d+)\s@\s(\d+),(\d+):\s(\d+)x(\d+)/)
      .map(Number)
    )
    .forEach(([, id, left, top, width, height]) => {
      ids.push(id)

      for (let i = top; i < height + top; i++) {
        for (let j = left; j < width + left; j++) {
          if (!area[`${i},${j}`]) {
            area[`${i},${j}`] = []
          }

          area[`${i},${j}`].push(id)
        }
      }
    })

  Object.values(area).forEach(claimIds => {
    if (claimIds.length > 1) {
      claimIds.forEach(claimId => {
        ids = ids.filter(id => claimId !== id)
      })
    }
  })

  return ids[0]
}

assert(findIntactClaimId('#1 @ 1,3: 4x4\n#2 @ 3,1: 4x4\n#3 @ 5,5: 2x2') === 3)
if (process.argv[2]) console.log(findIntactClaimId(process.argv[2]))
