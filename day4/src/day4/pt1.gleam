import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/set

import day4/shared.{
  type Direction, type Letter, type Puzzle, A, Bottom, BottomLeft, BottomRight,
  Left, M, Position, Right, S, Top, TopLeft, TopRight, X,
}

pub fn pt1(puzzle: Puzzle) -> Int {
  use count, current_letter <- set.fold(puzzle, 0)
  case current_letter {
    X(_) -> find_solutions_on_x(puzzle, current_letter) + count
    _ -> count
  }
}

fn find_solutions_on_x(puzzle: Puzzle, letter_x: Letter) -> Int {
  case letter_x {
    X(_) -> Nil
    _ -> panic
  }
  use solutions_found, direction <- list.fold(shared.all_directions, 0)
  {
    use letter_m <- result.try(find_next(puzzle, letter_x, direction))
    use letter_a <- result.try(find_next(puzzle, letter_m, direction))
    use _letter_s <- result.try(find_next(puzzle, letter_a, direction))
    Ok(Nil)
  }
  |> result.map(fn(_) { 1 })
  |> result.unwrap(0)
  |> int.add(solutions_found)
}

fn find_next(
  puzzle: Puzzle,
  letter: Letter,
  direction: Direction,
) -> Result(Letter, Nil) {
  let target_position = case direction {
    Bottom -> Position(letter.pos.x, letter.pos.y + 1)
    BottomLeft -> Position(letter.pos.x - 1, letter.pos.y + 1)
    BottomRight -> Position(letter.pos.x + 1, letter.pos.y + 1)
    Left -> Position(letter.pos.x - 1, letter.pos.y)
    Right -> Position(letter.pos.x + 1, letter.pos.y)
    Top -> Position(letter.pos.x, letter.pos.y - 1)
    TopLeft -> Position(letter.pos.x - 1, letter.pos.y - 1)
    TopRight -> Position(letter.pos.x + 1, letter.pos.y - 1)
  }
  let target_letter_result = case letter {
    X(_) -> Ok(M(target_position))
    M(_) -> Ok(A(target_position))
    A(_) -> Ok(S(target_position))
    S(_) -> Error(Nil)
  }
  use target_letter <- result.try(target_letter_result)
  case set.contains(puzzle, target_letter) {
    False -> Error(Nil)
    True -> Ok(target_letter)
  }
}
