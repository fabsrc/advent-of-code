function lumberCollectionArea (input) {
  const woodenResourceValues = []
  const flattenedAreas = []
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

  for (let i = 0; i < 1000000000; i++) {
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
    const flattenedArea = [].concat.apply([], area)
    const flattenedAreaString = flattenedArea.toString()
    woodenResourceValues.push(
      flattenedArea.filter(acre => acre === '#').length *
      flattenedArea.filter(acre => acre === '|').length
    )
    const indexOfRepeatingArea = flattenedAreas.indexOf(flattenedAreaString)
    if (indexOfRepeatingArea > -1) {
      const cycle = woodenResourceValues.slice(indexOfRepeatingArea, i)
      return cycle[(1000000000 - 1 - indexOfRepeatingArea) % cycle.length]
    }
    flattenedAreas.push(flattenedAreaString)
  }
}

if (process.argv[2]) console.log(lumberCollectionArea(process.argv[2]))
