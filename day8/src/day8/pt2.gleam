import day8/shared.{
  type Map, type Movement, type Position, type Size, type Vector, Map, Vector,
}
import gleam/dict
import gleam/list
import gleam/set

pub fn pt2(map: Map) -> Int {
  {
    use found, antennas <- list.fold(dict.values(map.antennas), set.new())
    find_antinodes(antennas, map.bounds)
    |> set.from_list
    |> set.union(found)
  }
  |> set.size
}

pub fn find_antinodes(
  antennas: List(Vector(Position)),
  bounds: Vector(Size),
) -> List(Vector(Position)) {
  list.combination_pairs(antennas)
  |> list.flat_map(fn(pair) { get_antinodes(pair, bounds) })
}

fn get_antinodes(
  positions: #(Vector(Position), Vector(Position)),
  bounds: Vector(Size),
) -> List(Vector(Position)) {
  let #(pos1, pos2) = positions
  let diff: Vector(Movement) = Vector(pos2.x - pos1.x, pos2.y - pos1.y)
  let antinodes1 = recurse([], shared.invert(diff), pos1, bounds)
  recurse([], diff, pos2, bounds) |> list.append(antinodes1)
}

fn recurse(
  found_pos: List(Vector(Position)),
  diff: Vector(Movement),
  current_pos: Vector(Position),
  bounds: Vector(Size),
) -> List(Vector(Position)) {
  let next = shared.apply_movement(current_pos, diff)
  case shared.is_within_bounds(next, bounds) {
    True -> recurse([current_pos, ..found_pos], diff, next, bounds)
    False -> [current_pos, ..found_pos]
  }
}
