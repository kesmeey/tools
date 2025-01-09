// 脱敏类型枚举
///|
pub(all) enum DesensitizedType {
  UserId // 用户ID
  ChineseName // 中文姓名 
  IdCard // 身份证号
  FixedPhone // 固定电话
  MobilePhone // 手机号
  Address // 地址 
  Email // 邮箱
  Password // 密码
  CarLicense // 车牌号
  BankCard // 银行卡号
  IPV4 // IPV4
  IPV6 // IPV6
  FirstMask // 仅显示第一个字符
  ClearToEmpty // 清空 
  ClearToNull // 置空
}

// 主脱敏函数

///|
pub fn desensitize(str : String, type_ : DesensitizedType) -> String {
  if str.length() == 0 {
    return ""
  }
  match type_ {
    DesensitizedType::UserId => "0"
    DesensitizedType::ChineseName => chinese_name(str)
    DesensitizedType::IdCard => id_card(str, 1, 2)
    DesensitizedType::FixedPhone => fixed_phone(str)
    DesensitizedType::MobilePhone => mobile_phone(str)
    DesensitizedType::Address => address(str, 8)
    DesensitizedType::Email => email(str)
    DesensitizedType::Password => password(str)
    DesensitizedType::CarLicense => car_license(str)
    DesensitizedType::BankCard => bank_card(str)
    DesensitizedType::IPV4 => ipv4(str)
    DesensitizedType::IPV6 => ipv6(str)
    DesensitizedType::FirstMask => first_mask(str)
    DesensitizedType::ClearToEmpty => ""
    DesensitizedType::ClearToNull => ""
  }
}

// 中文姓名脱敏

///|
pub fn chinese_name(name : String) -> String {
  if name.length() == 0 {
    return ""
  }
  match name.length() {
    1 => name + "*"
    2 => name[0].to_string() + "*"
    _ => name[0].to_string() + "**" // 3及以上字符
  }
}

// 身份证脱敏

///|
pub fn id_card(id : String, front : Int, end : Int) -> String {
  if id.length() == 0 || front + end > id.length() || front < 0 || end < 0 {
    return ""
  }
  hide(id, front, id.length() - end)
}

// 固定电话脱敏

///|
pub fn fixed_phone(phone : String) -> String {
  if phone.length() == 0 {
    return ""
  }

  // 查找"-"的位置
  let separator_index = phone.index_of("-")
  if separator_index < 0 {
    return hide(phone, 4, phone.length() - 2)
  }

  // 保留区号和分隔符
  let prefix = phone.substring(start=0, end=separator_index + 1)
  let number = phone.substring(start=separator_index + 1, end=phone.length())

  // 处理号码部分
  prefix +
  "*".repeat(number.length() - 4) +
  number.substring(start=number.length() - 4, end=number.length())
}

// 手机号脱敏

///|
pub fn mobile_phone(phone : String) -> String {
  if phone.length() == 0 {
    return ""
  }
  hide(phone, 3, phone.length() - 4)
}

// 邮箱脱敏

///|
pub fn email(email : String) -> String {
  if email.length() == 0 {
    return ""
  }
  let index = email.index_of("@")
  if index <= 1 {
    return email
  }
  hide(email, 1, index)
}

// 辅助函数: 隐藏字符串中间部分

///|
pub fn hide(str : String, start : Int, end : Int) -> String {
  if start >= end {
    return str
  }
  str.substring(start=0, end=start) +
  "*".repeat(end - start) +
  str.substring(start=end, end=str.length())
}

// 地址脱敏
///|
pub fn address(addr : String, sensitive_size : Int) -> String {
  if addr.length() == 0 {
    return ""
  }
  let prefix_len = 8
  let length = addr.length()
  addr.substring(start=0, end=prefix_len) +
  "*".repeat(addr.length() - prefix_len)
}

// 密码脱敏
///|
fn password(pwd : String) -> String {
  if pwd.length() == 0 {
    return ""
  }
  "*".repeat(pwd.length())
}

// 车牌号脱敏
///|
pub fn car_license(license : String) -> String {
  if license.length() == 0 {
    return ""
  }
  // 普通车牌
  if license.length() == 7 {
    hide(license, 3, 6)
  } else if license.length() == 8 {
    // 新能源车牌
    hide(license, 3, 7)
  } else {
    license
  }
}

// 银行卡号脱敏
///|
pub fn bank_card(card_no : String) -> String {
  if card_no.length() == 0 {
    return card_no
  }

  // 清除空格
  let card = card_no.replace_all(old=" ", new="")
  if card.length() < 9 {
    return card
  }
  let length = card.length()
  // 计算末尾保留位数(1-4位)
  let end_length = if length % 4 == 0 { 4 } else { length % 4 }
  // 计算中间需要用星号替换的位数
  let mid_length = length - 4 - end_length
  let mut result = card.substring(start=0, end=4)

  // 添加中间的星号
  for i = 0; i < mid_length; i = i + 1 {
    if i % 4 == 0 {
      result = result + " "
    }
    result = result + "*"
  }

  // 添加末尾数字
  result + " " + card.substring(start=length - end_length, end=length)
}

// IPv4地址脱敏
///|
pub fn ipv4(ip : String) -> String {
  if ip.length() == 0 {
    return ""
  }
  let first_part = ip.substring(start=0, end=ip.index_of("."))
  first_part + ".*.*.*"
}

// IPv6地址脱敏
///|
pub fn ipv6(ip : String) -> String {
  if ip.length() == 0 {
    return ""
  }
  let first_part = ip.substring(start=0, end=ip.index_of(":"))
  first_part + ":*:*:*:*:*:*:*"
}

// 仅显示第一个字符
///|
pub fn first_mask(str : String) -> String {
  if str.length() == 0 {
    return ""
  }
  hide(str, 1, str.length())
}
