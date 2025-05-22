package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strconv"
)

var numberRegex = regexp.MustCompile(`\d+`)

func makeSeq(scanner *bufio.Scanner) ([]int64, error) {
	if !scanner.Scan() {
		return nil, fmt.Errorf("no input")
	}
	line := scanner.Text()
	matches := numberRegex.FindAllString(line, -1)
	var numbers []int64
	for _, match := range matches {
		num, err := strconv.ParseInt(match, 10, 64)
		if err != nil {
			return nil, err
		}
		numbers = append(numbers, num)
	}
	// skip blank line
	scanner.Scan()
	return numbers, nil
}

func makeMap(scanner *bufio.Scanner) (func(int64) int64, bool) {
	if !scanner.Scan() {
		return nil, false
	}
	// skip section header
	
	type rangeMapping struct {
		dest, src, length int64
	}
	
	var ranges []rangeMapping
	
	for scanner.Scan() {
		line := scanner.Text()
		if line == "" {
			break
		}
		matches := numberRegex.FindAllString(line, -1)
		if len(matches) != 3 {
			continue
		}
		dest, _ := strconv.ParseInt(matches[0], 10, 64)
		src, _ := strconv.ParseInt(matches[1], 10, 64)
		length, _ := strconv.ParseInt(matches[2], 10, 64)
		ranges = append(ranges, rangeMapping{dest, src, length})
	}
	
	mapFunc := func(i int64) int64 {
		for _, r := range ranges {
			if r.src <= i && i < r.src+r.length {
				return r.dest + i - r.src
			}
		}
		return i
	}
	
	return mapFunc, true
}

func getAllMaps(scanner *bufio.Scanner) []func(int64) int64 {
	var maps []func(int64) int64
	for {
		mapFunc, hasMore := makeMap(scanner)
		if !hasMore {
			break
		}
		maps = append(maps, mapFunc)
	}
	return maps
}

func composeFunctions(funcs []func(int64) int64) func(int64) int64 {
	return func(x int64) int64 {
		result := x
		for _, f := range funcs {
			result = f(result)
		}
		return result
	}
}

func sliding(slice []int64, size, step int) [][]int64 {
	var result [][]int64
	for i := 0; i <= len(slice)-size; i += step {
		window := make([]int64, size)
		copy(window, slice[i:i+size])
		result = append(result, window)
	}
	return result
}

func min(a, b int64) int64 {
	if a < b {
		return a
	}
	return b
}

func minSlice(slice []int64) int64 {
	if len(slice) == 0 {
		return 0
	}
	result := slice[0]
	for _, v := range slice[1:] {
		result = min(result, v)
	}
	return result
}

func process(scanner *bufio.Scanner) (int64, int64) {
	seeds, err := makeSeq(scanner)
	if err != nil {
		panic(err)
	}
	
	allMaps := getAllMaps(scanner)
	seedToLocation := composeFunctions(allMaps)
	
	// Part 1
	var part1Results []int64
	for _, seed := range seeds {
		part1Results = append(part1Results, seedToLocation(seed))
	}
	part1 := minSlice(part1Results)
	
	// Part 2
	seedPairs := sliding(seeds, 2, 2)
	var part2Results []int64
	
	for _, pair := range seedPairs {
		start := pair[0]
		length := pair[1]
		
		rangeMin := int64(1<<63 - 1) // max int64
		for i := start; i < start+length; i++ {
			location := seedToLocation(i)
			rangeMin = min(rangeMin, location)
		}
		part2Results = append(part2Results, rangeMin)
	}
	part2 := minSlice(part2Results)
	
	return part1, part2
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	part1, part2 := process(scanner)
	fmt.Printf("(%d, %d)\n", part1, part2)
}
