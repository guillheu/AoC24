import gleam/bool
import gleam/int
import gleam/io
import gleam/list.{type ContinueOrStop, Continue, Stop}
import gleam/option.{type Option, None, Some}
import gleam/order.{type Order}
import gleam/result
import gleam/string
import simplifile
import snag.{type Result}

pub type Report =
  List(Int)

pub type Accumulator =
  Option(Order)

pub fn main() {
  get_reports("input.txt")
  |> problem1
  |> io.debug
}

pub fn problem1(reports: List(Report)) -> Int {
  list.count(reports, is_report_safe)
}

pub fn get_reports(input_file: String) -> List(Report) {
  let assert Ok(data) = simplifile.read(input_file)
  use line <- list.map(string.split(data, "\n"))
  use report, level_string <- list.fold(string.split(line, " "), [])
  let assert Ok(level_value) = int.parse(level_string)
  [level_value, ..report]
}

pub fn is_report_safe(report: Report) -> Bool {
  list.fold_until(list.window_by_2(report), None, fn(accumulator, window) {
    let #(level1, level2) = window
    are_levels_safe(level1, level2, accumulator, 3)
  })
  |> io.debug
  |> option.is_some
}

fn are_levels_safe(
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
