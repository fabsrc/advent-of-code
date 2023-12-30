// https://adventofcode.com/2020/day/12

object AocDay12 {
  sealed abstract class Direction(val xStep: Int, val yStep: Int) {
    def turn(degrees: Int): Direction = degrees match {
      case 90         => Direction.next(this)
      case n if n > 0 => Direction.next(this.turn(n - 90))
      case -90        => Direction.previous(this)
      case n if n < 0 => Direction.previous(this.turn(n + 90))
    }
  }

  case object North extends Direction(0, 1)
  case object East extends Direction(1, 0)
  case object South extends Direction(0, -1)
  case object West extends Direction(-1, 0)

  object Direction {
    val Clockwise = Vector[Direction](North, East, South, West)
    private val next = Clockwise.zip(Clockwise.tail ++ Clockwise.init).toMap
    private val previous = this.next.map(_.swap)
  }

  class Waypoint(var x: Int = 10, var y: Int = 1) {
    def rotate(degrees: Int) = {
      val radians = Math.toRadians(degrees)
      val Seq(newX, newY) = Seq(
        x * Math.cos(radians) + y * Math.sin(radians),
        -x * Math.sin(radians) + y * Math.cos(radians),
      ).map(_.round.toInt)
      x = newX
      y = newY
    }
  }

  class Ferry(var x: Int = 0, var y: Int = 0) {
    def manhattanDistance = x.abs + y.abs

    private var direction: Direction = East

    def move(action: String): Unit = action match {
      case s"F$value" => {
        x += direction.xStep * value.toInt
        y += direction.yStep * value.toInt
      }
      case s"N$value" => y += value.toInt
      case s"S$value" => y -= value.toInt
      case s"E$value" => x += value.toInt
      case s"W$value" => x -= value.toInt
      case s"L$value" => direction = direction.turn(-value.toInt)
      case s"R$value" => direction = direction.turn(value.toInt)
      case _          =>
    }

    private val waypoint = new Waypoint

    def moveWithWaypoint(action: String): Unit = action match {
      case s"F$value" => {
        x += waypoint.x * value.toInt
        y += waypoint.y * value.toInt
      }
      case s"N$value" => waypoint.y += value.toInt
      case s"S$value" => waypoint.y -= value.toInt
      case s"E$value" => waypoint.x += value.toInt
      case s"W$value" => waypoint.x -= value.toInt
      case s"L$value" => waypoint.rotate(-value.toInt)
      case s"R$value" => waypoint.rotate(value.toInt)
      case _          =>
    }
  }

  // Part 1
  def getManhattanDistance(actions: List[String]): Int = {
    val ferry = new Ferry
    actions.foreach(ferry.move)
    ferry.manhattanDistance
  }

  // Part 2
  def getManhattanDistanceWithWaypoint(actions: List[String]): Int = {
    val ferry = new Ferry
    actions.foreach(ferry.moveWithWaypoint)
    ferry.manhattanDistance
  }

  def main(args: Array[String]): Unit = {
    assert(
      getManhattanDistance(
        List(
          "F10",
          "N3",
          "F7",
          "R90",
          "F11"
        )
      ) == 25,
      "Part 1 failed"
    )
    assert(
      getManhattanDistanceWithWaypoint(
        List(
          "F10",
          "N3",
          "F7",
          "R90",
          "F11"
        )
      ) == 286,
      "Part 2 failed"
    )

    args.lift(0) match {
      case Some(input) =>
        input.split('\n').toList match {
          case list => {
            println(getManhattanDistance(list))
            println(getManhattanDistanceWithWaypoint(list))
          }
        }
      case None =>
    }
  }
}
