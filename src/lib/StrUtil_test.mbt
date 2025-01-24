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
