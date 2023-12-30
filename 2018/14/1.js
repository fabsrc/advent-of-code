const assert = require('assert')

function recipeScore (input) {
  const offset = Number(input)
  let recipes = '37'
  let elveOneIndex = 0
  let elveTwoIndex = 1

  while (recipes.length < offset + 10) {
    const newRecipe = +recipes[elveOneIndex] + +recipes[elveTwoIndex]
    recipes += newRecipe
    elveOneIndex = (elveOneIndex + 1 + +recipes[elveOneIndex]) % recipes.length
    elveTwoIndex = (elveTwoIndex + 1 + +recipes[elveTwoIndex]) % recipes.length
  }

  return recipes.slice(offset, offset + 10)
}

assert(recipeScore('9') === '5158916779')
assert(recipeScore('5') === '0124515891')
assert(recipeScore('18') === '9251071085')
assert(recipeScore('2018') === '5941429882')
if (process.argv[2]) console.log(recipeScore(process.argv[2]))
