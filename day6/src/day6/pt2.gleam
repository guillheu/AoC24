import day6/pt1
import day6/shared.{
  type Direction, type Guard, type Map, type Position, type Tile, Down, Guard,
  Left, Map, Obstacle, Open, Position, Right, Up,
}
import gleam/bool
import gleam/erlang/process.{type Subject}
import gleam/int
import gleam/io
import gleam/list
import gleam/string

pub fn pt2(map: Map) -> Int {
  let finished_map = pt1.draw_guard_path(map)
  let visited_tiles = shared.get_all_visited_tiles(finished_map)
  let caller_subject = process.new_subject()
  use count, _ <- list.fold(
    {
      use new_obstacle_position, index <- list.index_map(visited_tiles)
      io.println(
        "Map #"
        <> int.to_string(index)
        <> " ; trying obstacle @ "
        <> string.inspect(new_obstacle_position),
      )
      let modified_map = shared.add_obstacle_at(map, new_obstacle_position)
      process.start(start_process(index, modified_map, caller_subject), False)
      //   process.sleep(10_000_000)
    },
    0,
  )
  case process.receive_forever(caller_subject) {
    True -> count + 1
    False -> count
  }
  |> io.debug
}

fn start_process(id: Int, map: Map, caller: Subject(Bool)) -> fn() -> Nil {
  fn() {
    io.println("Map #" <> int.to_string(id) <> " starting...")
    // io.println(string.inspect(map.guard))
    case recurse(map) {
      False -> {
        io.println("Map #" <> int.to_string(id) <> " did not loop...")
        process.send(caller, False)
      }
      True -> {
        io.println(
          "Map #" <> int.to_string(id) <> " successfully found a loop!",
        )
        process.send(caller, True)
      }
    }
    Nil
  }
}

fn recurse(map: Map) -> Bool {
  let map = case shared.get_map_tile_at(map, shared.guard_looking_at(map)) {
    Obstacle -> shared.rotate_guard(map)
    Open(_) -> map
  }

  let map = case shared.get_map_tile_at(map, shared.guard_looking_at(map)) {
    Obstacle -> shared.rotate_guard(map)
    Open(_) -> map
  }
  let map = shared.move_guard(map)
  //   case
  //     shared.is_position_out_of_bounds(map, map.guard.pos),
  //     shared.is_guard_looping(map)
  //   {
  //     True, True -> False
  //     True, False -> False
  //     False, False -> recurse(map)
  //     False, True -> True
  //   }
  use <- bool.guard(shared.is_position_out_of_bounds(map, map.guard.pos), False)
  use <- bool.guard(shared.is_guard_looping(map), True)

  recurse(map)
}
