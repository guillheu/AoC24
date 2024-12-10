import day7/shared.{type Equation, type Operation}
import gleam/erlang/process.{type Subject}
import gleam/int

// import gleam/int

// import gleam/io.{debug, println}
import gleam/list.{Continue, Stop}

// import gleam/string.{inspect}

const operations = [int.add, int.multiply]

pub fn pt1(input: List(Equation(Nil))) -> Int {
  let caller = process.new_subject()
  {
    use equation <- list.each(input)
    process.start(equation_check_process(equation, caller), False)
  }
  use count, _ <- list.fold(input, 0)
  process.receive_forever(caller) + count
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
