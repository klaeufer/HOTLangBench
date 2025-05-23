import Foundation

struct Day5 {
    static let numberPattern = try! NSRegularExpression(pattern: #"(\d+)"#)
    
    static func makeSeq(from input: inout IndexingIterator<[String]>) -> [Int] {
        guard let line = input.next() else { return [] }
        let numbers = extractNumbers(from: line)
        _ = input.next() // skip blank line
        return numbers
    }
    
    static func makeMap(from input: inout IndexingIterator<[String]>) -> ((Int) -> Int)? {
        guard let _ = input.next() else { return nil } // skip section header if available
        
        var ranges: [(dest: Int, source: Int, length: Int)] = []
        
        while let line = input.next(), !line.trimmingCharacters(in: .whitespaces).isEmpty {
            let numbers = extractNumbers(from: line)
            if numbers.count >= 3 {
                ranges.append((dest: numbers[0], source: numbers[1], length: numbers[2]))
            }
        }
        
        return { i in
            for range in ranges {
                if (range.source..<range.source + range.length).contains(i) {
                    return range.dest + i - range.source
                }
            }
            return i
        }
    }
    
    static func extractNumbers(from string: String) -> [Int] {
        let matches = numberPattern.matches(in: string, range: NSRange(string.startIndex..., in: string))
        return matches.compactMap { match in
            let range = Range(match.range, in: string)!
            return Int(string[range])
        }
    }
    
    static func process(_ input: [String]) -> (Int, Int) {
        var iterator = input.makeIterator()
        let seeds = makeSeq(from: &iterator)
        
        var transformations: [(Int) -> Int] = []
        while let mapper = makeMap(from: &iterator) {
            transformations.append(mapper)
        }
        
        // Compose all transformations matching Scala's reduce((f, g) => g.compose(f))
        // This creates right-associative composition: last function wraps previous ones
        let seedToLocation: (Int) -> Int = transformations.dropFirst().reduce(transformations.first!) { f, g in
            { x in g(f(x)) }
        }
        
        // Part 1: Transform individual seeds
        let part1 = seeds.map(seedToLocation).min() ?? Int.max
        
        // Part 2: Transform seed ranges
        let part2 = seeds.chunked(into: 2).compactMap { pair -> Int? in
            guard pair.count == 2 else { return nil }
            let start = pair[0]
            let length = pair[1]
            return (start..<start + length).map(seedToLocation).min()
        }.min() ?? Int.max
        
        return (part1, part2)
    }
    
    static func main() {
        let input = readInput()
        let (part1, part2) = process(input)
        print("(\(part1), \(part2))")
    }
    
    static func readInput() -> [String] {
        var lines: [String] = []
        while let line = readLine() {
            lines.append(line)
        }
        return lines
    }
}

// Extension to chunk arrays
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

// Entry point
Day5.main()
