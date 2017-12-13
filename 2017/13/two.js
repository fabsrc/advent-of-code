function firewall (input) {
  const lines = input.split('\n')
  const layers = lines.map(line => line.split(': ').map(Number))
  let delay = 0

  while (true) {
    let detected = false

    for (const [time, range] of layers) {
      const r = range - 1
      const position = r - (delay + time) % (2 * r) - r

      if (position === 0) {
        detected = true
        break
      }
    }

    if (!detected) {
      return delay
    }

    delay++
  }
}

console.assert(firewall(`0: 3
1: 2
4: 4
6: 4`) === 10)

console.log(firewall(`0: 3
1: 2
2: 6
4: 4
6: 4
8: 8
10: 9
12: 8
14: 5
16: 6
18: 8
20: 6
22: 12
24: 6
26: 12
28: 8
30: 8
32: 10
34: 12
36: 12
38: 8
40: 12
42: 12
44: 14
46: 12
48: 14
50: 12
52: 12
54: 12
56: 10
58: 14
60: 14
62: 14
64: 14
66: 17
68: 14
72: 14
76: 14
80: 14
82: 14
88: 18
92: 14
98: 18`))
