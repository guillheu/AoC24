import gleam/int
import gleam/list
import gleam/string
import simplifile

pub type Report =
  List(Int)

pub fn get_reports(input_file: String) -> List(Report) {
  let assert Ok(data) = simplifile.read(input_file)
  use line <- list.map(string.split(data, "\n"))
  use report, level_string <- list.fold(string.split(line, " "), [])
  let assert Ok(level_value) = int.parse(level_string)
  [level_value, ..report]
}
