import day6/pt1
import day6/pt2
import day6/shared
import gleam/io

pub fn main() {
  let map = shared.get_input("input.txt")
  io.debug(map.bounds)
  pt1.pt1(map) |> io.debug
}
