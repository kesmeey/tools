///|
fn main {
  let valid_email = "test@example.com"
  let invalid_email = "testexample.com"
  println(@tools.is_valid_email(valid_email)) // true
  println(@tools.is_valid_email(invalid_email))//false
}
