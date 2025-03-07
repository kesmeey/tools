// 基础代码字符集
///|
const BASE_CODE_ARRAY = "0123456789ABCDEFGHJKLMNPQRTUWXY"

///|
const CREDIT_CODE_PATTERN = "^[0-9A-HJ-NPQRTUWXY]{2}\\d{6}[0-9A-HJ-NPQRTUWXY]{10}$"

///|
const EMAIL_PATTERN = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$"

// 简单校验统一社会信用代码格式
///|
/// 
/// 
/// 
// ...existing code...

///| 增值税普通、专用发票代码、货物运输业增值税专用发票
const VAT_CODE_10 = "^\\d{8}[2-9][0-4]$"

///| 增值税电子普通、普通（卷票）、区块链电子发票
const VAT_CODE_12 = "^[01]\\d{11}$"

///| 工商注册码
const BUSINESS_REGISTRATION_NO = "^\\d{15}$"

///| 法人和其他组织统一社会信用代码
const UNIFIED_SOCIAL_CREDIT_CODE = "^[0-9A-HJ-NP-RTUW-Y]{2}\\d{6}[0-9A-HJ-NP-RTUW-Y]{10}$"

///| 中国大陆护照，不包含特区护照（港澳特区护照）
// 因私电子护照新字段2017.04启动，第二位使用字母，排除IO
// 因公电子护照2012开始启用
const CHINESE_PASSPORT = "^(?:G\\d{8}|[DSP]E?\\d{7}|E[0-9A-HJ-NP-Z]\\d{7})$"

///| 通用护照标准，按国际民航组织9303约定，最大不能超过9位
const GENERAL_PASSPORT = "^[0-9A-Za-z]{5,9}$"

///| 纳税人识别号
// 组织结构是15位，法人是20位
// 三证合一后的社会统一验证代码也是纳税人识别号
// 自然人是18位，对于一代身份证不清楚是否和法人一样补全3位0
// 其它证件（15位）无法获取校验位计算规则
const TAXPAYER_ID = "^[0-9A-HJ-NP-RTUW-Y]{15,20}$"

///|
pub fn char_to_lower(c : Char) -> Char {
  if 'A' <= c && c <= 'Z' {
    Char::from_int(c.to_int() + 'a'.to_int() - 'A'.to_int())
  } else {
    c
  }
}

///| 
// 将字符转换为大写
pub fn char_to_upper(c : Char) -> Char {
  if c >= 'a' && c <= 'z' {
    let code = c.to_int()
    Char::from_int(code - 32)
  } else {
    c
  }
}

///|
///| 简单校验统一社会信用代码格式
pub fn is_credit_code_simple(code : String) -> Bool {
  // 检查长度
  if code.length() != 18 {
    return false
  }

  // 检查前两位是否为数字或有效字母
  for i = 0; i < 2; i = i + 1 {
    let c = code[i]
    if (c < '0' || c > '9') &&
      (c < 'A' || c > 'H') &&
      (c < 'J' || c > 'N') &&
      (c < 'P' || c > 'R') &&
      (c < 'T' || c > 'U') &&
      (c < 'W' || c > 'Y') {
      return false
    }
  }

  // 检查中间6位是否为数字
  for i = 2; i < 8; i = i + 1 {
    if code[i] < '0' || code[i] > '9' {
      return false
    }
  }

  // 检查后10位是否为数字或有效字母
  for i = 8; i < 18; i = i + 1 {
    let c = code[i]
    if (c < '0' || c > '9') &&
      (c < 'A' || c > 'H') &&
      (c < 'J' || c > 'N') &&
      (c < 'P' || c > 'R') &&
      (c < 'T' || c > 'U') &&
      (c < 'W' || c > 'Y') {
      return false
    }
  }
  true
}

// 完整校验统一社会信用代码

///|
pub fn is_credit_code(code : String) -> Bool {
  if is_credit_code_simple(code) == false {
    return false
  }
  let parity = get_parity_bit(code)
  if parity < 0 {
    return false
  }
  code[17] == BASE_CODE_ARRAY[parity]
}

// 计算校验位

