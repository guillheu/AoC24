import gleam/list

import gleeunit
import gleeunit/should

import day3/pt1

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn pt1_test() {
  let test_cases = [
    #("mul(1,2)mul(3,4)", 14),
    #("mul (), 123 123", 0),
    #("mul(1234,1234)", 0),
    #("mil(12,12)", 0),
    #("mul(0010,0010) and && x( mul( )mul((12,12)mul(12,12)", 144),
  ]
  use #(input, result) <- list.each(test_cases)
  pt1.pt1(input) |> should.equal(result)
}
