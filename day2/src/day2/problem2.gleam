import day2/shared.{type Report}
import gleam/list

import day2/problem1

type DampenedReports =
  List(Report)

pub fn problem2(reports: List(Report)) -> Int {
  list.count(reports, is_report_safe)
}

pub fn is_report_safe(report: Report) -> Bool {
  use dampened_report <- list.any(dampen(report))
  problem1.is_report_safe(dampened_report)
}

fn dampen(report: Report) -> DampenedReports {
  list.combinations(report, list.length(report) - 1)
}
// ROFLMAO LOOK HOW MUCH I STRUGGLED HAHAHAHAHA
//
//
//
//
//
// import gleam/bool
// import gleam/int
// import gleam/io
// import gleam/list.{type ContinueOrStop, Continue, Stop}
// import gleam/option.{type Option, None, Some}
// import gleam/order.{type Order}

// import day2/problem1
// import day2/shared.{type Report}

// type Accumulator {
//   Accumulator(last_level: Int, order: Order, dampener_used: Bool, rest: Report)
//   Failed
// }

// pub fn problem2(reports: List(Report)) -> Int {
//   list.count(reports, is_report_safe)
// }

// pub fn is_report_safe(report: Report) -> Bool {
//   let assert [first_level, second_level, ..rest] = report
//   case dampener_needed(first_level, second_level, None, 3) {
//     False ->
//       Accumulator(
//         second_level,
//         int.compare(first_level, second_level),
//         False,
//         rest,
//       )
//     True -> {
//       let assert [third_level, ..rest] = rest
//       case dampener_needed(first_level, third_level, None, 3) {
//         False ->
//           Accumulator(
//             third_level,
//             int.compare(first_level, third_level),
//             True,
//             rest,
//           )
//         True ->
//           case dampener_needed(second_level, third_level, None, 3) {
//             False ->
//               Accumulator(
//                 third_level,
//                 int.compare(second_level, third_level),
//                 True,
//                 rest,
//               )
//             True -> Failed
//           }
//       }
//     }
//   }
//   |> check_report_recursive
//   //   case check_report_recursive(accumulator) {
//   //     Accumulator(_, _, _, _) -> True
//   //     Failed -> False
//   //   }
// }

// fn check_report_recursive(acc: Accumulator) -> Bool {
//   case acc {
//     Accumulator(previous_level, order, dampener_used, [next_level, ..rest]) -> {
//       case
//         dampener_needed(previous_level, next_level, Some(order), 3),
//         dampener_used
//       {
//         True, True -> False
//         needed, used ->
//           check_report_recursive(Accumulator(
//             next_level,
//             order,
//             needed && used,
//             rest,
//           ))
//       }
//     }
//     Failed -> False
//     Accumulator(_, _, _, []) -> True
//   }
// }

// fn dampener_needed(
//   level1: Int,
//   level2: Int,
//   previous_variation: Option(Order),
//   max_variation: Int,
// ) -> Bool {
//   use <- bool.guard(int.absolute_value(level1 - level2) > max_variation, True)
//   use <- bool.guard(level1 == level2, True)
//   let change = int.compare(level2, level1)
//   case previous_variation {
//     None -> False
//     Some(order.Eq) -> panic
//     Some(prev) -> bool.guard(change != prev, True, fn() { False })
//   }
// }
