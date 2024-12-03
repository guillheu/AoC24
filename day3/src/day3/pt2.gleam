import gleam/bool
import gleam/int
import gleam/result
import gleam/string

pub fn pt2(memory: String) -> Int {
  recurse(memory, 0, True)
}

fn recurse(rest: String, count: Int, enabled: Bool) -> Int {
  let #(rest, enabled) =
    {
      use <- result.lazy_or(run_do(rest))
      run_dont(rest)
    }
    |> result.unwrap(#(rest, enabled))

  let #(rest, new_val) = {
    use <- bool.guard(!enabled, #(string.drop_start(rest, 1), 0))
    run_mul(rest)
    |> result.unwrap(#(string.drop_start(rest, 1), 0))
  }
  let new_count = new_val + count

  case rest {
    "" -> new_count
    _ -> recurse(rest, new_count, enabled)
  }
}

fn run_do(rest: String) -> Result(#(String, Bool), Nil) {
  trim_prefix(rest, "do()") |> result.map(fn(rest) { #(rest, True) })
}

fn run_dont(rest: String) -> Result(#(String, Bool), Nil) {
  trim_prefix(rest, "don't()") |> result.map(fn(rest) { #(rest, False) })
}

fn run_mul(rest: String) -> Result(#(String, Int), Nil) {
  use rest <- result.try(get_mul_instruction(rest))
  use #(rest, first_number) <- result.try(get_first_number(rest))
  use #(rest, second_number) <- result.try(get_second_number(rest))
  Ok(#(rest, first_number * second_number))
}

fn get_mul_instruction(rest: String) -> Result(String, Nil) {
  trim_prefix(rest, "mul(")
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

fn trim_prefix(from: String, prefix: String) -> Result(String, Nil) {
  case string.starts_with(from, prefix) {
    True -> Ok(string.drop_start(from, string.length(prefix)))
    False -> Error(Nil)
  }
}
