import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/regexp
import gleam/result
import gleam/set.{type Set}
import gleam/string
import simplifile

pub type Map {
  Map(antennas: Dict(String, List(Vector(Position))), bounds: Vector(Size))
}

pub type Vector(tyype) {
  Vector(x: Int, y: Int)
}

pub type Movement

pub type Size

pub type Position

pub fn get_input(input_path: String) -> Map {
  let assert Ok(content) = simplifile.read(input_path)
  let assert Ok(re) = regexp.from_string("[a-zA-Z0-9]")
  use current_map, current_line, y <- list.index_fold(
    string.split(content, "\n"),
    Map(dict.new(), Vector(0, 0)),
  )
  use current_map, current_char, x <- list.index_fold(
    string.to_graphemes(current_line),
    current_map,
  )
  let bounds =
    Vector(int.max(current_map.bounds.x, x), int.max(current_map.bounds.y, y))
  case regexp.check(re, current_char) {
    False -> current_map
    True -> {
      let current_freq_antennas =
        result.unwrap(dict.get(current_map.antennas, current_char), [])
      Map(
        dict.insert(current_map.antennas, current_char, [
          Vector(x, y),
          ..current_freq_antennas
        ]),
        bounds,
      )
    }
  }
}

pub fn invert(movement: Vector(Movement)) -> Vector(Movement) {
  Vector(-movement.x, -movement.y)
}

pub fn apply_movement(
  pos: Vector(Position),
  move: Vector(Movement),
) -> Vector(Position) {
  Vector(pos.x + move.x, pos.y + move.y)
}

pub fn is_within_bounds(pos: Vector(Position), bounds: Vector(Size)) -> Bool {
  pos.x >= 0 && pos.y >= 0 && pos.x <= bounds.x && pos.y <= bounds.y
}
