///|
fn main {
  let test1 = @tools.is_windows_path("C:\\Windows\\System32")
  println(test1) // true
  let test2 = @tools.is_windows_path("1:/Documents/test.txt")
  println(test2) // false
  let test3 = @tools.is_linux_path("/usr/local/bin")
  println(test3) // true
  let test4 = @tools.is_linux_path("/test//file")
  println(test4) // false 
}
