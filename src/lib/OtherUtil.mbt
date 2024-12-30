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
