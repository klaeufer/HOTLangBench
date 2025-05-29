object Day5:

  val number = """(\d+)""".r

  def makeSeq(input: Iterator[String]): Seq[Long] =
    val list = number.findAllIn(input.next()).map(_.toLong).toSeq
    input.next() // skip blank line
    list

  def makeMap(input: Iterator[String]): Option[Long => Long] =
    Option.when(input.hasNext):
      input.next() // skip section header
      val ranges = input
        .takeWhile(_.trim.nn.nonEmpty)
        .map: line =>
          val numbers = number.findAllIn(line).map(_.toLong)
          (numbers.next(), numbers.next(), numbers.next())
        .toSeq

      i => ranges
//        .find((_, s, l) => (s until s + l).contains(i)) // faster?
        .find((_, s, l) => s <= i && i < s + l) // slower?
        .map((b, s, _) => b + i - s)
        .getOrElse(i)

  def process(input: Iterator[String]) =
    val seeds = makeSeq(input)
    val seedToLocation = Iterator
      .continually(makeMap(input))
      .takeWhile(_.nonEmpty)
      .map(_.get)
      .reduce((f, g) => g.compose(f))
    val part1 = seeds.map(seedToLocation).min
    val part2 = seeds
      .sliding(2, 2).map: p =>
//        (p.head until p.head + p.last)
        Iterator.range(p.head, p.head + p.last)
          .map(seedToLocation)
          .min
      .min
    (part1, part2)

  def main(args: Array[String]): Unit =
    val input = scala.io.Source.stdin.getLines()
    println(process(input))
