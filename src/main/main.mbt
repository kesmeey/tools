///|
/// 
fn main {
  print(@tools.contains_emoji("aaa")) //flase
  print(@tools.contains_emoji("❤️大")) //true
  print(@tools.contains_emoji("☀️")) //true

}

