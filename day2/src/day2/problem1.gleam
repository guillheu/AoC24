import gleam/bool
import gleam/int
import gleam/io
import gleam/list.{type ContinueOrStop, Continue, Stop}
import gleam/option.{type Option, None, Some}
import gleam/order.{type Order}

import day2/shared.{type Report}

pub type Accumulator =
  Option(Order)

pub fn problem1(reports: List(Report)) -> Int {
  list.count(reports, is_report_safe)
}

pub fn is_report_safe(report: Report) -> Bool {
  list.fold_until(list.window_by_2(report), None, fn(accumulator, window) {
    let #(level1, level2) = window
    are_levels_safe(level1, level2, accumulator, 3)
  })
  |> option.is_some
}

pub fn are_levels_safe(
  level1: Int,
  level2: Int,
  previous_variation: Option(Order),
  max_variation: Int,
) -> ContinueOrStop(Option(Order)) {
  use <- bool.guard(
    int.absolute_value(level1 - level2) > max_variation,
    Stop(None),
  )
  use <- bool.guard(level1 == level2, Stop(None))
  let change = int.compare(level2, level1)
  case previous_variation {
    None -> Continue(Some(change))
    Some(prev) ->
      bool.guard(change != prev, Stop(None), fn() { Continue(Some(prev)) })
  }
  // io.debug("New level window")
  // case int.compare(level2, level1) |> io.debug, previous_variation |> io.debug {
  //   _, Some(order.Eq) -> panic
  //   order.Eq, _ -> Stop(None)
  //   order.Gt, Some(order.Gt) ->
  //     case int.compare(int.absolute_value(level2 - level1), max_variation) {
  //       order.Gt -> Stop(None)
  //       _ -> Continue(Some(order.Gt))
  //     }
  //   order.Lt, Some(order.Lt) ->
  //     case int.compare(int.absolute_value(level1 - level2), max_variation) {
  //       order.Gt -> Stop(None)
  //       _ -> Continue(Some(order.Lt))
  //     }
  //   // order.Gt, None if level2 - level1 > max_variation -> Stop(None)
  //   // order.Lt, None if level1 - level2 > max_variation -> Stop(None)
  //   order.Gt, Some(order.Lt) -> Stop(None)
  //   order.Lt, Some(order.Gt) -> Stop(None)
  //   order.Gt, None -> Continue(Some(order.Gt))
  //   order.Lt, None -> Continue(Some(order.Lt))
  // }
}
