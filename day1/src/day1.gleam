import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile
import tote/bag

type HistorianLists =
  #(List(Int), List(Int))

pub fn main() {
  let historian_lists = get_historian_lists("input.txt")
  problem1(historian_lists) |> io.debug
  problem2(historian_lists) |> io.debug
}

pub fn problem1(historian_lists: HistorianLists) -> Int {
  let #(list1, list2) = historian_lists
  let sorted_list1 = list.sort(list1, int.compare)
  let sorted_list2 = list.sort(list2, int.compare)
  use distance, #(location1, location2) <- list.fold(
    list.zip(sorted_list1, sorted_list2),
    0,
  )
  distance + int.absolute_value(location1 - location2)
}

pub fn problem2(historian_lists: HistorianLists) -> Int {
  let #(list1, list2) = historian_lists
  let list2_bag = bag.from_list(list2)
  use similarity_score, list1_item <- list.fold(list1, 0)
  let occurences = list2_bag |> bag.copies(list1_item)
  similarity_score + { list1_item * occurences }
}

pub fn get_historian_lists(input_file: String) -> HistorianLists {
  let assert Ok(input) = simplifile.read(input_file)

  use #(list1, list2), line <- list.fold(string.split(input, "\n"), #([], []))
  let assert [term1, term2] = string.split(line, "   ")
  let assert Ok(value1) = int.parse(term1)
  let assert Ok(value2) = int.parse(term2)
  #([value1, ..list1], [value2, ..list2])
}
