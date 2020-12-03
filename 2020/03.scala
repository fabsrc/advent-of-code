// https://adventofcode.com/2020/day/3

object AocDay3 {
  // Part 1
  def countTrees(
      rows: List[String],
      slopePattern: (Int, Int) = (3, 1)
  ): Long = {
    val (rightInc, downInc) = slopePattern
    var steps = 0

    rows
      .map(LazyList.continually(_).flatten)
      .zipWithIndex
      .map {
        case (row, rowNumber) if (rowNumber % downInc == 0) => {
          row.apply(steps * rightInc) match {
            case location => {
              steps += 1
              location match {
                case '#' => 1
                case _   => 0
              }
            }
          }
        }
        case _ => 0
      }
      .sum
  }

  // Part 2
  def countTreesForMultipleSlopes(rows: List[String]): Long = {
    List((1, 1), (3, 1), (5, 1), (7, 1), (1, 2))
      .map(countTrees(rows, _))
      .product
  }

  def main(args: Array[String]): Unit = {
    assert(
      countTrees(
        List(
          "..##.......",
          "#...#...#..",
          ".#....#..#.",
          "..#.#...#.#",
          ".#...##..#.",
          "..#.##.....",
          ".#.#.#....#",
          ".#........#",
          "#.##...#...",
          "#...##....#",
          ".#..#...#.#"
        )
      ) == 7,
      "Part 1 failed"
    )
    assert(
      countTreesForMultipleSlopes(
        List(
          "..##.......",
          "#...#...#..",
          ".#....#..#.",
          "..#.#...#.#",
          ".#...##..#.",
          "..#.##.....",
          ".#.#.#....#",
          ".#........#",
          "#.##...#...",
          "#...##....#",
          ".#..#...#.#"
        )
      ) == 336,
      "Part 2 failed"
    )

    args.lift(0) match {
      case Some(input) =>
        input.split('\n').toList match {
          case list => {
            println(countTrees(list))
            println(countTreesForMultipleSlopes(list))
          }
        }
      case None =>
    }
  }
}
