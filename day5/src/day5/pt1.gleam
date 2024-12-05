import gleam/bool
import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list.{Continue, Stop}
import gleam/result

import day5/shared.{type Manual, type PageOrderBlacklist}

pub fn pt1(blacklist: PageOrderBlacklist, manuals: List(Manual)) -> Int {
  use score, manual <- list.fold(manuals, 0)
  case shared.is_manual_valid(manual, blacklist) {
    False -> 0
    True -> manual.middle
  }
  |> int.add(score)
}
