# HOTLangBench (WiP)

This work in progress aims to compare various HOT (higher-order and statically typed, a term coined by Phil Wadler) through *reproducible* course-grained, wall-time benchmarks.

There is currently only one benchmark, but it brings out substantial performance differences among the various languages and platforms. 
It is easy to add versions of this benchmark in other languages (see below).

TODO: It should be relatively easy to add other benchmarks with a minor refactoring of the directory structure.

## Motivation

As a lifelong student of programming languages, especially HOT ones, I have been intrigued by the [Computer Language Benchmarks Game](https://benchmarksgame-team.pages.debian.net/benchmarksgame), a.k.a. the shootout.
Nevertheless, the shootout seems to focus mostly on computational physics problems with few opportunities to use higher-order programming techniques.

Meanwhile, I also started to work on some [Advent of Code](https://adventofcode.com) challenges to stay current on my coding skills.
When I worked on [this puzzle](https://adventofcode.com/2023/day/5), I noticed that my Scala version hadn't finished after several hours; because I didn't want my laptop to overheat, I ran it on a fast compute node, where it took about three hours. 
Because I was also getting interested in Rust, I transliterated my code as closely as possible, and the resulting Rust code ran in about three minutes.

As a first step toward understanding the root causes for these major differences, I decided to transliterate the code to various other languages and platforms and compare their relative performance in a coarse-grained manner.
For reproducibility, compared to the complex and Python 2-based scripts included in the shootout, I created my own, very simple shell scripts.

## Languages

Currently, the following languages are supported:

- Modern C++
- C#
- Go
- Haskell
- Kotlin
- Modern Java (24)
- OCaml
- Scala 3

I wrote the Scala version first, using function composition and other higher-order constructs to build a pipeline of transformations, along with a brute-force iteration that is computationally expensive for large seed ranges.

I then manually transliterated the Scala version to Rust, Java, C#, and Kotlin.

Recently, I used Anthropic Claude to transliterate the Scala version to C++, Go, Haskell, and OCaml, thereby covering most mainstream HOT languages.

Help with missing languages is welcome, especially:

- TypeScript
- Swift

## Benchmarks

There is currently only one benchmark, the seed-fertilizer mapping puzzle from day 5 of the 2023 Advent of Code.

https://adventofcode.com/2023/day/5

*Actual results for the full input are pending. Now that I've finally learned some basic tmux techniques, I plan to post them here as soon as they are available.*
