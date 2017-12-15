function * generator (start, factor, multiple) {
  let number = start

  while (true) {
    number = number * factor % 2147483647

    if (number % multiple === 0) {
      yield number
    }
  }
}

function duel (aStart, bStart) {
  const a = generator(aStart, 16807, 4)
  const b = generator(bStart, 48271, 8)
  let score = 0
  let rounds = 5e6

  while (rounds--) {
    const aValue = a.next().value & 0b1111111111111111
    const bValue = b.next().value & 0b1111111111111111

    if (!(aValue ^ bValue)) {
      score++
    }
  }

  return score
}

console.assert(duel(65, 8921) === 309)
console.log(duel(634, 301))
