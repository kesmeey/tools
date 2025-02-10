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
pub fn is_credit_code_simple(code : String) -> Bool {
  if code.length() != 18 {
    return false
  }
  let re = @regexp.compile?(CREDIT_CODE_PATTERN).unwrap().matches(code)
  let result = re.success()
  result
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
pub fn is_valid_email(email : String) -> Bool {
  if email.length() < 6 { // 最短的邮箱 a@b.cc
    return false
  }

  // 基本格式检查
  if email.contains("@") == false || email.contains(".") == false {
    return false
  }

  // 正则验证
  let re = @regexp.compile?(EMAIL_PATTERN).unwrap().matches(email)
  let result = re.success()
  result
}

// ...existing code...

///| 验证增值税普通、专用发票代码、货物运输业增值税专用发票
pub fn is_valid_vat_code_10(code : String) -> Bool {
  if code.length() != 10 {
    return false
  }
  let re = @regexp.compile?(VAT_CODE_10).unwrap().matches(code)
  re.success()
}

///| 验证增值税电子普通、普通（卷票）、区块链电子发票
pub fn is_valid_vat_code_12(code : String) -> Bool {
  if code.length() != 12 {
    return false
  }
  let re = @regexp.compile?(VAT_CODE_12).unwrap().matches(code)
  re.success()
}

///| 验证工商注册码
pub fn is_valid_business_registration_no(code : String) -> Bool {
  if code.length() != 15 {
    return false
  }
  let re = @regexp.compile?(BUSINESS_REGISTRATION_NO).unwrap().matches(code)
  re.success()
}

///| 验证法人和其他组织统一社会信用代码
pub fn is_valid_unified_social_credit_code(code : String) -> Bool {
  if code.length() != 18 {
    return false
  }
  let re = @regexp.compile?(UNIFIED_SOCIAL_CREDIT_CODE).unwrap().matches(code)
  re.success()
}

///| 验证中国大陆护照
pub fn is_valid_chinese_passport(code : String) -> Bool {
  let re = @regexp.compile?(CHINESE_PASSPORT).unwrap().matches(code)
  re.success()
}

///| 验证通用护照
pub fn is_valid_general_passport(code : String) -> Bool {
  if code.length() < 5 || code.length() > 9 {
    return false
  }
  let re = @regexp.compile?(GENERAL_PASSPORT).unwrap().matches(code)
  re.success()
}

///| 验证纳税人识别号
pub fn is_valid_taxpayer_id(code : String) -> Bool {
  if code.length() < 15 || code.length() > 20 {
    return false
  }
  let re = @regexp.compile?(TAXPAYER_ID).unwrap().matches(code)
  re.success()
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
