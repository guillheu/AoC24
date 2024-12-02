import gleam/io
import gleam/list.{type ContinueOrStop, Continue, Stop}

import gleeunit
import gleeunit/should

import day2

pub fn main() {
  gleeunit.main()
}

pub fn problem1_test() {
  let test_cases = [
    #([10, 6, 5, 4, 3, 2, 1], False),
    #([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], True),
    #([1, 2, 3, 1, 2, 3], False),
    #([3, 2, 1, 3, 2, 1], False),
    #([50, 47, 44, 43, 42], True),
    #([50, 47, 44, 43, 43], False),
  ]
  use test_case, index <- list.index_map(test_cases)
  let #(input, result) = test_case
  io.debug(index)
  day2.is_report_safe(input) |> should.equal(result)
}
