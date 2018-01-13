function bridge (input) {
  const components = input.split('\n')
    .map(l => l.split('/').map(n => +n))
    .map(([p1, p2], id) => ({ id, p1, p2 }))
  const startComponents = components.filter(({ p1, p2 }) => p1 === 0 || p2 === 0)
  let longest = 0
  let longestStrongest = 0

  function * next (components, bridge, end) {
    const nextComponents = components.filter(({ id, p1, p2 }) => !bridge.some(bc => bc.id === id) &&
      (p1 === end || p2 === end))

    if (!nextComponents.length) {
      yield bridge
    }

    for (const nextComponent of nextComponents) {
      const nextEnd = nextComponent.p1 === end ? nextComponent.p2 : nextComponent.p1
      yield * next(components, [...bridge, nextComponent], nextEnd)
    }
  }

  for (const start of startComponents) {
    for (const bridge of next(components, [start], start.p1 === 0 ? start.p2 : start.p1)) {
      const strength = bridge.reduce((sum, c) => sum + c.p1 + c.p2, 0)
      const length = bridge.length

      if (longest < length) {
        longest = length
        longestStrongest = strength
      } else if (longest === length && longestStrongest < strength) {
        longestStrongest = strength
      }
    }
  }

  return longestStrongest
}

console.assert(bridge(
`0/2
2/2
2/3
3/4
3/5
0/1
10/1
9/10`
) === 19)

console.log(bridge(
`25/13
4/43
42/42
39/40
17/18
30/7
12/12
32/28
9/28
1/1
16/7
47/43
34/16
39/36
6/4
3/2
10/49
46/50
18/25
2/23
3/21
5/24
46/26
50/19
26/41
1/50
47/41
39/50
12/14
11/19
28/2
38/47
5/5
38/34
39/39
17/34
42/16
32/23
13/21
28/6
6/20
1/30
44/21
11/28
14/17
33/33
17/43
31/13
11/21
31/39
0/9
13/50
10/14
16/10
3/24
7/0
50/50`
))
