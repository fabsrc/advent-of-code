const assert = require('assert')

function orderSteps (input) {
  const steps = {}
  input
    .split('\n')
    .map(line => line.match(/ ([A-Z]) .* ([A-Z]) /))
    .forEach(matches => {
      steps[matches[1]] = steps[matches[1]] || []
      steps[matches[2]] = steps[matches[2]] || []
      steps[matches[2]].push(matches[1])
    })
  let stepsToOrder = Object.keys(steps).sort()
  let orderOfSteps = ''

  while (stepsToOrder.length) {
    for (const currentStep of stepsToOrder) {
      if (steps[currentStep].every(req => orderOfSteps.includes(req))) {
        orderOfSteps += currentStep
        stepsToOrder = stepsToOrder.filter(s => s !== currentStep)
        break
      }
    }
  }

  return orderOfSteps
}

assert(orderSteps(`Step C must be finished before step A can begin.
Step C must be finished before step F can begin.
Step A must be finished before step B can begin.
Step A must be finished before step D can begin.
Step B must be finished before step E can begin.
Step D must be finished before step E can begin.
Step F must be finished before step E can begin.`) === 'CABDFE')
if (process.argv[2]) console.log(orderSteps(process.argv[2]))
