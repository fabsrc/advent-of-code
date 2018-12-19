const assert = require('assert')

function recipesToTheLeft (input) {
  const pattern = input.split('').map(Number)
  const recipes = [3, 7]
  let elveOneIndex = 0
  let elveTwoIndex = 1
  let currentPatternIndex = 0

  while (true) {
    const newRecipe = recipes[elveOneIndex] + recipes[elveTwoIndex]
    const newRecipeArr = newRecipe > 9 ? [1, newRecipe % 10] : [newRecipe]

    for (const recipe of newRecipeArr) {
      recipes.push(recipe)

      if (
        recipe === pattern[currentPatternIndex] ||
        recipe === pattern[currentPatternIndex = 0]
      ) {
        currentPatternIndex++
        if (currentPatternIndex === pattern.length) {
          return recipes.length - pattern.length
        }
      }
    }

    elveOneIndex = (elveOneIndex + 1 + recipes[elveOneIndex]) % recipes.length
    elveTwoIndex = (elveTwoIndex + 1 + recipes[elveTwoIndex]) % recipes.length
  }
}

assert(recipesToTheLeft('51589') === 9)
assert(recipesToTheLeft('01245') === 5)
assert(recipesToTheLeft('92510') === 18)
assert(recipesToTheLeft('59414') === 2018)
if (process.argv[2]) console.log(recipesToTheLeft(process.argv[2]))
