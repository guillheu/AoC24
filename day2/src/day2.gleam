import day2/problem2
import gleam/io

import day2/problem1
import day2/shared

pub fn main() {
  let reports = shared.get_reports("input.txt")
  reports
  |> problem1.problem1
  |> io.debug
  reports
  |> problem2.problem2
  |> io.debug
}
