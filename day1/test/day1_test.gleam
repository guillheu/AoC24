import day1

import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn day1_test() {
  let historian_lists = day1.get_historian_lists("input.txt")
  day1.problem1(historian_lists) |> should.equal(1_938_424)
  day1.problem2(historian_lists) |> should.equal(22_014_209)
}
