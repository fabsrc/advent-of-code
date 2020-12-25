// https://adventofcode.com/2020/day/25

object AocDay25 {
  // Part 1
  def getEncryptionKey(publicKeysInput: List[String]): BigInt = {
    publicKeysInput
      .map(BigInt(_))
      .map(publicKey => {
        var loops = 0
        var value = 1
        while (value != publicKey) {
          value *= 7
          value %= 20201227
          loops += 1
        }
        (publicKey, loops)
      }) match {
      case List(
            (cardPublicKey, cardLoopSize),
            (doorPublicKey, doorLoopSize)
          ) => {
        1.to(doorLoopSize).foldLeft(BigInt(1)) { (key, _) =>
          key * cardPublicKey % 20201227
        }
      }
      case _ => 0
    }
  }

  def main(args: Array[String]): Unit = {
    assert(
      getEncryptionKey(
        List(
          "5764801",
          "17807724"
        )
      ) == 14897079,
      "Part 1 failed"
    )

    args.lift(0) match {
      case Some(input) =>
        input.split('\n').toList match {
          case lines => {
            println(getEncryptionKey(lines))
          }
        }
      case None =>
    }
  }
}
