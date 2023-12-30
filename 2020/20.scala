// https://adventofcode.com/2020/day/20

object AocDay20 {
  class Tile(val id: BigInt, var data: List[List[Char]]) {
    var orientation = 0
    var neighborTiles = Set[Tile]()
    var sharedBorders = Set[List[Char]]()

    def top = data.head
    def right = data.transpose.last
    def bottom = data.last
    def left = data.transpose.head

    def borders = Set(top, right, bottom, left)
    def flippedBorders = borders.map(_.reverse)
    def allBorders = borders ++ flippedBorders

    def rotate = {
      data = data.transpose.map(_.reverse)
    }

    def flip = {
      data = data.map(_.reverse)
    }

    def changeOrientation = {
      orientation match {
        case 4 => flip
        case _ => rotate
      }
      orientation += 1
      orientation %= 8
    }

    def dataWithoutBorder = {
      data.drop(1).dropRight(1).map(_.drop(1).dropRight(1))
    }
  }

  object Tile {
    def parse(rawData: String): Tile = {
      val first :: rest = rawData.linesIterator.toList
      val id = """\d+""".r.findFirstIn(first).get.toInt
      val data = rest.foldLeft(List[List[Char]]()) { case (arr, line) =>
        arr ++ List(line.toList)
      }
      new Tile(id, data)
    }

    def checkNeighbors(tiles: List[Tile]) = {
      tiles.combinations(2).foreach {
        case List(tile1, tile2) => {
          val sharedBorders = tile1.allBorders & tile2.allBorders
          if (sharedBorders.size > 0) {
            tile1.neighborTiles += tile2
            tile1.sharedBorders ++= sharedBorders
            tile2.neighborTiles += tile1
            tile2.sharedBorders ++= sharedBorders
          }
        }
        case _ =>
      }
    }
  }

  // Part 1
  def getChecksumOfCornerTiles(rawTileData: List[String]): BigInt = {
    val tiles = rawTileData.map(Tile.parse)
    Tile.checkNeighbors(tiles)
    tiles.filter(_.neighborTiles.size == 2).map(_.id).product
  }

  // Part 2
  def getWaterRoughness(rawTileData: List[String]): BigInt = {
    val tiles = rawTileData.map(Tile.parse)
    Tile.checkNeighbors(tiles)

    val gridSize = Math.sqrt(tiles.length).toInt
    val grid = Array.ofDim[Tile](gridSize, gridSize)

    tiles.find(tile => tile.neighborTiles.size == 2) match {
      case Some(firstTile) => {
        while (
          !Set(firstTile.right, firstTile.bottom).subsetOf(
            firstTile.sharedBorders
          )
        ) {
          firstTile.changeOrientation
        }
        var tile = firstTile
        grid(0)(0) = tile

        for (x <- 1 until gridSize) {
          tile.neighborTiles.find(_.sharedBorders.contains(tile.right)) match {
            case Some(neighborTile) => {
              while (neighborTile.left != tile.right) {
                neighborTile.changeOrientation
              }
              grid(0)(x) = neighborTile
              tile = neighborTile
            }
            case None =>
          }
        }
      }
      case None =>
    }

    for (y <- 1 until gridSize) {
      for (x <- 0 until gridSize) {
        val tile = grid(y - 1)(x)
        tile.neighborTiles.find(_.sharedBorders.contains(tile.bottom)) match {
          case Some(neighborTile) => {
            while (neighborTile.top != tile.bottom) {
              neighborTile.changeOrientation
            }
            grid(y)(x) = neighborTile
          }
          case None =>
        }
      }
    }

    val imageSize = grid.length * (grid(0)(0).dataWithoutBorder.length)
    val image = Array.ofDim[Char](imageSize, imageSize)

    for (x <- 0 to grid.length - 1) {
      for (y <- 0 to grid.length - 1) {
        val tile = grid(y)(x)
        tile.dataWithoutBorder.zipWithIndex.foreach {
          case (row, ty) => {
            row.zipWithIndex.foreach {
              case (char, tx) => {
                image(ty + y * row.length)(tx + x * row.length) = char
              }
            }
          }
        }
      }
    }

    val imageTile = new Tile(0, image.map(_.toList).toList)
    val monsterRe =
      f"(?m)(..................#.\n#....##....##....###\n.#..#..#..#..#..#...)".r

    for (_ <- 0 until 8) {
      (0 to image.size - 20).foldLeft(0) { (numberOfMonsters, i) =>
        {
          val searchStr = (
            imageTile.data.map(row => row.mkString.substring(i, i + 20))
          ).mkString("\n")
          numberOfMonsters + monsterRe.findAllIn(searchStr).size
        }
      } match {
        case numberOfMonsters if numberOfMonsters > 0 => {
          return imageTile.data.flatten.count(
            _ == '#'
          ) - numberOfMonsters * monsterRe.toString.count(_ == '#')
        }
        case _ => imageTile.changeOrientation
      }
    }

    0
  }

