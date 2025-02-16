//检查字符串是否为纯数字
///|
pub fn is_number(str : String) -> Bool {
  if str.length() == 0 {
    return false
  }
  let mut start = 0
  //处理负号
  if str[0] == '-' {
    if str.length() == 1 {
      return false
    }
    start = 1
  }

  //检查每个字符
  for i = start; i < str.length(); i = i + 1 {
    if str[i] > '9' || str[i] < '0' {
      return false
    }
  }
  true
}

//验证字符串是否全部为中文
///|
pub fn is_chinese(str : String) -> Bool {
  if str.length() == 0 {
    return false
  }
  //检查每个字符是否在中文编码范围内
  //中文字符Unicode范围：\u4e00-\u9fa5
  for i = 0; i < str.length(); i = i + 1 {
    let code = str[i].to_int()
    if code < 0x4e00 || code > 0x9fa5 {
      return false
    }
  }
  true
}

// 检查日期格式密码
///|
pub fn is_valid_date(year : Int, month : Int, day : Int) -> Bool {
  year >= 1950 &&
  year < 2050 &&
  month >= 1 &&
  month <= 12 &&
  day >= 1 &&
  day <= 31
}

///|
pub fn is_all_numeric(s : String) -> Bool {
  for i = 0; i < s.length(); i = i + 1 {
    if s[i] < '0' || s[i] > '9' {
      return false
    }
  }
  true
}

///|
pub fn is_windows_path(str : String) -> Bool {
  if str.length() < 3 {
    return false
  }

  // 检查盘符格式 (X:)
  if ((str[0] >= 'A' && str[0] <= 'Z') || (str[0] >= 'a' && str[0] <= 'z')) ==
    false ||
    str[1] != ':' ||
    (str[2] != '\\' && str[2] != '/') {
    return false
  }

  // 检查是否包含非法字符
  let invalid_chars = "<>:\"|?*"
  for i = 3; i < str.length(); i = i + 1 {
    for j = 0; j < invalid_chars.length(); j = j + 1 {
      if str[i] == invalid_chars[j] {
        return false
      }
    }
  }

  // 检查是否以点或空格结尾
  let last_char = str[str.length() - 1]
  if last_char == '.' || last_char == ' ' {
    return false
  }
  true
}

///|
pub fn is_linux_path(str : String) -> Bool {
  if str.length() == 0 {
    return false
  }

  // 检查非法字符
  let invalid_chars = "<>:|\"\\?*"
  for i = 0; i < str.length(); i = i + 1 {
    // 检查空格
    if str[i] == ' ' {
      return false
    }
    // 检查其他非法字符
    for j = 0; j < invalid_chars.length(); j = j + 1 {
      if str[i] == invalid_chars[j] {
        return false
      }
    }
  }

  // 检查连续斜杠
  for i = 0; i < str.length() - 1; i = i + 1 {
    if str[i] == '/' && str[i + 1] == '/' {
      return false
    }
  }
  true
}

///|
pub fn to_underline_case(str : String) -> String {
  to_symbol_case(str, '_')
}

///| 
// 转换为连字符命名
pub fn to_kebab_case(str : String) -> String {
  to_symbol_case(str, '-')
}

///| 
// 转换为符号连接的命名
pub fn to_symbol_case(str : String, symbol : Char) -> String {
  if str.length() == 0 {
    return ""
  }
  let mut result = ""
  for i = 0; i < str.length(); i = i + 1 {
    let c = str[i]
    if c >= 'A' && c <= 'Z' {
      let prev_char = if i > 0 { str[i - 1] } else { Char::from_int(0) }
      let next_char = if i < str.length() - 1 {
        str[i + 1]
      } else {
        Char::from_int(0)
      }
      if prev_char == symbol {
        // 前一个为分隔符
        if next_char == Char::from_int(0) ||
          (next_char >= 'a' && next_char <= 'z') {
          result = result + c.to_string()
        } else {
          result = result + c.to_string()
        }
      } else if prev_char >= 'a' && prev_char <= 'z' {
        // 前一个为小写
        result = result + symbol.to_string() + char_to_lower(c).to_string()
      } else if prev_char >= 'A' && prev_char <= 'Z' {
        // 前一个为大写
        if next_char >= 'a' && next_char <= 'z' {
          result = result + symbol.to_string() + char_to_lower(c).to_string()
        } else {
          result = result + c.to_string()
        }
        // 首字母
      } else if next_char == Char::from_int(0) ||
        (next_char >= 'a' && next_char <= 'z') {
        result = result + char_to_lower(c).to_string()
      } else {
        result = result + c.to_string()
      }
    } else {
      result = result + c.to_string()
    }
  }
  result
}

///| 
// 转换为帕斯卡命名法（首字母大写的驼峰命名）
pub fn to_pascal_case(str : String) -> String {
  let camel = to_camel_case(str)
  if camel.length() > 0 {
    char_to_upper(camel[0]).to_string() +
    camel.substring(start=1, end=camel.length())
  } else {
    ""
  }
}

///| 
// 转换为驼峰命名法
pub fn to_camel_case(str : String) -> String {
  to_camel_case_with_symbol(str, '_', true)
}

///| 
// 使用指定符号转换为驼峰命名法
pub fn to_camel_case_with_symbol(
  str : String,
  symbol : Char,
  other_char_to_lower : Bool
) -> String {
  if str.length() == 0 {
    return ""
  }
  let mut result = ""
  let mut upper_case = false
  for i = 0; i < str.length(); i = i + 1 {
    let c = str[i]
    if c == symbol {
      upper_case = true
    } else if upper_case {
      result = result + char_to_upper(c).to_string()
      upper_case = false
    } else {
      result = result +
        (if other_char_to_lower {
          char_to_lower(c).to_string()
        } else {
          c.to_string()
        })
    }
  }
  result
}

///|
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
