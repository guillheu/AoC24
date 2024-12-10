import day8/pt1
import day8/pt2
import day8/shared
import gleam/io

pub fn main() {
  let map = shared.get_input("input.txt")
  pt1.pt1(map) |> io.debug
  pt2.pt2(map) |> io.debug
}
