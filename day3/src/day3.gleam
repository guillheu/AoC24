import day3/pt2
import gleam/io

import day3/pt1
import day3/shared

pub fn main() {
  let mem = shared.get_memory("input.txt")
  mem
  |> pt1.pt1
  |> io.debug
  mem
  |> pt2.pt2
  |> io.debug
}
