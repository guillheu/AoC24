import gleam/int
import gleam/list
import gleam/set.{type Set}
import gleam/string
import simplifile

pub type Equation(completeness) {
  Equation(result: Int, first_val: Int, terms: List(#(completeness, Int)))
}

pub type Operation =
  fn(Int, Int) -> Int

pub fn get_input(input_path: String) -> List(Equation(Nil)) {
  let assert Ok(content) = simplifile.read(input_path)
  use line <- list.map(string.split(content, "\n"))
  let assert Ok(#(result_string, numbers)) = string.split_once(line, ": ")
  let assert [first_string, ..rest] = string.split(numbers, " ")
  let assert Ok(result) = int.parse(result_string)
  let assert Ok(first) = int.parse(first_string)
  use equation, next_value_string <- list.fold(
    rest,
    Equation(result, first, []),
  )
  let assert Ok(next_value) = int.parse(next_value_string)
  Equation(..equation, terms: list.append(equation.terms, [#(Nil, next_value)]))
}

pub fn complete_equation(
  eq: Equation(Nil),
  operations: List(Operation),
) -> List(Equation(Operation)) {
  let #(_, values) = list.unzip(eq.terms)
  let size = list.length(eq.terms)
  let combos = operations_combinations(size, operations)
  use operations <- list.map(set.to_list(combos))
  Equation(eq.result, eq.first_val, list.zip(operations, values))
}

fn operations_combinations(
  size: Int,
  operations: List(Operation),
) -> Set(List(Operation)) {
  recurse(operations, size)
  |> set.from_list
  // operations
  // |> list.repeat(size)
  // |> list.flatten
  // |> list.combinations(size)
  // |> set.from_list
}

pub fn recurse(
  // prepend: List(a),
  to_append: List(a),
  remaining: Int,
) -> List(List(a)) {
  case remaining {
    x if x <= 0 -> panic
    1 -> {
      use current_item <- list.map(to_append)
      [current_item]
    }
    _ ->
      {
        use current_item <- list.map(to_append)
        use returned_list <- list.map(recurse(to_append, remaining - 1))
        [current_item, ..returned_list]
      }
      |> list.flatten
  }
}

pub fn is_equation_true(eq: Equation(Operation)) -> Bool {
  eq.result == calculate(eq.first_val, eq.terms)
}

fn calculate(first_val: Int, ops: List(#(Operation, Int))) -> Int {
  use total, #(next_op, next_val) <- list.fold(ops, first_val)
  next_op(total, next_val)
}
