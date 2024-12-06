import day6/shared.{
  type Direction, type Guard, type Map, type Position, type Tile, Down, Guard,
  Left, Map, Obstacle, Open, Position, Right, Up,
}

pub fn pt1(map: Map) -> Int {
  let finished = recurse(map)
  shared.count_visited_tiles(finished)
}

fn recurse(map: Map) -> Map {
  // -2: get position guard is looking at
  let guard_looking_at = shared.guard_looking_at(map)
  // -1: check tile in front of the guard (shared.get_map_tile_at(map,...))
  let in_front_of_guard = shared.get_map_tile_at(map, guard_looking_at)
  // 0: if that tile is an obstacle, rotate the guard, if not, do nothing.
  let map = case in_front_of_guard {
    Obstacle -> shared.rotate_guard(map)
    Open(_) -> map
  }
  // 1: move guard with shared.move_guard (will set the previous tile to visited)
  let map = shared.move_guard(map)
  // 2: check if guard position is out of bounds
  case shared.is_position_out_of_bounds(map, map.guard.pos) {
    False -> recurse(map)
    True -> map
  }
  // 2.1: if yes, return current map
  // 2.2: if not, call recurse on current map
}
