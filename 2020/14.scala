// https://adventofcode.com/2020/day/14

object AocDay14 {
  // Part 1
  def getSumFromMemoryValues(lines: List[String]): BigInt = {
    lines
      .foldLeft(("", Map.empty[String, BigInt])) {
        case ((currentMask, mem), line) => {
          line match {
            case s"mask = $mask" => (mask, mem)
            case s"mem[$address] = $value" => {
              val zeroMask = currentMask.replaceAll("[X1]", "1")
              val oneMask = currentMask.replaceAll("[X0]", "0")
              val maskedValue =
                (BigInt(value) | BigInt(oneMask, 2)) & BigInt(zeroMask, 2)
              (currentMask, mem + (address -> maskedValue))
            }
          }
        }
      }
      ._2
      .values
      .sum
  }

  // Part 2
  def getSumFromMemoryValuesV2(lines: List[String]): BigInt = {
    lines
      .foldLeft(("", Map.empty[String, BigInt])) {
        case ((currentMask, mem), line) => {
          line match {
            case s"mask = $mask" => (mask, mem)
            case s"mem[$address] = $value" => {
              val floatingBitCount = currentMask.count(_ == 'X')
              val addressAfterBitMask = currentMask
                .zip(
                  String.format("%036d", address.toInt.toBinaryString.toLong)
                )
                .map {
                  case ('1', _) => '1'
                  case ('X', _) => 'X'
                  case (_, c)   => c
                }
                .toString
              val newMem = Seq
                .fill(floatingBitCount)(0 to 1)
                .flatten
                .combinations(floatingBitCount)
                .flatMap(_.permutations)
                .map(
                  _.foldLeft(addressAfterBitMask) { (cur, r) =>
                    cur.replaceFirst("X", r.toString)
                  }
                )
                .map((_ -> BigInt(value)))
                .toMap

              (currentMask, mem ++ newMem)
            }
          }
        }
      }
      ._2
      .values
      .sum
  }

  def main(args: Array[String]): Unit = {
    assert(
      getSumFromMemoryValues(
        List(
          "mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X",
          "mem[8] = 11",
          "mem[7] = 101",
          "mem[8] = 0"
        )
      ) == 165,
      "Part 1 failed"
    )
    assert(
      getSumFromMemoryValuesV2(
        List(
          "mask = 000000000000000000000000000000X1001X",
          "mem[42] = 100",
          "mask = 00000000000000000000000000000000X0XX",
          "mem[26] = 1"
        )
      ) == 208,
      "Part 2 failed"
    )

    args.lift(0) match {
      case Some(input) =>
        input.split('\n').toList match {
          case lines => {
            println(getSumFromMemoryValues(lines))
            println(getSumFromMemoryValuesV2(lines))
          }
        }
      case None =>
    }
  }
}
