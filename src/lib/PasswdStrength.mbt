// 密码等级枚举
///|
enum PasswdLevel {
  Easy
  Medium
  Strong
  VeryStrong
  ExtremelyStrong
}

///|

// 字符类型枚举

///|
enum CharType {
  Num
  SmallLetter
  CapitalLetter
  OtherChar
}

// 简单密码字典
///|
let dictionary = [
  "password", "abc123", "iloveyou", "adobe123", "123123", "sunshine", "1314520",
  "a1b2c3", "123qwe", "aaa111", "qweasd", "admin", "passwd",
]

///|
let size_table = [9, 99, 999, 9999, 99999, 999999, 9999999, 99999999, 999999999]

// 数字长度表

// 检查字符类型
///|
fn check_char_type(c : Char) -> CharType {
  if c >= '0' && c <= '9' {
    CharType::Num
  } else if c >= 'A' && c <= 'Z' {
    CharType::CapitalLetter
  } else if c >= 'a' && c <= 'z' {
    CharType::SmallLetter
  } else {
    CharType::OtherChar
  }
}

///|
pub impl Eq for CharType with op_equal(self, other : CharType) -> Bool {
  match (self, other) {
    (CharType::Num, CharType::Num) => true
    (CharType::SmallLetter, CharType::SmallLetter) => true
    (CharType::CapitalLetter, CharType::CapitalLetter) => true
    (CharType::OtherChar, CharType::OtherChar) => true
    _ => false
  }
}

// 计算指定类型字符数量
///|
fn count_letter(passwd : String, type_ : CharType) -> Int {
  let mut count = 0
  for i = 0; i < passwd.length(); i = i + 1 {
    if check_char_type(passwd[i]) == type_ {
      count += 1
    }
  }
  count
}

// 获取整数位数
///|
fn size_of_int(x : Int) -> Int {
  for i = 0; i < size_table.length(); i = i + 1 {
    if x <= size_table[i] {
      return i + 1
    }
  }
  10
}

// 检查密码强度
///|
pub fn check_password(passwd : String) -> Int {
  if passwd.length() == 0 {
    return 0
  }
  let len = passwd.length()
  let mut level = 0

  // 增加分数
  if count_letter(passwd, CharType::Num) > 0 {
    level += 1
  }
  if count_letter(passwd, CharType::SmallLetter) > 0 {
    level += 1
  }
  if len > 4 && count_letter(passwd, CharType::CapitalLetter) > 0 {
    level += 1
  }
  if len > 6 && count_letter(passwd, CharType::OtherChar) > 0 {
    level += 1
  }

  // 组合加分
  let num_count = count_letter(passwd, CharType::Num)
  let small_count = count_letter(passwd, CharType::SmallLetter)
  let capital_count = count_letter(passwd, CharType::CapitalLetter)
  let other_count = count_letter(passwd, CharType::OtherChar)
  if len > 4 &&
    (
      (num_count > 0 && small_count > 0) ||
      (num_count > 0 && capital_count > 0) ||
      (num_count > 0 && other_count > 0) ||
      (small_count > 0 && capital_count > 0) ||
      (small_count > 0 && other_count > 0) ||
      (capital_count > 0 && other_count > 0)
    ) {
    level += 1
  }

  // 特殊字符加分
  if other_count >= 3 {
    level += 1
  }
  if other_count >= 6 {
    level += 1
  }
  // 长度加分
  if len > 12 {
    level += 1
    if len >= 16 {
      level += 1
    }
  }
  if len % 3 == 0 {
    let part1 = passwd.substring(end=len / 3)
    let part2 = passwd.substring(start=len / 3, end=len / 3 * 2)
    let part3 = passwd.substring(start=len / 3 * 2, end=len)
    if part1 == part2 && part2 == part3 {
      level -= 1
    }
  }
  if is_all_numeric(passwd) && len >= 6 && len <= 8 {
    let mut year = 0
    if len == 8 || len == 6 {
      year = @strconv.parse_int?(passwd.substring(start=0, end=len - 4)).unwrap()
    }
    let size = size_of_int(year)
    let month = @strconv.parse_int?(passwd.substring(start=size, end=size + 2)).unwrap()
    let day = @strconv.parse_int?(passwd.substring(start=size + 2, end=len)).unwrap()
    if is_valid_date(year, month, day) {
      level -= 1
    }
  }

  // 检查字典匹配
  for i = 0; i < dictionary.length(); i = i + 1 {
    let dict_word = dictionary[i]
    if passwd == dict_word || dict_word.index_of(passwd) >= 0 {
      level -= 1
      break
    }
  }
  for i = 0; i < dictionary.length(); i = i + 1 {
    let dict_word = dictionary[i]
    if passwd == dict_word || dict_word.index_of(passwd) >= 0 {
      level -= 1
      break
    }
  }
  // 降低分数
  // 检查连续字母
  if passwd.index_of("abcdefghijklmnopqrstuvwxyz") >= 0 ||
    passwd.index_of("ABCDEFGHIJKLMNOPQRSTUVWXYZ") >= 0 {
    level -= 1
  }

  // 检查键盘序列
  if passwd.index_of("qwertyuiop") >= 0 ||
    passwd.index_of("asdfghjkl") >= 0 ||
    passwd.index_of("zxcvbnm") >= 0 {
    level -= 1
  }

  // 检查纯数字、字母
  if num_count == len || small_count == len || capital_count == len {
    level -= 1
  }

  // 长度惩罚
  if len <= 6 {
    level -= 1
    if len <= 4 {
      level -= 1
      if len <= 3 {
        level = 0
      }
    }
  }

  // 防止负数
  if level < 0 {
    level = 0
  }
  level
}

// 获取密码强度等级
///|
pub fn get_password_level(passwd : String) -> PasswdLevel {
  let level = check_password(passwd)
  if level <= 3 {
    PasswdLevel::Easy
  } else if level <= 6 {
    PasswdLevel::Medium
  } else if level <= 9 {
    PasswdLevel::Strong
  } else if level <= 12 {
    PasswdLevel::VeryStrong
  } else {
    PasswdLevel::ExtremelyStrong
  }
}

///|
pub fn get_password_strength_text(passwd : String) -> String {
  let level = get_password_level(passwd)
  match level {
    PasswdLevel::Easy => "弱密码"
    PasswdLevel::Medium => "中等强度密码"
    PasswdLevel::Strong => "强密码"
    PasswdLevel::VeryStrong => "很强的密码"
    PasswdLevel::ExtremelyStrong => "极其强大的密码"
  }
}

///|
test "password_strength_text" {
  assert_eq!(get_password_strength_text("123456"), "弱密码")
  assert_eq!(get_password_strength_text("abc123ABC"), "中等强度密码")
  assert_eq!(get_password_strength_text("Abc123ojpj!@#"), "强密码")
}
