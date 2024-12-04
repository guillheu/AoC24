import gleam/int
import gleam/io
import gleam/list
import gleeunit
import gleeunit/should

import day4/pt1
import day4/shared

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn pt1_test() {
  let test_cases = [
    #("XMAS", 1),
    #("SAMX", 1),
    #("XMAS\nXXXX\nXXXX\nXXXX", 1),
    #("X\nM\nA\nS", 1),
    #("S\nA\nM\nX", 1),
    #("XXXX\nMXXX\nAXXX\nSXXX", 1),
    #("XXXX\nMMMM\nAAAA\nSSSS", 6),
    #("SSSS\nAAAA\nMMMM\nXXXX", 6),
    #("XSXS\nMAMA\nAMAM\nSXSX", 4),
  ]
  use #(input, expected), index <- list.index_map(test_cases)

  io.println_error(
    "###########\n# TEST #" <> int.to_string(index) <> " #\n###########",
  )
  let puzzle = shared.string_to_puzzle(input)
  pt1.pt1(puzzle) |> should.equal(expected)
}
