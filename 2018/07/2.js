const assert = require('assert')

function getConstructionTime (input, timePerStep, numberOfWorkers) {
  const steps = {}
  input
    .split('\n')
    .map(line => line.match(/ ([A-Z]) .* ([A-Z]) /))
    .forEach(matches => {
      steps[matches[1]] = steps[matches[1]] || []
      steps[matches[2]] = steps[matches[2]] || []
      steps[matches[2]].push(matches[1])
    })
  const finishedSteps = []
  const workers = []
  let stepsToDo = Object.keys(steps).sort()
  let totalTime = 0

  do {
    workers.forEach((worker, i) => {
      if (worker.endTime <= totalTime) {
        finishedSteps.push(worker.step)
        stepsToDo = stepsToDo.filter(s => s !== worker.step)
        workers.splice(i, 1)
      }
    })

    if (stepsToDo.length === 0) {
      return totalTime
    }

    for (const currentStep of stepsToDo) {
      if (
        workers.length < numberOfWorkers &&
        workers.every(w => w.step !== currentStep) &&
        steps[currentStep].every(req => finishedSteps.includes(req))
      ) {
        workers.push({
          step: currentStep,
          endTime: totalTime + timePerStep + currentStep.charCodeAt() - 64
        })
      }
    }
  } while (++totalTime)
}

assert(getConstructionTime(`Step C must be finished before step A can begin.
Step C must be finished before step F can begin.
Step A must be finished before step B can begin.
Step A must be finished before step D can begin.
Step B must be finished before step E can begin.
Step D must be finished before step E can begin.
Step F must be finished before step E can begin.`, 0, 2) === 15)
if (process.argv[2]) console.log(getConstructionTime(process.argv[2], 60, 5))
