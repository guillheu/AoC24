import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/string
import simplifile

pub type Map {
  Map(map: Dict(Position, Tile), bounds: Position, guard: Guard)
}

pub type Guard {
  Guard(pos: Position, direction: Direction)
}

pub type Position {
  Position(x: Int, y: Int)
}

pub type Tile {
  Open(visited: Bool)
  Obstacle
}

pub type Direction {
  Up
  Down
  Left
  Right
}

pub fn get_input(input_file: String) -> Map {
  let assert Ok(content) = simplifile.read(input_file)
  use current_map, current_line, y <- list.index_fold(
    string.split(content, "\n"),
    Map(dict.new(), Position(0, 0), Guard(Position(-1, -1), Up)),
  )
  use current_map, current_char, x <- list.index_fold(
    string.to_graphemes(current_line),
    current_map,
  )
  case current_char {
    "." -> set_map_tile_at(current_map, Position(x, y), Open(False))
    "#" -> set_map_tile_at(current_map, Position(x, y), Obstacle)
    "^" ->
      set_map_tile_at(current_map, Position(x, y), Open(True))
      |> set_map_guard_at(Position(x, y), Up)
    other -> panic as { "found invalid character " <> other }
  }
  |> update_map_bounds(Position(x, y))
}

pub fn update_map_bounds(map: Map, bounds: Position) -> Map {
  Map(
    ..map,
    bounds: Position(
      int.max(map.bounds.x, bounds.x),
      int.max(map.bounds.x, bounds.x),
    ),
  )
}

pub fn set_map_guard_at(
  map: Map,
  position: Position,
  direction: Direction,
) -> Map {
  Map(..map, guard: Guard(position, direction))
}

pub fn set_map_visited_at(map: Map, position: Position) -> Map {
  case get_map_tile_at(map, position) {
    Obstacle -> panic as "trying to set an obsacle as visited"
    Open(_) -> Map(..map, map: dict.insert(map.map, position, Open(True)))
  }
}

fn set_map_tile_at(map: Map, position: Position, tile: Tile) -> Map {
  Map(..map, map: dict.insert(map.map, position, tile))
}

pub fn get_map_tile_at(map: Map, position: Position) -> Tile {
  case is_position_out_of_bounds(map, position) {
    False -> {
      let assert Ok(tile) = dict.get(map.map, position)
      tile
    }
    True -> Open(False)
  }
}

pub fn move_guard(map: Map) -> Map {
  Map(..map, guard: Guard(guard_looking_at(map), map.guard.direction))
  |> set_map_visited_at(map.guard.pos)
}

pub fn clockwise(dir: Direction) -> Direction {
  case dir {
    Down -> Left
    Left -> Up
    Right -> Down
    Up -> Right
  }
}

pub fn is_position_out_of_bounds(map: Map, position: Position) -> Bool {
  let bounds = map.bounds
  !{
    position.x >= 0
    && position.x <= bounds.x
    && position.y >= 0
    && position.y <= bounds.y
  }
}

pub fn guard_looking_at(map: Map) -> Position {
  move_one_towards(map.guard.pos, map.guard.direction)
}

pub fn rotate_guard(map: Map) -> Map {
  Map(..map, guard: Guard(map.guard.pos, clockwise(map.guard.direction)))
}

fn move_one_towards(position: Position, direction: Direction) -> Position {
  direction_to_position(direction) |> add_positions(position)
}

fn add_positions(pos1: Position, pos2: Position) -> Position {
  Position(pos1.x + pos2.x, pos1.y + pos2.y)
}

fn direction_to_position(direction: Direction) -> Position {
  case direction {
    Down -> Position(x: 0, y: 1)
    Left -> Position(x: -1, y: 0)
    Right -> Position(x: 1, y: 0)
    Up -> Position(x: 0, y: -1)
  }
}

pub fn count_visited_tiles(map: Map) -> Int {
  use count, _, tile <- dict.fold(map.map, 0)
  case tile {
    Obstacle -> 0
    Open(False) -> 0
    Open(True) -> 1
  }
  |> int.add(count)
}