  def main(args: Array[String]): Unit = {
    assert(
      getChecksumOfCornerTiles(
        List(
          """Tile 2311:
..##.#..#.
##..#.....
#...##..#.
####.#...#
##.##.###.
##...#.###
.#.#.#..##
..#....#..
###...#.#.
..###..###""",
          """Tile 1951:
#.##...##.
#.####...#
.....#..##
#...######
.##.#....#
.###.#####
###.##.##.
.###....#.
..#.#..#.#
#...##.#..""",
          """Tile 1171:
####...##.
#..##.#..#
##.#..#.#.
.###.####.
..###.####
.##....##.
.#...####.
#.##.####.
####..#...
.....##...""",
          """Tile 1427:
###.##.#..
.#..#.##..
.#.##.#..#
#.#.#.##.#
....#...##
...##..##.
...#.#####
.#.####.#.
..#..###.#
..##.#..#.""",
          """Tile 1489:
##.#.#....
..##...#..
.##..##...
..#...#...
#####...#.
#..#.#.#.#
...#.#.#..
##.#...##.
..##.##.##
###.##.#..""",
          """Tile 2473:
#....####.
#..#.##...
#.##..#...
######.#.#
.#...#.#.#
.#########
.###.#..#.
########.#
##...##.#.
..###.#.#.""",
          """Tile 2971:
..#.#....#
#...###...
#.#.###...
##.##..#..
.#####..##
.#..####.#
#..#.#..#.
..####.###
..#.#.###.
...#.#.#.#""",
          """Tile 2729:
...#.#.#.#
####.#....
..#.#.....
....#..#.#
.##..##.#.
.#.####...
####.#.#..
##.####...
##..#.##..
#.##...##.""",
          """Tile 3079:
#.#.#####.
.#..######
..#.......
######....
####.#..#.
.#...#.##.
#.#####.##
..#.###...
..#.......
..#.###..."""
        )
      ) == BigInt("20899048083289"),
      "Part 1 failed"
    )

    assert(
      getWaterRoughness(
        List(
          """Tile 2311:
..##.#..#.
##..#.....
#...##..#.
####.#...#
##.##.###.
##...#.###
.#.#.#..##
..#....#..
###...#.#.
..###..###""",
          """Tile 1951:
#.##...##.
#.####...#
.....#..##
#...######
.##.#....#
.###.#####
###.##.##.
.###....#.
..#.#..#.#
#...##.#..""",
          """Tile 1171:
####...##.
#..##.#..#
##.#..#.#.
.###.####.
..###.####
.##....##.
.#...####.
#.##.####.
####..#...
.....##...""",
          """Tile 1427:
###.##.#..
.#..#.##..
.#.##.#..#
#.#.#.##.#
....#...##
...##..##.
...#.#####
.#.####.#.
..#..###.#
..##.#..#.""",
          """Tile 1489:
##.#.#....
..##...#..
.##..##...
..#...#...
#####...#.
#..#.#.#.#
...#.#.#..
##.#...##.
..##.##.##
###.##.#..""",
          """Tile 2473:
#....####.
#..#.##...
#.##..#...
######.#.#
.#...#.#.#
.#########
.###.#..#.
########.#
##...##.#.
..###.#.#.""",
          """Tile 2971:
..#.#....#
#...###...
#.#.###...
##.##..#..
.#####..##
.#..####.#
#..#.#..#.
..####.###
..#.#.###.
...#.#.#.#""",
          """Tile 2729:
...#.#.#.#
####.#....
..#.#.....
....#..#.#
.##..##.#.
.#.####...
####.#.#..
##.####...
##..#.##..
#.##...##.""",
          """Tile 3079:
#.#.#####.
.#..######
..#.......
######....
####.#..#.
.#...#.##.
#.#####.##
..#.###...
..#.......
..#.###..."""
        )
      ) == 273,
      "Part 2 failed"
    )

    args.lift(0) match {
      case Some(input) =>
        input.split("\n\n").toList match {
          case tiles => {
            println(getChecksumOfCornerTiles(tiles))
            println(getWaterRoughness(tiles))
          }
        }
      case None =>
    }
  }
}
