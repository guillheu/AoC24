import gleam/bool
import gleam/int
import gleam/result
import gleam/string

pub fn pt1(memory: String) -> Int {
  recurse(memory, 0)
}

fn recurse(rest: String, count: Int) -> Int {
  let #(rest, r) =
    {
      use rest <- result.try(get_mul_instruction(rest))
      use #(rest, first_number) <- result.try(get_first_number(rest))
      use #(rest, second_number) <- result.try(get_second_number(rest))
      Ok(#(rest, first_number * second_number))
    }
    |> result.unwrap(#(string.drop_start(rest, 1), 0))
  case rest {
    "" -> r + count
    _ -> recurse(rest, r + count)
  }
}

fn get_mul_instruction(rest: String) -> Result(String, Nil) {
  case rest {
    "mul(" <> rest -> Ok(rest)
    _ -> Error(Nil)
  }
}

fn get_first_number(rest: String) -> Result(#(String, Int), Nil) {
  use #(expected_number, rest) <- result.try(string.split_once(rest, ","))
  use <- bool.guard(string.length(expected_number) > 3, Error(Nil))
  use value <- result.try(int.base_parse(expected_number, 10))
  Ok(#(rest, value))
}

fn get_second_number(rest: String) -> Result(#(String, Int), Nil) {
  use #(expected_number, rest) <- result.try(string.split_once(rest, ")"))
  use <- bool.guard(string.length(expected_number) > 3, Error(Nil))
  use value <- result.try(int.base_parse(expected_number, 10))
  Ok(#(rest, value))
}
