open Str

let number_regex = regexp {|\([0-9]+\)|}

let extract_numbers str =
  let rec collect pos acc =
    try
      let _ = search_forward number_regex str pos in
      let num = int_of_string (matched_group 1 str) in
      collect (match_end ()) (num :: acc)
    with Not_found -> List.rev acc
  in
  collect 0 []

let make_seq lines =
  match lines with
  | line :: rest ->
    let numbers = extract_numbers line in
    let remaining = match rest with _ :: t -> t | [] -> [] in (* skip blank line *)
    (numbers, remaining)
  | [] -> ([], [])

let make_map lines =
  let rec skip_empty = function
    | [] -> []
    | "" :: rest -> skip_empty rest
    | lines -> lines
  in
  match skip_empty lines with
  | [] -> None
  | header :: rest ->
    let rec take_while pred acc = function
      | [] -> (List.rev acc, [])
      | x :: xs when pred x -> take_while pred (x :: acc) xs
      | xs -> (List.rev acc, xs)
    in
    let is_data_line s = 
      String.trim s <> "" && not (String.contains s ':')
    in
    let (mapping_lines, remaining) = take_while is_data_line [] rest in
    let ranges = List.map (fun line ->
      match extract_numbers line with
      | [dest; src; len] -> (dest, src, len)
      | nums -> failwith ("Invalid range format: " ^ line ^ " (found " ^ string_of_int (List.length nums) ^ " numbers)")
    ) mapping_lines in
    let map_func i =
      match List.find_opt (fun (_, s, l) -> s <= i && i < s + l) ranges with
      | Some (b, s, _) -> b + i - s
      | None -> i
    in
    Some (map_func, remaining)

let rec get_all_maps lines =
  match make_map lines with
  | None -> []
  | Some (map_func, remaining) -> map_func :: get_all_maps remaining

let compose_functions funcs =
  List.fold_left (fun acc f -> fun x -> f (acc x)) (fun x -> x) funcs

let chunks_of n lst =
  let rec aux acc current = function
    | [] -> if current = [] then List.rev acc else List.rev (List.rev current :: acc)
    | x :: xs ->
      if List.length current = n then
        aux (List.rev current :: acc) [x] xs
      else
        aux acc (x :: current) xs
  in
  aux [] [] lst

let process lines =
  let (seeds, rest) = make_seq lines in
  let all_maps = get_all_maps rest in
  let seed_to_location = compose_functions all_maps in
  
  let part1 = List.fold_left min max_int (List.map seed_to_location seeds) in
  
  let seed_pairs = chunks_of 2 seeds in
  let process_range = function
    | [start; len] ->
        let rec find_min current_min i =
          if i >= start + len then current_min
          else
            let location = seed_to_location i in
            find_min (min current_min location) (i + 1)
        in
        let result = find_min max_int start in
        result
    | lst -> 
      Printf.eprintf "Invalid pair: %s\n" (String.concat "," (List.map string_of_int lst));
      max_int
  in
  let part2 = List.fold_left min max_int (List.map process_range seed_pairs) in
  
  (part1, part2)

let () =
  let lines = 
    let rec read_lines acc =
      try
        let line = read_line () in
        read_lines (line :: acc)
      with End_of_file -> List.rev acc
    in
    read_lines []
  in
  let (part1, part2) = process lines in
  Printf.printf "(%d, %d)\n" part1 part2
