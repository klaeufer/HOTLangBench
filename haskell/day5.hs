import Data.Char (isDigit)
import Data.Maybe (fromMaybe)
import Data.List (find)

-- Extract all numbers from a string using only base libraries
extractNumbers :: String -> [Integer]
extractNumbers = map read . words . map (\c -> if isDigit c then c else ' ')

-- Make sequence from first line of input
makeSeq :: [String] -> ([Integer], [String])
makeSeq (line:rest) = 
    let numbers = extractNumbers line
        remaining = dropWhile null rest  -- skip any blank lines
    in (numbers, remaining)
makeSeq [] = ([], [])

-- Make mapping function from input section
makeMap :: [String] -> Maybe (Integer -> Integer, [String])
makeMap [] = Nothing
makeMap input = 
    case dropWhile null input of
        [] -> Nothing
        (header:rest) -> 
            let (mappingLines, remaining) = span (\line -> not (null line) && not (any (== ':') line)) rest
                ranges = map parseRange mappingLines
                mapFunc i = case find (\(_, s, l) -> s <= i && i < s + l) ranges of
                    Just (dest, src, _) -> dest + i - src
                    Nothing -> i
            in Just (mapFunc, remaining)
  where
    parseRange line = 
        case extractNumbers line of
            [dest, src, len] -> (dest, src, len)
            nums -> error $ "Invalid range format: " ++ line ++ " (found " ++ show (length nums) ++ " numbers)"

-- Get all mapping functions
getAllMaps :: [String] -> [Integer -> Integer]
getAllMaps [] = []
getAllMaps input = 
    case makeMap input of
        Nothing -> []
        Just (mapFunc, remaining) -> mapFunc : getAllMaps remaining

-- Compose all functions (apply functions in sequence, left to right)
composeFunctions :: [Integer -> Integer] -> Integer -> Integer
composeFunctions funcs x = foldl (\acc f -> f acc) x funcs

-- Process the input
process :: [String] -> (Integer, Integer)
process input = 
    let (seeds, rest) = makeSeq input
        allMaps = getAllMaps rest
        seedToLocation = composeFunctions allMaps
        
        part1 = minimum $ map seedToLocation seeds
        
        -- Part 2: process seeds as ranges
        seedPairs = chunksOf 2 seeds
        part2 = minimum $ map processRange seedPairs
        
        processRange [start, len] = minimum $ map seedToLocation [start..start+len-1]
        processRange _ = error "Invalid seed pair"
        
    in (part1, part2)

-- Helper function to split list into chunks
chunksOf :: Int -> [a] -> [[a]]
chunksOf _ [] = []
chunksOf n xs = take n xs : chunksOf n (drop n xs)

main :: IO ()
main = do
    input <- lines <$> getContents
    print $ process input