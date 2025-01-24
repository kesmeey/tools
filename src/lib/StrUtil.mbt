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
pub fn is_windows_path(str: String) -> Bool {
    if str.length() < 3 {
        return false
    }
    
    // 检查盘符格式 (X:)
    if ((str[0] >= 'A' && str[0] <= 'Z') || (str[0] >= 'a' && str[0] <= 'z'))==false ||
        str[1] != ':' || (str[2] != '\\' && str[2] != '/') {
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

pub fn is_linux_path(str: String) -> Bool {
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