// 基础代码字符集
///|
const BASE_CODE_ARRAY = "0123456789ABCDEFGHJKLMNPQRTUWXY"

///|
const CREDIT_CODE_PATTERN = "^[0-9A-HJ-NPQRTUWXY]{2}\\d{6}[0-9A-HJ-NPQRTUWXY]{10}$"

///|
const EMAIL_PATTERN = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$"

// 简单校验统一社会信用代码格式
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
