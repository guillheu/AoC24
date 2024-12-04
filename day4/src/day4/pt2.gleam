import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/set
import gleam/string

import day4/shared.{
  type Direction, type Letter, type Position, type Puzzle, A, Bottom, BottomLeft,
  BottomRight, Left, M, Position, Right, S, Top, TopLeft, TopRight, X,
}

pub fn pt2(puzzle: Puzzle) -> Int {
  use count, current_letter <- set.fold(puzzle, 0)
  case current_letter {
    A(_) -> find_solutions_on_a(puzzle, current_letter) + count
    _ -> count
  }
}

fn find_solutions_on_a(puzzle: Puzzle, letter_a: Letter) -> Int {
  case letter_a {
    A(pos) -> io.println_error("evaluating " <> string.inspect(pos))
    _ -> panic
  }
  use solutions_found, direction <- list.fold(shared.diagonals, 0)
  io.println_error("starting from direction " <> string.inspect(direction))
  let expected_m_1 = M(move_to(letter_a.pos, direction))
  let expected_m_2 = M(move_to(letter_a.pos, shared.clockwise(direction)))
  let expected_s_1 = S(move_to(letter_a.pos, shared.opposite(direction)))
  let expected_s_2 =
    S(move_to(letter_a.pos, shared.counter_clockwise(direction)))
  io.println_error("Evaluating the following expected letters :")
  io.println_error(string.inspect(expected_m_1))
  io.println_error(string.inspect(expected_m_2))
  io.println_error(string.inspect(expected_s_1))
  io.println_error(string.inspect(expected_s_2))
  {
    use <- bool.guard(!set.contains(puzzle, expected_m_1), 0)
    io.println_error("found matching first m")
    use <- bool.guard(!set.contains(puzzle, expected_m_2), 0)
    io.println_error("found matching second m")
    use <- bool.guard(!set.contains(puzzle, expected_s_1), 0)
    io.println_error("found matching first s")
    use <- bool.guard(!set.contains(puzzle, expected_s_2), 0)
    io.println_error("found matching second s")
    io.println_error("found solution :" <> string.inspect(letter_a))
    1
  }
  |> int.add(solutions_found)
}

fn move_to(pos: Position, direction: Direction) -> Position {
  case direction {
    Bottom -> Position(pos.x, pos.y + 1)
    BottomLeft -> Position(pos.x - 1, pos.y + 1)
    BottomRight -> Position(pos.x + 1, pos.y + 1)
    Left -> Position(pos.x - 1, pos.y)
    Right -> Position(pos.x + 1, pos.y)
    Top -> Position(pos.x, pos.y - 1)
    TopLeft -> Position(pos.x - 1, pos.y - 1)
    TopRight -> Position(pos.x + 1, pos.y - 1)
  }
}
// fn find_next(
//   puzzle: Puzzle,
//   letter: Letter,
//   direction: Direction,
// ) -> Result(Letter, Nil) {
//   let target_position = case direction {
//     Bottom -> Position(letter.pos.x, letter.pos.y + 1)
//     BottomLeft -> Position(letter.pos.x - 1, letter.pos.y + 1)
//     BottomRight -> Position(letter.pos.x + 1, letter.pos.y + 1)
//     Left -> Position(letter.pos.x - 1, letter.pos.y)
//     Right -> Position(letter.pos.x + 1, letter.pos.y)
//     Top -> Position(letter.pos.x, letter.pos.y - 1)
//     TopLeft -> Position(letter.pos.x - 1, letter.pos.y - 1)
//     TopRight -> Position(letter.pos.x + 1, letter.pos.y - 1)
//   }
//   let target_letter_result = case letter {
//     X(_) -> Ok(M(target_position))
//     M(_) -> Ok(A(target_position))
//     A(_) -> Ok(S(target_position))
//     S(_) -> Error(Nil)
//   }
//   use target_letter <- result.try(target_letter_result)
//   case set.contains(puzzle, target_letter) {
//     False -> Error(Nil)
//     True -> Ok(target_letter)
//   }
// }
