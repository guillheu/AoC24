import simplifile

pub fn get_memory(input_file: String) -> String {
  let assert Ok(r) = simplifile.read(input_file)
  r
}
