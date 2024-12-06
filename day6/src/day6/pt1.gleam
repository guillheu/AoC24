import day6/shared.{
  type Direction, type Guard, type Map, type Position, type Tile, Down, Guard,
  Left, Map, Obstacle, Open, Position, Right, Up,
}
import gleam/io

pub fn pt1(map: Map) -> Int {
  let finished = draw_guard_path(map)
  shared.count_visited_tiles(finished)
}

pub fn draw_guard_path(map) -> Map {
  recurse(map)
}

fn recurse(map: Map) -> Map {
  let map = case shared.get_map_tile_at(map, shared.guard_looking_at(map)) {
    Obstacle -> shared.rotate_guard(map)
    Open(_) -> map
  }

  let map = case shared.get_map_tile_at(map, shared.guard_looking_at(map)) {
    Obstacle -> shared.rotate_guard(map)
    Open(_) -> map
  }

  let map = shared.move_guard(map)
  case shared.is_position_out_of_bounds(map, map.guard.pos) {
    True -> map
    False -> recurse(map)
  }
}
