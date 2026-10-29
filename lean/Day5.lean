import Lean

open Lean

structure Range where
  destination : Nat
  source : Nat
  length : Nat
  deriving Repr

instance : Inhabited Range := ⟨⟨0, 0, 0⟩⟩

def numbersIn (line : String) : List Nat :=
  (line.splitOn " ").flatMap fun piece =>
    (piece.splitOn "\t").filterMap String.toNat?

def parseRange (line : String) : Range :=
  match numbersIn line with
  | [destination, source, length] => ⟨destination, source, length⟩
  | _ => panic! s!"Invalid mapping range: {line}"

def parseInput (input : String) : List Nat × List (List Range) :=
  let lines := input.splitOn "\n" |>.map fun line => line.replace "\r" ""
  let seeds := match lines with
    | first :: _ => numbersIn first
    | [] => []
  let finishSection (state : List (List Range) × List Range) :=
    let (maps, current) := state
    if current.isEmpty then (maps, current) else (current.reverse :: maps, [])
  let (reversedMaps, current) := (lines.drop 1).foldl (fun state line =>
    if line.isEmpty || line.contains ':' then
      finishSection state
    else
      let (maps, ranges) := state
      (maps, parseRange line :: ranges)) ([], [])
  let maps := (if current.isEmpty then reversedMaps else current.reverse :: reversedMaps).reverse
  (seeds, maps)

def applyMap (ranges : List Range) (value : Nat) : Nat :=
  match ranges.find? fun range => range.source ≤ value && value < range.source + range.length with
  | some range => range.destination + value - range.source
  | none => value

def seedToLocation (maps : List (List Range)) (seed : Nat) : Nat :=
  maps.foldl (fun value ranges => applyMap ranges value) seed

def minMappedRange (maps : List (List Range)) (start length : Nat) : Nat :=
  let rec loop (remaining seed : Nat) (best : Option Nat) : Nat :=
    match remaining with
    | 0 => best.getD 0
    | n + 1 =>
      let location := seedToLocation maps seed
      loop n (seed + 1) (some (best.map (min · location) |>.getD location))
  loop length start none

def seedPairs : List Nat → List (Nat × Nat)
  | start :: length :: rest => (start, length) :: seedPairs rest
  | [] => []
  | [_] => panic! "Invalid seed pair"

def process (input : String) : Nat × Nat :=
  let (seeds, maps) := parseInput input
  let part1 := seeds.map (seedToLocation maps) |>.min?.getD 0
  let part2 := (seedPairs seeds).foldl (fun best (start, length) =>
    let candidate := minMappedRange maps start length
    some (best.map (min · candidate) |>.getD candidate)) none
  (part1, part2.getD 0)

def main : IO Unit := do
  let input ← IO.FS.readFile "/dev/stdin"
  let (part1, part2) := process input
  IO.println s!"({part1}, {part2})"