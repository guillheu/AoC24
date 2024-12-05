import gleam/io

import day5/pt1
import day5/pt2
import day5/shared

pub fn main() {
  let #(blacklist, manuals) = shared.get_input("input.txt")
  pt1.pt1(blacklist, manuals) |> io.debug
  pt2.pt2(blacklist, manuals) |> io.debug
}
