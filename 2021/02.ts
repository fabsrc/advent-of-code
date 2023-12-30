// https://adventofcode.com/2021/day/2
// Deno

// Part 1
function getPosition(commands: string[]): number {
  let [hPos, depth] = [0, 0];

  commands.forEach((command) => {
    const [direction, value] = command.split(" ");
    const valueInt = +value;

    switch (direction) {
      case "forward":
        hPos += valueInt;
        break;
      case "up":
        depth -= valueInt;
        break;
      case "down":
        depth += valueInt;
        break;
    }
  });

  return hPos * depth;
}

// Part 2
function getPositionWithAim(commands: string[]): number {
  let [hPos, depth, aim] = [0, 0, 0];

  commands.forEach((command) => {
    const [direction, value] = command.split(" ");
    const valueInt = +value;

    switch (direction) {
      case "forward":
        hPos += valueInt;
        depth += aim * valueInt;
        break;
      case "up":
        aim -= valueInt;
        break;
      case "down":
        aim += valueInt;
        break;
    }
  });

  return hPos * depth;
}

const testCommands = [
  "forward 5",
  "down 5",
  "forward 8",
  "up 3",
  "down 8",
  "forward 2",
];
console.assert(getPosition(testCommands) === 150, "Part 1 failed");
console.assert(getPositionWithAim(testCommands) === 900, "Part 2 failed");

if (Deno.args[0]) {
  const commands = Deno.args[0].split("\n");
  console.log(getPosition(commands));
  console.log(getPositionWithAim(commands));
}
