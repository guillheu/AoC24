import gleam/list
import gleam/set.{type Set}
import gleam/string
import simplifile

pub type Puzzle =
  Set(Letter)

pub type Letter {
  X(pos: Position)
  M(pos: Position)
  A(pos: Position)
  S(pos: Position)
}

pub type Position {
  Position(x: Int, y: Int)
}

pub type Direction {
  Top
  Bottom
  Left
  Right
  TopLeft
  TopRight
  BottomLeft
  BottomRight
}

pub const all_directions = [
  Top, Left, Right, TopLeft, TopRight, Bottom, BottomLeft, BottomRight,
]

pub fn string_to_puzzle(input: String) -> Puzzle {
  use current_puzzle, line, line_index <- list.index_fold(
    string.split(input, "\n"),
    set.new(),
  )
  use current_puzzle, char, char_index <- list.index_fold(
    string.to_graphemes(line),
    current_puzzle,
  )
  let letter =
    Position(char_index, line_index)
    |> {
      case char {
        "X" -> X(_)
        "M" -> M(_)
        "A" -> A(_)
        "S" -> S(_)
        other -> panic as { "found non XMAS letter in input : " <> other }
      }
    }
  set.insert(current_puzzle, letter)
}

pub fn get_puzzle(input_path: String) -> Puzzle {
  let assert Ok(content) = simplifile.read(input_path)
  string_to_puzzle(content)
}
