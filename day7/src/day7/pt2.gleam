import day7/shared.{type Equation, type Operation}
import gleam/erlang/process.{type Subject}
import gleam/int
import gleam/io.{println}
import gleam/string.{inspect}

// import gleam/int

// import gleam/io.{debug, println}
import gleam/list.{Continue, Stop}

// import gleam/string.{inspect}

const operations = [int.add, int.multiply, concatenate]

pub fn pt2(input: List(Equation(Nil))) -> Int {
  let caller = process.new_subject()
  {
    use equation <- list.map(input)
    process.start(equation_check_process(equation, caller), False)
    Nil
  }
  |> list.fold(0, fn(count, _) { process.receive_forever(caller) + count })
}

pub fn equation_check_process(
  equation: Equation(Nil),
  caller: Subject(Int),
) -> fn() -> Nil {
  fn() {
    let r = {
      use _, attempt <- list.fold_until(
        shared.complete_equation(equation, operations),
        0,
      )
      case shared.is_equation_true(attempt) {
        False -> {
          Continue(0)
        }
        True -> {
          Stop(attempt.result)
        }
      }
    }
    process.send(caller, r)
  }
}

fn concatenate(val1: Int, val2: Int) -> Int {
  let assert Ok(digits1) = int.digits(val1, 10)
  let assert Ok(digits2) = int.digits(val2, 10)
  let assert Ok(r) = int.undigits(list.append(digits1, digits2), 10)
  r
}
