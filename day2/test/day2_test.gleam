import gleam/io
import gleam/list.{type ContinueOrStop, Continue, Stop}

import gleeunit
import gleeunit/should

import day2/problem1
import day2/problem2

pub fn main() {
  gleeunit.main()
}

pub fn problem1_test() {
  let test_cases = [
    #([10, 6, 5, 4, 3, 2, 1], False),
    #([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], True),
    #([1, 2, 3, 1, 2, 3], False),
    #([50, 47, 44, 43, 42], True),
    #([50, 47, 44, 43, 43], False),
  ]
  use test_case, index <- list.index_map(test_cases)
  let #(input, result) = test_case
  // io.debug(index)
  problem1.is_report_safe(input) |> should.equal(result)
  problem1.is_report_safe(list.reverse(input)) |> should.equal(result)
}

pub fn problem2_test() {
  let test_cases = [
    #([10, 6, 5, 4, 3, 2, 1], True),
    #([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], True),
    #([1, 2, 3, 1, 2, 3], False),
    #([50, 47, 44, 43, 42], True),
    #([50, 47, 44, 43, 43], True),
    #([1, 2, 3, 80, 4, 5, 6], True),
    #([10, 9, 1, 8, 6], True),
    #([10, 9, 8, 3, 2, 1], False),
    #([10, 10, 9, 8, 3, 2, 1], False),
    #([10, 10, 10, 9, 8, 3, 2, 1], False),
    #([10, 10, 9, 9, 8, 3, 2], False),
    #([10, 9, 9, 8, 7], True),
    #([10, 9, 9, 8, 3], False),
    #([10, 9, 9, 9, 8], False),
  ]
  use test_case, index <- list.index_map(test_cases)
  let #(input, result) = test_case
  io.debug(index)
  problem2.is_report_safe(input) |> should.equal(result)
  problem2.is_report_safe(list.reverse(input)) |> should.equal(result)
}