///|
fn get_parity_bit(code : String) -> Int {
  let weight = [1, 3, 9, 27, 19, 26, 16, 17, 20, 29, 25, 13, 8, 24, 10, 30, 28]
  let mut sum = 0
  for i = 0; i < 17; i = i + 1 {
    let c = code[i]
    let idx = BASE_CODE_ARRAY.index_of(c.to_string())
    if idx < 0 {
      return -1
    }
    sum += idx * weight[i]
  }
  let result = 31 - sum % 31
  if result == 31 {
    0
  } else {
    result
  }
}

///| 生成随机的统一社会信用代码
pub fn random_credit_code() -> String {
  let mut code = ""
  let r = @random.new()
  // 生成前2位
  for i = 0; i < 2; i = i + 1 {
    let idx = r.int(limit=BASE_CODE_ARRAY.length())
    code = code + BASE_CODE_ARRAY[idx].to_string()
  }

  // 生成中间6位数字
  for i = 0; i < 6; i = i + 1 {
    let idx = r.int(limit=10) // 只使用0-9
    code = code + BASE_CODE_ARRAY[idx].to_string()
  }

  // 生成后9位
  for i = 0; i < 9; i = i + 1 {
    let idx = r.int(limit=BASE_CODE_ARRAY.length())
    code = code + BASE_CODE_ARRAY[idx].to_string()
  }

  // 添加校验位
  let parity = get_parity_bit(code)
  code + BASE_CODE_ARRAY[parity].to_string()
}

///| 验证邮箱是否合法
///| 验证邮箱是否合法
pub fn is_valid_email(email : String) -> Bool {
  let len = email.length()
  if len < 6 { // 最短的邮箱 a@b.cc
    return false
  }

  // 查找@符号位置
  let mut at_pos = -1
  for i = 0; i < len; i = i + 1 {
    if email[i] == '@' {
      if at_pos != -1 {
        return false // 不能有多个@
      }
      at_pos = i
    }
  }
  if at_pos <= 0 || at_pos >= len - 3 {
    return false // @不能在开头或末尾附近
  }

  // 检查用户名部分
  let mut prev_special = false
  for i = 0; i < at_pos; i = i + 1 {
    let c = email[i]
    if (c >= 'a' && c <= 'z') ||
      (c >= 'A' && c <= 'Z') ||
      (c >= '0' && c <= '9') {
      prev_special = false
      continue
    }
    if c == '.' || c == '_' || c == '+' || c == '&' || c == '*' || c == '-' {
      if prev_special {
        return false // 不允许连续特殊字符
      }
      prev_special = true
      continue
    }
    return false // 其他字符都是非法的
  }

  // 检查域名部分
  let mut dot_pos = -1
  prev_special = true // 域名不能以点开头
  for i = at_pos + 1; i < len; i = i + 1 {
    let c = email[i]
    if (c >= 'a' && c <= 'z') ||
      (c >= 'A' && c <= 'Z') ||
      (c >= '0' && c <= '9') {
      prev_special = false
      continue
    }
    if c == '.' || c == '-' {
      if prev_special {
        return false // 不允许连续特殊字符
      }
      if c == '.' {
        dot_pos = i
      }
      prev_special = true
      continue
    }
    return false // 其他字符都是非法的
  }

  // 检查顶级域名
  if dot_pos == -1 || dot_pos >= len - 2 || prev_special {
    return false // 必须有顶级域名且至少2位
  }

  // 检查顶级域名是否全是字母
  for i = dot_pos + 1; i < len; i = i + 1 {
    let c = email[i]
    if c < 'a' && c > 'z' && c < 'A' && c > 'Z' {
      return false
    }
  }
  true
}

///| 验证增值税普通、专用发票代码、货物运输业增值税专用发票
pub fn is_valid_vat_code_10(code : String) -> Bool {
  // 检查长度
  if code.length() != 10 {
    return false
  }

  // 检查前8位是否为数字
  for i = 0; i < 8; i = i + 1 {
    if code[i] < '0' || code[i] > '9' {
      return false
    }
  }

  // 检查第9位是否在2-9之间
  let ninth = code[8]
  if ninth < '2' || ninth > '9' {
    return false
  }

  // 检查第10位是否在0-4之间
  let tenth = code[9]
  if tenth < '0' || tenth > '4' {
    return false
  }
  true
}

