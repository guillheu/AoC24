import gleam/bool
import gleam/dict.{type Dict}
import gleam/erlang/process
import gleam/int
import gleam/io
import gleam/list.{Continue, Stop}
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/set
import gleam/string

import day5/shared.{type Manual, type PageOrderBlacklist, Manual}

pub fn pt2(blacklist: PageOrderBlacklist, manuals: List(Manual)) -> Int {
  use score, manual <- list.fold(manuals, 0)
  case shared.is_manual_valid(manual, blacklist) {
    False -> {
      let new_manual = rectify_manual(manual, blacklist)
      case shared.is_manual_valid(new_manual, blacklist) {
        False -> score
        True -> new_manual.middle
      }
    }

    True -> 0
  }
  |> int.add(score)
}

fn rectify_manual(manual: Manual, blacklist: PageOrderBlacklist) -> Manual {
  io.println("recursing over " <> string.inspect(manual))
  case manual.pages {
    [first, ..rest] -> recurse([], first, rest, blacklist)
    _ -> panic
  }
}

fn recurse(
  preceding: List(Int),
  current: Int,
  rest: List(Int),
  blacklists: PageOrderBlacklist,
) -> Manual {
  let blacklist = result.unwrap(dict.get(blacklists, current), [])
  let #(new_preceding, new_rest) =
    correct_page_order_on(preceding, rest, blacklist)
  let next_preceding = list.append(new_preceding, [current])
  case new_rest {
    [] -> shared.manual_from_page_numbers(next_preceding)
    [next_current, ..next_rest] ->
      recurse(next_preceding, next_current, next_rest, blacklists)
  }
}

fn correct_page_order_on(
  preceding: List(Int),
  rest: List(Int),
  blacklist: List(Int),
) -> #(List(Int), List(Int)) {
  use #(working_preceding, working_rest), blacklisted <- list.fold(blacklist, #(
    preceding,
    rest,
  ))
  {
    use #(popped, preceding_without_popped) <- result.map(
      list.pop(working_preceding, fn(preceding_page) {
        preceding_page == blacklisted
      }),
    )
    #(preceding_without_popped, [popped, ..working_rest])
  }
  |> result.unwrap(#(working_preceding, working_rest))
}
