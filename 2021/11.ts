// https://adventofcode.com/2021/day/11
// Deno

type Position = [number, number];

class Octopus {
  flashed = false;
  flashCount = 0;

  constructor(public energyLevel: number, public position: Position) {}

  inc(): void {
    this.energyLevel += 1;
  }

  flash(): boolean {
    if (this.energyLevel > 9 && !this.flashed) {
      this.flashed = true;
      this.flashCount++;
      return true;
    }
    return false;
  }

  reset(): void {
    if (this.flashed) {
      this.energyLevel = 0;
    }
    this.flashed = false;
  }
}

class OctopusList {
  protected octopusMap = new Map<string, Octopus>();

  get all(): Octopus[] {
    return Array.from(this.octopusMap.values());
  }

  get flashable(): Octopus[] {
    return this.all.filter((o) => o.energyLevel > 9 && !o.flashed);
  }

  get totalFlashCount(): number {
    return this.all.reduce((sum, octopus) => sum + octopus.flashCount, 0);
  }

  get allFlashed(): boolean {
    return this.all.every((o) => o.flashed);
  }

  inc(): void {
    this.all.forEach((o) => o.inc());
  }

  incAdjacent({ position: [y, x] }: Octopus): void {
    return [
      [y - 1, x],
      [y - 1, x + 1],
      [y, x + 1],
      [y + 1, x + 1],
      [y + 1, x],
      [y + 1, x - 1],
      [y, x - 1],
      [y - 1, x - 1],
    ].forEach(([y, x]) => {
      const adjacent = this.octopusMap.get(`${y}_${x}`);
      adjacent?.inc();
      if (adjacent?.flash()) {
        this.incAdjacent(adjacent);
      }
    });
  }

  checkFlash(): void {
    this.flashable.forEach((o) => {
      if (o.flash()) {
        this.incAdjacent(o);
      }
    });
  }

  reset(): void {
    this.all.forEach((o) => o.reset());
  }

  static create(energyLevels: number[][]): OctopusList {
    const octopusList = new OctopusList();

    energyLevels.forEach((row, y) => {
      row.forEach((el, x) => {
        octopusList.octopusMap.set(`${y}_${x}`, new Octopus(el, [y, x]));
      });
    });

    return octopusList;
  }
}

// Part 1
function getTotalFlashCount(energyLevelInput: string[]): number {
  const octopusList = OctopusList.create(
    energyLevelInput.map((eli) => eli.split("").map((e) => +e))
  );

  for (let step = 1; step <= 100; step++) {
    octopusList.inc();
    octopusList.checkFlash();
    octopusList.reset();
  }

  return octopusList.totalFlashCount;
}

// Part 2
function getFirstSynchronizedStep(energyLevelInput: string[]): number {
  const octopusList = OctopusList.create(
    energyLevelInput.map((eli) => eli.split("").map((e) => +e))
  );

  for (let step = 1; ; step++) {
    octopusList.inc();
    octopusList.checkFlash();
    if (octopusList.allFlashed) {
      return step;
    }
    octopusList.reset();
  }
}

const testEnergyLevelInput = [
  "5483143223",
  "2745854711",
  "5264556173",
  "6141336146",
  "6357385478",
  "4167524645",
  "2176841721",
  "6882881134",
  "4846848554",
  "5283751526",
];
console.assert(
  getTotalFlashCount(testEnergyLevelInput) === 1656,
  "Part 1 failed"
);
console.assert(
  getFirstSynchronizedStep(testEnergyLevelInput) === 195,
  "Part 2 failed"
);

if (Deno.args[0]) {
  const energyLevelInput = Deno.args[0].split("\n");
  console.log(getTotalFlashCount(energyLevelInput));
  console.log(getFirstSynchronizedStep(energyLevelInput));
}