///| 验证增值税电子普通、普通（卷票）、区块链电子发票
pub fn is_valid_vat_code_12(code : String) -> Bool {
  // 检查长度
  if code.length() != 12 {
    return false
  }

  // 检查第一位是否为0或1
  if code[0] != '0' && code[0] != '1' {
    return false
  }

  // 检查后11位是否都是数字
  for i = 1; i < 12; i = i + 1 {
    if code[i] < '0' || code[i] > '9' {
      return false
    }
  }
  true
}

///| 验证工商注册码
pub fn is_valid_business_registration_no(code : String) -> Bool {
  // 检查长度
  if code.length() != 15 {
    return false
  }

  // 检查是否全为数字
  for i = 0; i < 15; i = i + 1 {
    if code[i] < '0' || code[i] > '9' {
      return false
    }
  }
  true
}

///| 验证法人和其他组织统一社会信用代码
pub fn is_valid_unified_social_credit_code(code: String) -> Bool {
    // 检查长度
    if code.length() != 18 {
        return false
    }
    
    // 检查每一位字符是否合法
    for i = 0; i < 18; i = i + 1 {
        let c = code[i]
        // 检查是否为数字
        let is_digit = c >= '0' && c <= '9'
        // 检查是否为有效字母 (排除I、O、S、V、Z)
        let is_valid_letter = (c >= 'A' && c <= 'H') || 
                            (c >= 'J' && c <= 'N') || 
                            (c >= 'P' && c <= 'R') || 
                            (c >= 'T' && c <= 'U') || 
                            (c >= 'W' && c <= 'Y')
                            
        if is_digit==false && is_valid_letter==false {
            return false
        }
    }
    
    // 检查前两位字符
    let first_two = code.substring(start=0, end=2)
    for i = 0; i < 2; i = i + 1 {
        let c = first_two[i]
        if (c < '0' || c > '9') && 
           (c < 'A' || c > 'H') && 
           (c < 'J' || c > 'N') && 
           (c < 'P' || c > 'R') && 
           (c < 'T' || c > 'U') && 
           (c < 'W' || c > 'Y') {
            return false
        }
    }
    
    // 检查中间6位是否为数字
    for i = 2; i < 8; i = i + 1 {
        if code[i] < '0' || code[i] > '9' {
            return false
        }
    }
    
    // 检查后10位是否符合规则
    for i = 8; i < 18; i = i + 1 {
        let c = code[i]
        if (c < '0' || c > '9') && 
           (c < 'A' || c > 'H') && 
           (c < 'J' || c > 'N') && 
           (c < 'P' || c > 'R') && 
           (c < 'T' || c > 'U') && 
           (c < 'W' || c > 'Y') {
            return false
        }
    }
    
    true
}


///| 验证中国大陆护照
pub fn is_valid_chinese_passport(code : String) -> Bool {
  let len = code.length()
  if len != 8 && len != 9 {
    return false
  }
  let first = code[0]
  // 验证第一位字母
  if first == 'G' {
    if len != 9 {
      return false
    }
    // G开头必须后跟8位数字
    for i = 1; i < 9; i = i + 1 {
      if code[i] < '0' || code[i] > '9' {
        return false
      }
    }
  } else if first == 'D' || first == 'S' || first == 'P' {
    if len != 8 {
      return false
    }
    // 可能有E
    let mut start = 1
    if code[1] == 'E' {
      start = 2
    }
    // 后面必须是7位数字
    for i = start; i < 8; i = i + 1 {
      if code[i] < '0' || code[i] > '9' {
        return false
      }
    }
  } else if first == 'E' {
    if len != 9 {
      return false
    }
    // 第二位是字母(排除IO)且不能是I或O
    let second = code[1]
    if second < 'A' || second > 'Z' || second == 'I' || second == 'O' {
      return false
    }
    // 后7位必须是数字
    for i = 2; i < 9; i = i + 1 {
      if code[i] < '0' || code[i] > '9' {
        return false
      }
    }
  } else {
    return false
  }
  true
}

///| 验证通用护照
pub fn is_valid_general_passport(code : String) -> Bool {
  let len = code.length()
  if len < 5 || len > 9 {
    return false
  }

  // 检查是否只包含字母和数字
  for i = 0; i < len; i = i + 1 {
    let c = code[i]
    if (c < '0' || c > '9') && (c < 'A' || c > 'Z') && (c < 'a' || c > 'z') {
      return false
    }
  }
  true
}

