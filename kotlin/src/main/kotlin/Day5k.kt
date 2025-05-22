import kotlin.sequences.sequence

object Day5k {
    @JvmStatic
    fun main(args: Array<String>) {
        println(process(input()))
    }

    val number = """(\d+)""".toRegex()

    fun makeSeq(input: Iterator<String>): List<Long> {
        val list = number.findAll(input.next()).map { it.value.toLong() }.toList()
        input.next() // skip blank line
        return list
    }

    fun makeMap(input: Iterator<String>): ((Long) -> Long)? =
        if (input.hasNext()) {
            input.next() // skip section header
            val ranges = input.asSequence()
                .takeWhile { it.trim().isNotEmpty() }
                .map { line ->
                    val numbers = number.findAll(line).map { it.value.toLong() }
                    Triple(numbers.elementAt(0), numbers.elementAt(1), numbers.elementAt(2))
                }
                .toList()
            ;
            { i: Long ->
                ranges
                    .find { (_, s, l) -> (s until s + l).contains(i) } // more performant?
//                    .find { (_, s, l) -> s <= i && i < s + l } // 500 MB -> 3 GB over 30 sec
                    .let { if (it != null) it.first + i - it.second else i }
            }
        } else null

    fun process(input: Iterator<String>): Pair<Long, Long> {
        val seeds = makeSeq(input)
        val seedToLocation = generateSequence { makeMap(input) }.reduce { f, g -> { g(f(it)) } }
        val part1 = seeds.map(seedToLocation).minOrNull() ?: 0
        val part2 = seeds.windowed(2, 2).map { p ->
            (p.first() until p.first() + p.last()).map(seedToLocation).minOrNull() ?: 0
        }.minOrNull() ?: 0
        return Pair(part1, part2)
    }

    fun input() = generateSequence(::readlnOrNull).iterator()
}