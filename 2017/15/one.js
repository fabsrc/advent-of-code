function * generator (start, factor) {
  let number = start

  while (true) {
    yield number = number * factor % 2147483647
  }
}

function duel (aStart, bStart) {
  const a = generator(aStart, 16807)
  const b = generator(bStart, 48271)
  let score = 0
  let rounds = 4e7

  while (rounds--) {
    const aValue = a.next().value & 0b1111111111111111
    const bValue = b.next().value & 0b1111111111111111

    if (!(aValue ^ bValue)) {
      score++
    }
  }

  return score
}

console.assert(duel(65, 8921) === 588)
console.log(duel(634, 301))
