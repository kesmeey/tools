///|
test "is_number" {
  // 测试空字符串
  assert_false!(is_number(""))

  // 测试负数
  assert_true!(is_number("-123"))
  assert_false!(is_number("-"))

  // 测试正常数字
  assert_true!(is_number("0"))
  assert_true!(is_number("123"))
  assert_true!(is_number("9999"))

  // 测试非法字符
  assert_false!(is_number("12a3"))
  assert_false!(is_number("1.23"))
  assert_false!(is_number("-12-3"))
}

///|
test "is_chinese" {
  // 测试空字符串
  assert_false!(is_chinese(""))

  // 测试纯中文
  assert_true!(is_chinese("中文"))
  assert_true!(is_chinese("你好世界"))

  // 测试混合字符
  assert_false!(is_chinese("中文123"))
  assert_false!(is_chinese("Hello中文"))

  // 测试特殊字符
  assert_false!(is_chinese("中文。"))
  assert_false!(is_chinese("！中文"))
}

///|
test "windows_path" {
  assert_true!(is_windows_path("C:\\Windows\\System32"))
  assert_true!(is_windows_path("D:/Documents/test.txt"))
  assert_true!(is_windows_path("E:\\Program Files\\App"))
  assert_false!(is_windows_path(""))
  assert_false!(is_windows_path("C:"))
  assert_false!(is_windows_path("1:\\test"))
  assert_false!(is_windows_path("C:\\file?.txt"))
  assert_false!(is_windows_path("C:\\folder\\file."))
}

///|
test "linux_path" {
  assert_true!(is_linux_path("/usr/local/bin"))
  assert_true!(is_linux_path("./config.txt"))
  assert_true!(is_linux_path("../test/file.txt"))
  assert_true!(is_linux_path("/home/user/.bashrc"))
  assert_false!(is_linux_path(""))
  assert_false!(is_linux_path("/test//file"))
  assert_false!(is_linux_path("/usr/local/file?"))
  assert_false!(is_linux_path("/home/user/my file"))
}

///|
test "naming_case" {
  // 测试下划线命名
  assert_eq!(to_underline_case("helloWorld"), "hello_world")
  assert_eq!(to_underline_case("HelloWorld"), "hello_world")
  assert_eq!(to_underline_case("hello_world"), "hello_world")

  // 测试连字符命名
  assert_eq!(to_kebab_case("helloWorld"), "hello-world")
  assert_eq!(to_kebab_case("HelloWorld"), "hello-world")

  // 测试驼峰命名
  assert_eq!(to_camel_case("hello_world"), "helloWorld")

  // 测试帕斯卡命名
  assert_eq!(to_pascal_case("hello_world"), "HelloWorld")
}
