import gleam/dict.{type Dict}
import gleam/int
import gleam/list.{Continue, Stop}
import gleam/option.{None, Some}
import gleam/result
import gleam/string
import simplifile

pub type PageOrderBlacklist =
  Dict(Int, List(Int))

pub type Manual {
  Manual(pages: List(Int), middle: Int)
}

pub fn get_input(input_file: String) -> #(PageOrderBlacklist, List(Manual)) {
  let assert Ok(content) = simplifile.read(input_file)
  let assert Ok(#(rules, prints)) = string.split_once(content, "\n\n")
  let rules: PageOrderBlacklist = {
    use rulebook, line <- list.fold(string.split(rules, "\n"), dict.new())
    let assert Ok(#(num1, num2)) = string.split_once(line, "|")
    let assert Ok(page1) = int.parse(num1)
    let assert Ok(page2) = int.parse(num2)
    use option_rules <- dict.upsert(rulebook, page1)
    case option_rules {
      None -> [page2]
      Some(rules) -> [page2, ..rules]
    }
  }

  let manuals: List(Manual) = {
    use print <- list.map(string.split(prints, "\n"))
    let pages = string.split(print, ",")
    {
      use page <- list.map(pages)
      let assert Ok(page_number) = int.parse(page)
      page_number
    }
    |> manual_from_page_numbers
  }
  #(rules, manuals)
}

pub fn contains_any(list: List(a), any: List(a)) -> Bool {
  list.any(list, fn(val) { list.contains(any, val) })
}

pub fn manual_from_page_numbers(pages: List(Int)) -> Manual {
  let middle_index = list.length(pages) / 2
  use manual, page, index <- list.index_fold(
    pages,
    Manual(pages: [], middle: 0),
  )
  let middle = case index == middle_index {
    False -> manual.middle
    True -> page
  }
  Manual(list.append(manual.pages, [page]), middle)
}

pub fn is_manual_valid(manual: Manual, blacklist: PageOrderBlacklist) -> Bool {
  case
    {
      use index, page <- list.fold_until(manual.pages, 0)
      let #(preceding_pages, _) = list.split(manual.pages, index)
      let blacklisted = result.unwrap(dict.get(blacklist, page), [])
      case contains_any(preceding_pages, blacklisted) {
        False -> Continue(index + 1)
        True -> Stop(-1)
      }
    }
  {
    -1 -> False
    _ -> True
  }
}
