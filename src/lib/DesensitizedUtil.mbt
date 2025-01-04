// 脱敏类型枚举
///|
pub(all) enum DesensitizedType {
  UserId    // 用户ID
  ChineseName // 中文姓名 
  IdCard        // 身份证号
  FixedPhone        // 固定电话
  MobilePhone   // 手机号
  Address   // 地址 
  Email  // 邮箱
  Password // 密码
  CarLicense    // 车牌号
  BankCard      // 银行卡号
  IPV4    // IPV4
  IPV6    // IPV6
  FirstMask     // 仅显示第一个字符
  ClearToEmpty  // 清空 
  ClearToNull     // 置空
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
fn chinese_name(name : String) -> String {
  if name.length() == 0 {
    return ""
  }
  name[0].to_string() + "**"
}

// 身份证脱敏

///|
fn id_card(id : String, front : Int, end : Int) -> String {
  if id.length() == 0 || front + end > id.length() || front < 0 || end < 0 {
    return ""
  }
  hide(id, front, id.length() - end)
}

// 固定电话脱敏

///|
fn fixed_phone(phone : String) -> String {
  if phone.length() == 0 {
    return ""
  }
  hide(phone, 4, phone.length() - 2)
}

// 手机号脱敏

///|
fn mobile_phone(phone : String) -> String {
  if phone.length() == 0 {
    return ""
  }
  hide(phone, 3, phone.length() - 4)
}

// 邮箱脱敏

///|
fn email(email : String) -> String {
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
fn hide(str : String, start : Int, end : Int) -> String {
  if start >= end {
    return str
  }
  str.substring(start=0, end=start) +
  "*".repeat(end - start) +
  str.substring(start=end, end=str.length())
}

// 地址脱敏
///|
fn address(addr : String, sensitive_size : Int) -> String {
  if addr.length() == 0 {
    return ""
  }
  let length = addr.length()
  hide(addr, length - sensitive_size, length)
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
fn car_license(license : String) -> String {
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
fn bank_card(card : String) -> String {
  if card.length() < 9 {
    return card
  }
  let length = card.length()
  let end_length = if length % 4 == 0 { 4 } else { length % 4 }
  let mid_length = length - 4 - end_length
  let mut result = card.substring(start=0, end=4)
  result = result + " " + "*".repeat(mid_length)
  result + " " + card.substring(start=length - end_length, end=length)
}

// IPv4地址脱敏
///|
fn ipv4(ip : String) -> String {
  if ip.length() == 0 {
    return ""
  }
  let first_part = ip.substring(start=0, end=ip.index_of("."))
  first_part + ".*.*.*"
}

// IPv6地址脱敏
///|
fn ipv6(ip : String) -> String {
  if ip.length() == 0 {
    return ""
  }
  let first_part = ip.substring(start=0, end=ip.index_of(":"))
  first_part + ":*:*:*:*:*:*:*"
}

// 仅显示第一个字符
///|
fn first_mask(str : String) -> String {
  if str.length() == 0 {
    return ""
  }
  hide(str, 1, str.length())
}
