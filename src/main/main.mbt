///|
/// 
/// 
/// 
fn main {
  print(@tools.similar("hello", "hello")) //完全相同，输出1.0 
  print(@tools.similar("hello", "helo")) //大部分相同 0.8
  print(@tools.similar("你好世界", "你好地球")) //一半相同 0.5
  print(@tools.similar("", "")) //都为空，认为全部相同
}