///| 验证纳税人识别号
pub fn is_valid_taxpayer_id(code : String) -> Bool {
  let len = code.length()
  if len < 15 || len > 20 {
    return false
  }

  // 检查是否只包含数字和有效的大写字母(排除I,O等)
  for i = 0; i < len; i = i + 1 {
    let c = code[i]
    if (c < '0' || c > '9') && (c < 'A' || c > 'Z' || c == 'I' || c == 'O') {
      return false
    }
  }
  true
}

///|
pub fn is_valid_car_license(plate : String) -> Bool {
  let plate = plate.to_upper()
  if plate.length() != 7 && plate.length() != 8 {
    return false
  }

  // 验证第一位是否为省份简称首字
  let first_char = plate[0]
  let valid_provinces = "京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼"
  if valid_provinces.contains(first_char.to_string()) == false {
    return false
  }

  // 验证第二位是否为字母
  let second_char = plate[1]
  if (second_char >= 'A' && second_char <= 'Z') == false {
    return false
  }

  // 验证第三位
  let third_char = plate[2]
  if third_char == 'D' || third_char == 'F' {
    // 新能源车牌，检查后四位是否为字母或数字
    for i = 3; i < 8; i = i + 1 {
      let c = plate[i]
      if ((c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z')) == false {
        return false
      }
    }
  } else {
    // 普通车牌，检查后五位是否为字母或数字
    for i = 2; i < 7; i = i + 1 {
      let c = plate[i]
      if ((c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z')) == false {
        return false
      }
    }
  }
  true
}

///|
test "car_license_validation" {
  // 有效的普通车牌
  assert_true!(is_valid_car_license("京A12345"))
  assert_true!(is_valid_car_license("沪B88888"))
  assert_true!(is_valid_car_license("粤C123AB"))
  assert_true!(is_valid_car_license("津D56789"))
  assert_true!(is_valid_car_license("冀E67890"))

  //有效的新能源车牌
  assert_true!(is_valid_car_license("沪BD67890"))
  assert_true!(is_valid_car_license("川CF54321"))
  assert_true!(is_valid_car_license("京AD12345"))

  //无效的车牌
  assert_false!(is_valid_car_license("A123456")) // 缺少省份
  assert_false!(is_valid_car_license("京123456")) // 缺少字母
  assert_false!(is_valid_car_license("京A123")) // 长度不足
  assert_false!(is_valid_car_license("京A1234567")) // 长度超出

  // 特殊字符测试
  assert_false!(is_valid_car_license("京A123#5")) // 包含特殊字符
  assert_false!(is_valid_car_license("京A123 5")) // 包含空格
  assert_false!(is_valid_car_license("京A123中文")) // 包含汉字

  // 边界情况测试
  assert_false!(is_valid_car_license("")) // 空字符串
  assert_false!(is_valid_car_license("京")) // 只有省份
  assert_false!(is_valid_car_license("京A")) // 只有省份和字母
  assert_false!(is_valid_car_license("ABCDEFG")) // 全是字母
  assert_false!(is_valid_car_license("1234567")) // 全是数字
}

///|
test "email_validation" {
  // 有效的邮箱格式
  assert_true!(is_valid_email("test@example.com"))
  assert_true!(is_valid_email("test.name@example.com"))
  assert_true!(is_valid_email("test+tag@example.com"))
  assert_true!(is_valid_email("test@sub.example.com"))
  assert_true!(is_valid_email("test_name@example.com"))
  assert_true!(is_valid_email("test-name@example.com"))
  assert_true!(is_valid_email("123@example.com"))
  assert_true!(is_valid_email("test@example.co.uk"))

  // 特殊字符组合
  assert_true!(is_valid_email("test.name+tag@example.com"))
  assert_true!(is_valid_email("test&name@example.com"))
  assert_true!(is_valid_email("test_name-123@example.com"))

  // 无效格式
  assert_false!(is_valid_email("")) // 空字符串
  assert_false!(is_valid_email("test")) // 无@符号
  assert_false!(is_valid_email("@example.com")) // 无用户名
  assert_false!(is_valid_email("test@")) // 无域名
  assert_false!(is_valid_email("test@.com")) // 无子域名
  assert_false!(is_valid_email("test@com")) // 无点号

  // 特殊情况
  assert_false!(is_valid_email("test@example")) // 无顶级域名
  assert_false!(is_valid_email("test..name@example.com")) // 连续点号
  assert_false!(is_valid_email("test#@example.com")) // 非法字符
  assert_false!(is_valid_email("test@exa#mple.com")) // 域名包含非法字符
  assert_false!(is_valid_email("test@example.c")) // 顶级域名过短
}

///|
test "credit_code_validation" {
  // 有效的统一社会信用代码
  assert_true!(is_credit_code("91630000200896788D")) // 标准格式
  assert_true!(is_credit_code("N2548026U6W1TW9PH0")) // 数字结尾

  // 无效的格式
  assert_false!(is_credit_code("012345678987654321")) // 纯数字
  assert_false!(is_credit_code("ABCDEFGHIJKLMNOPQR")) // 纯字母
  assert_false!(is_credit_code("9131000#MA1K35Y00G")) // 包含特殊字符

  // 长度测试
  assert_false!(is_credit_code("91310000")) // 太短
  assert_false!(is_credit_code("913100000000000MA1K35Y00G1")) // 太长
  assert_false!(is_credit_code("")) // 空字符串

  // 校验位测试
  assert_false!(is_credit_code("91310000MA1K35Y00A")) // 错误的校验位
  assert_false!(is_credit_code("91310000MA1K35Y001")) // 错误的校验位

  // 特殊情况测试
  assert_false!(is_credit_code("91310000MA1K35YO0G")) // 包含O(字母)
  assert_false!(is_credit_code("91310000MA1K35YI0G")) // 包含I(字母)
  assert_false!(is_credit_code("91310000MA1K35Y 0G")) // 包含空格
}


///|
test "validate_vat_code_10" {
  assert_eq!(is_valid_vat_code_10("1234567894"), true)
  assert_eq!(is_valid_vat_code_10("12345678"), false) // 长度不足
  assert_eq!(is_valid_vat_code_10("1234567895"), false) // 最后一位超出范围
}

///|
test "validate_vat_code_12" {
  assert_eq!(is_valid_vat_code_12("012345678901"), true)
  assert_eq!(is_valid_vat_code_12("123456789012"), false)
  assert_eq!(is_valid_vat_code_12("01234567890"), false) // 长度不足
  assert_eq!(is_valid_vat_code_12("212345678901"), false) // 首位无效
}

///|
test "validate_business_registration_no" {
  assert_eq!(is_valid_business_registration_no("123456789012345"), true)
  assert_eq!(is_valid_business_registration_no("12345678901234"), false) // 长度不足
  assert_eq!(is_valid_business_registration_no("12345678901234A"), false) // 包含字母
}

///|
test "validate_unified_social_credit_code" {
  assert_eq!(is_valid_unified_social_credit_code("91110108MA01234567"), true)
  assert_eq!(is_valid_unified_social_credit_code("9111010MA0123456"), false) // 长度不足
  assert_eq!(is_valid_unified_social_credit_code("91110108MA0123456I"), false) // 包含无效字符
}

///|
test "validate_chinese_passport" {
  assert_eq!(is_valid_chinese_passport("G12345678"), true)
  assert_eq!(is_valid_chinese_passport("EA1234567"), true)
  assert_eq!(is_valid_chinese_passport("P1234567"), true)
  assert_eq!(is_valid_chinese_passport("12345678"), false) // 无效格式
  assert_eq!(is_valid_chinese_passport("EI1234567"), false) // 无效字母
}

///|
test "validate_general_passport" {
  assert_eq!(is_valid_general_passport("12345"), true)
  assert_eq!(is_valid_general_passport("123456789"), true)
  assert_eq!(is_valid_general_passport("ABCDE"), true)
  assert_eq!(is_valid_general_passport("1234"), false) // 长度不足
  assert_eq!(is_valid_general_passport("1234567890"), false) // 长度超出
}

///|
test "validate_taxpayer_id" {
  assert_eq!(is_valid_taxpayer_id("123456789012345"), true)
  assert_eq!(is_valid_taxpayer_id("12345678901234567890"), true)
  assert_eq!(is_valid_taxpayer_id("1234567890"), false) // 长度不足
  assert_eq!(is_valid_taxpayer_id("123456789012345I"), false) // 包含无效字符
}
