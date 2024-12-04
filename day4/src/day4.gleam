import gleam/io

import day4/pt1
import day4/pt2
import day4/shared

pub fn main() {
  let puzzle = shared.get_puzzle("input.txt")
  pt1.pt1(puzzle) |> io.debug
  pt2.pt2(puzzle) |> io.debug
}
