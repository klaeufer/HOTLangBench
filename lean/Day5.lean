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

def parseInput (input : String) : List Nat × List (List Range) := Id.run do
  let lines := input.splitOn "\n" |>.map fun line => line.replace "\r" ""
  let seeds := match lines with
    | first :: _ => numbersIn first
    | [] => []
  let mut maps : List (List Range) := []
  let mut current : List Range := []
  for line in lines.drop 1 do
    if line.isEmpty then
      if !current.isEmpty then
        maps := maps ++ [current.reverse]
        current := []
    else if line.contains ':' then
      if !current.isEmpty then
        maps := maps ++ [current.reverse]
        current := []
    else
      current := parseRange line :: current
  if !current.isEmpty then
    maps := maps ++ [current.reverse]
  return (seeds, maps)

def applyMap (ranges : List Range) (value : Nat) : Nat :=
  match ranges.find? fun range => range.source ≤ value && value < range.source + range.length with
  | some range => range.destination + value - range.source
  | none => value

def seedToLocation (maps : List (List Range)) (seed : Nat) : Nat :=
  maps.foldl (fun value ranges => applyMap ranges value) seed

def minMappedRange (maps : List (List Range)) (start length : Nat) : Nat := Id.run do
  let mut best : Option Nat := none
  for offset in [:length] do
    let location := seedToLocation maps (start + offset)
    best := some (best.map (min · location) |>.getD location)
  return best.getD 0

def seedPairs : List Nat → List (Nat × Nat)
  | start :: length :: rest => (start, length) :: seedPairs rest
  | [] => []
  | [_] => panic! "Invalid seed pair"

def process (input : String) : Nat × Nat := Id.run do
  let (seeds, maps) := parseInput input
  let part1 := seeds.map (seedToLocation maps) |>.min?.getD 0
  let mut part2 : Option Nat := none
  for (start, length) in seedPairs seeds do
    let candidate := minMappedRange maps start length
    part2 := some (part2.map (min · candidate) |>.getD candidate)
  return (part1, part2.getD 0)

def main : IO Unit := do
  let input ← IO.FS.readFile "/dev/stdin"
  let (part1, part2) := process input
  IO.println s!"({part1}, {part2})"