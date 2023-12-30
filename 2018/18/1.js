const assert = require('assert')

function lumberCollectionArea (input) {
  let area = input.split('\n').map(line => line.split(''))

  function checkAdjacentAcres (x, y, type, amount) {
    return [
      (area[y] || [])[x - 1],
      (area[y + 1] || [])[x - 1],
      (area[y + 1] || [])[x],
      (area[y + 1] || [])[x + 1],
      (area[y] || [])[x + 1],
      (area[y - 1] || [])[x + 1],
      (area[y - 1] || [])[x],
      (area[y - 1] || [])[x - 1]
    ].filter(acre => acre === type).length >= amount
  }

  for (let i = 0; i < 10; i++) {
    area = area.map((row, y) => {
      return row.map((acre, x) => {
        if (acre === '.') {
          return checkAdjacentAcres(x, y, '|', 3) ? '|' : acre
        } else if (acre === '|') {
          return checkAdjacentAcres(x, y, '#', 3) ? '#' : acre
        } else if (acre === '#') {
          return checkAdjacentAcres(x, y, '#', 1) && checkAdjacentAcres(x, y, '|', 1) ? '#' : '.'
        }
      })
    })
  }

  area = [].concat.apply([], area)
  return area.filter(acre => acre === '#').length * area.filter(acre => acre === '|').length
}

assert(lumberCollectionArea(`.#.#...|#.
.....#|##|
.|..|...#.
..|#.....#
#.#|||#|#|
...#.||...
.|....|...
||...#|.#|
|.||||..|.
...#.|..|.`) === 1147)
if (process.argv[2]) console.log(lumberCollectionArea(process.argv[2]))
