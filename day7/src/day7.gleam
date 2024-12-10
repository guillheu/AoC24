import day7/pt1
import day7/pt2
import day7/shared
import gleam/erlang/process
import gleam/io

pub fn main() {
  // let val = ["A", "B", "C"]
  // shared.recurse(val, 2) |> io.debug
  let equations = shared.get_input("input.txt")
  pt1.pt1(equations) |> io.debug
  process.sleep(5000)
  pt2.pt2(equations) |> io.debug
}
