import gleam/io

import day3/pt1
import day3/shared

pub fn main() {
  shared.get_memory("input.txt")
  |> pt1.pt1
  |> io.debug
}
