// https://adventofcode.com/2020/day/22

// Part 1
function getWinningPlayerScoreForCombat(input) {
  const [deckP1, deckP2] = input.map((i) => i.split("\n").slice(1).map(Number));
  while (deckP1.length !== 0 && deckP2.length !== 0) {
    const cardP1 = deckP1.shift();
    const cardP2 = deckP2.shift();
    if (cardP1 > cardP2) {
      deckP1.push(cardP1, cardP2);
    } else {
      deckP2.push(cardP2, cardP1);
    }
  }
  return [...deckP1, ...deckP2].reduce(
    (score, card, idx, cards) => (cards.length - idx) * card + score,
    0
  );
}

// Part 2
function getWinningPlayerScoreForRecursiveCombat(input) {
  const [deckP1, deckP2] = input.map((i) => i.split("\n").slice(1).map(Number));

  function playGame(deckP1, deckP2, cardHistory = new Set()) {
    const deckP1Id = deckP1.toString();
    const deckP2Id = deckP2.toString();

    if (cardHistory.has(deckP1Id) || cardHistory.has(deckP2Id)) {
      return 1;
    }

    const cardP1 = deckP1.shift();
    const cardP2 = deckP2.shift();

    if (cardP1 <= deckP1.length && cardP2 <= deckP2.length) {
      const winner = playGame(deckP1.slice(0, cardP1), deckP2.slice(0, cardP2));
      if (winner === 1) {
        deckP1.push(cardP1, cardP2);
      } else {
        deckP2.push(cardP2, cardP1);
      }
    } else {
      if (cardP1 > cardP2) {
        deckP1.push(cardP1, cardP2);
      } else {
        deckP2.push(cardP2, cardP1);
      }
    }

    if (deckP1.length === 0) {
      return 2;
    } else if (deckP2.length === 0) {
      return 1;
    } else {
      return playGame(deckP1, deckP2, cardHistory.add(deckP1Id, deckP2Id));
    }
  }

  playGame(deckP1, deckP2);

  return [...deckP1, ...deckP2].reduce(
    (score, card, idx, cards) => (cards.length - idx) * card + score,
    0
  );
}

console.assert(
  getWinningPlayerScoreForCombat([
    `Player 1:
9
2
6
3
1`,

    `Player 2:
5
8
4
7
10`,
  ]) == 306,
  "Part 1 failed"
);
console.assert(
  getWinningPlayerScoreForRecursiveCombat([
    `Player 1:
9
2
6
3
1`,

    `Player 2:
5
8
4
7
10`,
  ]) == 291,
  "Part 2 failed"
);

if (process.argv[2]) {
  const input = process.argv[2].split("\n\n");
  console.log(getWinningPlayerScoreForCombat(input));
  console.log(getWinningPlayerScoreForRecursiveCombat(input));
}
