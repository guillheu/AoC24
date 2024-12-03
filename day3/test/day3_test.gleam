import gleam/list

import gleeunit
import gleeunit/should

import day3/pt1
import day3/pt2

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

pub fn pt2_test() {
  let test_cases = [
    #("mul(1,2)mul(3,4)", 14),
    #("mul (), 123 123", 0),
    #("mul(1234,1234)", 0),
    #("mil(12,12)", 0),
    #("mul(0010,0010) and && x( mul( )mul((12,12)mul(12,12)", 144),
    #(
      "mul(10,10) l xoneu do don don' don't() mul(10,10) do mul(10,10) do() mul(10,10)",
      200,
    ),
    #("mul(1,1) don't() mul(2,1) do() mul(2,2) dont() mul(2,4)", 13),
  ]
  use #(input, result) <- list.each(test_cases)
  pt2.pt2(input) |> should.equal(result)
}
