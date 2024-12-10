import day8/shared.{
  type Map, type Movement, type Position, type Size, type Vector, Map, Vector,
}
import gleam/dict
import gleam/list
import gleam/set

pub fn pt1(map: Map) -> Int {
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
  let possible_antinode_1 = shared.apply_movement(pos1, shared.invert(diff))
  let possible_antinode_2 = shared.apply_movement(pos2, diff)
  case
    shared.is_within_bounds(possible_antinode_1, bounds),
    shared.is_within_bounds(possible_antinode_2, bounds)
  {
    False, False -> []
    True, True -> [possible_antinode_1, possible_antinode_2]
    False, True -> [possible_antinode_2]
    True, False -> [possible_antinode_1]
  }
}
