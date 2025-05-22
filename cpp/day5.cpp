#include <iostream>
#include <string>
#include <vector>
#include <sstream>
#include <regex>
#include <functional>
#include <optional>
#include <algorithm>
#include <numeric>
#include <limits>
#include <ranges>

class Day5 {
private:
    static inline const std::regex number{R"((\d+))"};
    
public:
    static std::vector<long> makeSeq(std::vector<std::string>& input, size_t& pos) {
        std::vector<long> result;
        std::sregex_iterator begin(input[pos].begin(), input[pos].end(), number);
        std::sregex_iterator end;
        
        for (auto it = begin; it != end; ++it) {
            result.push_back(std::stol(it->str()));
        }
        
        pos += 2; // skip current line and blank line
        return result;
    }
    
    static std::optional<std::function<long(long)>> makeMap(std::vector<std::string>& input, size_t& pos) {
        if (pos >= input.size()) {
            return std::nullopt;
        }
        
        pos++; // skip section header
        
        std::vector<std::tuple<long, long, long>> ranges;
        
        while (pos < input.size() && !input[pos].empty()) {
            std::sregex_iterator begin(input[pos].begin(), input[pos].end(), number);
            std::sregex_iterator end;
            
            std::vector<long> numbers;
            for (auto it = begin; it != end; ++it) {
                numbers.push_back(std::stol(it->str()));
            }
            
            if (numbers.size() >= 3) {
                ranges.emplace_back(numbers[0], numbers[1], numbers[2]);
            }
            pos++;
        }
        pos++; // skip blank line after ranges
        
        return std::function<long(long)>([ranges](long i) -> long {
            for (const auto& [b, s, l] : ranges) {
                if (i >= s && i < s + l) {
                    return b + i - s;
                }
            }
            return i;
        });
    }
    
    static std::pair<long, long> process(std::vector<std::string>& input) {
        size_t pos = 0;
        auto seeds = makeSeq(input, pos);
        
        std::vector<std::function<long(long)>> transformations;
        
        while (auto mapper = makeMap(input, pos)) {
            transformations.push_back(*mapper);
        }
        
        // Compose all transformations into a single function
        auto seedToLocation = [transformations](long seed) -> long {
            return std::accumulate(transformations.begin(), transformations.end(), seed,
                [](long value, const auto& transform) {
                    return transform(value);
                });
        };
        
        // Part 1: Transform individual seeds
        long part1 = std::numeric_limits<long>::max();
        for (long seed : seeds) {
            part1 = std::min(part1, seedToLocation(seed));
        }
        
        // Part 2: Transform seed ranges
        long part2 = std::numeric_limits<long>::max();
        for (size_t i = 0; i < seeds.size(); i += 2) {
            long start = seeds[i];
            long length = seeds[i + 1];
            
            for (long seed = start; seed < start + length; ++seed) {
                part2 = std::min(part2, seedToLocation(seed));
            }
        }
        
        return {part1, part2};
    }
    
    static void main() {
        std::vector<std::string> input;
        std::string line;
        
        while (std::getline(std::cin, line)) {
            input.push_back(line);
        }
        
        auto [part1, part2] = process(input);
        std::cout << "(" << part1 << ", " << part2 << ")" << std::endl;
    }
};

int main() {
    Day5::main();
    return 0;
}
