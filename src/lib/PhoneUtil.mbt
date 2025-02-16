// 定义正则表达式常量
///|
const MOBILE_CN = "^1[3-9]\\d{9}$" // 中国大陆手机号

///|
const MOBILE_HK = "^(?:(?:9\\d|6\\d|4[0-24-9])\\d{7})$" // 香港手机号

///|
const MOBILE_TW = "^(?:[89]\\d{8})$" // 台湾手机号

///|
const MOBILE_MO = "^(?:6[2356789]\\d{6})$" // 澳门手机号

///|
const TEL = "^(?:(?:\\d{3,4}-)?\\d{7,8})$" // 座机号码

///|
const TEL_400_800 = "^[48]00-?\\d{3}-?\\d{4}$" // 400/800电话

// 验证中国大陆手机号

///|
pub fn is_mobile_cn(phone : String) -> Bool {
  if phone.length() != 11 {
    return false
  }
  // 检查是否以1开头
  if phone[0] != '1' {
    return false
  }
  // 检查第二位是否在3-9之间
  if phone[1] < '3' || phone[1] > '9' {
    return false
  }
  // 检查剩余位是否都是数字
  for i = 2; i < 11; i = i + 1 {
    if phone[i] < '0' || phone[i] > '9' {
      return false
    }
  }
  true
}

// 验证香港手机号
///|
pub fn is_mobile_hk(phone : String) -> Bool {
  if phone.length() != 8 {
    return false
  }
  let first = phone[0]
  // 检查首位是否为4,6或9
  if first != '4' && first != '6' && first != '9' {
    return false
  }
  // 如果首位是4，第二位有限制
  if first == '4' {
    let second = phone[1]
    if second != '0' &&
      second != '2' &&
      second != '3' &&
      second != '4' &&
      second != '5' &&
      second != '6' &&
      second != '7' &&
      second != '8' &&
      second != '9' {
      return false
    }
  }
  // 检查剩余位是否都是数字
  for i = 1; i < 8; i = i + 1 {
    if phone[i] < '0' || phone[i] > '9' {
      return false
    }
  }
  true
}

// 验证台湾手机号
///|
pub fn is_mobile_tw(phone : String) -> Bool {
  if phone.length() != 9 {
    return false
  }
  // 检查首位是否为8或9
  if phone[0] != '8' && phone[0] != '9' {
    return false
  }
  // 检查剩余位是否都是数字
  for i = 1; i < 9; i = i + 1 {
    if phone[i] < '0' || phone[i] > '9' {
      return false
    }
  }
  true
}
// 验证澳门手机号

///|
pub fn is_mobile_mo(phone : String) -> Bool {
  if phone.length() != 8 {
    return false
  }
  // 检查首位是否为6
  if phone[0] != '6' {
    return false
  }
  // 检查第二位是否在2-9之间
  if phone[1] < '2' || phone[1] > '9' {
    return false
  }
  // 检查剩余位是否都是数字
  for i = 2; i < 8; i = i + 1 {
    if phone[i] < '0' || phone[i] > '9' {
      return false
    }
  }
  true
}

// 验证座机号码

///|
pub fn is_tel(phone : String) -> Bool {
  let len = phone.length()
  if len < 7 || len > 12 {
    return false
  }

  // 检查是否包含区号
  let mut has_area = false
  let mut dash_pos = -1
  for i = 0; i < len; i = i + 1 {
    if phone[i] == '-' {
      if dash_pos != -1 {
        return false // 不能有多个'-'
      }
      dash_pos = i
      has_area = true
    }
  }
  if has_area {
    // 区号长度应为3-4位
    if dash_pos < 3 || dash_pos > 4 {
      return false
    }
    // 号码部分应为7-8位
    if len - dash_pos - 1 < 7 || len - dash_pos - 1 > 8 {
      return false
    }
    // 无区号时应为7-8位
  } else if len < 7 || len > 8 {
    return false
  }

  // 检查所有非'-'字符是否为数字
  for i = 0; i < len; i = i + 1 {
    if phone[i] != '-' && (phone[i] < '0' || phone[i] > '9') {
      return false
    }
  }
  true
}

// 验证400/800电话

///|
pub fn is_tel_400_800(phone : String) -> Bool {
  let len = phone.length()
  if len != 11 && len != 12 {
    return false
  }

  // 检查首位是否为4或8
  if phone[0] != '4' && phone[0] != '8' {
    return false
  }
  // 检查是否以00开头
  if phone[1] != '0' || phone[2] != '0' {
    return false
  }

  // 处理带破折号的情况
  if len == 12 {
    if phone[3] != '-' || phone[7] != '-' {
      return false
    }
    // 检查数字部分
    for i = 4; i < 7; i = i + 1 {
      if phone[i] < '0' || phone[i] > '9' {
        return false
      }
    }
    for i = 8; i < 12; i = i + 1 {
      if phone[i] < '0' || phone[i] > '9' {
        return false
      }
    }
  } else {
    // 不带破折号的情况
    for i = 3; i < 11; i = i + 1 {
      if phone[i] < '0' || phone[i] > '9' {
        return false
      }
    }
  }
  true
}

// 隐藏手机号前7位

///|
pub fn hide_before(phone : String) -> String {
  hide_id_card(phone, 0, 7)
}

// 隐藏手机号中间4位

///|
pub fn hide_between(phone : String) -> String {
  hide_id_card(phone, 3, 7)
}

// 隐藏手机号后4位

///|
pub fn hide_after(phone : String) -> String {
  hide_id_card(phone, 7, 11)
}

// 获取手机号前3位

///|
pub fn sub_before(phone : String) -> String {
  if phone.length() < 3 {
    return ""
  }
  phone.substring(start=0, end=3)
}

// 获取手机号中间4位

///|
pub fn sub_between(phone : String) -> String {
  if phone.length() < 7 {
    return ""
  }
  phone.substring(start=3, end=7)
}

// 获取手机号后4位
///|
pub fn sub_after(phone : String) -> String {
  if phone.length() < 11 {
    return ""
  }
  phone.substring(start=7, end=11)
}


/// 测试中国大陆手机号验证
test "mobile_cn_validation" {
  // 有效的手机号
  assert_true!(is_mobile_cn("13812345678")) // 138开头
  assert_true!(is_mobile_cn("15912345678")) // 159开头
  assert_true!(is_mobile_cn("17712345678")) // 177开头
  assert_true!(is_mobile_cn("19912345678")) // 199开头

  // 无效的手机号格式
  assert_false!(is_mobile_cn("12345678")) // 长度不足
  assert_false!(is_mobile_cn("1381234567x")) // 包含字母
  assert_false!(is_mobile_cn("12812345678")) // 128开头
  assert_false!(is_mobile_cn("2381234567")) // 非1开头

  // 特殊情况
  assert_false!(is_mobile_cn("")) // 空字符串
  assert_false!(is_mobile_cn("138123456")) // 少一位
  assert_false!(is_mobile_cn("1381234567890")) // 多一位
  assert_false!(is_mobile_cn("138 1234 5678")) // 包含空格

  // 边界值测试
  assert_false!(is_mobile_cn("10012345678")) // 100开头
  assert_false!(is_mobile_cn("20012345678")) // 200开头
  assert_false!(is_mobile_cn("013812345678")) // 前面多0
}

test "hk_mobile_validation" {
  // 有效的香港手机号
  assert_true!(is_mobile_hk("901234567")) // 9开头
  assert_true!(is_mobile_hk("612345678")) // 6开头
  assert_true!(is_mobile_hk("401234567")) // 4开头

  // 无效的香港手机号
  assert_false!(is_mobile_hk("1234567")) // 长度不足
  assert_false!(is_mobile_hk("31234567")) // 无效前缀
  assert_false!(is_mobile_hk("9123456780")) // 长度过长
  assert_false!(is_mobile_hk("9123456a")) // 包含字母
}

test "tw_mobile_validation" {
  // 有效的台湾手机号
  assert_true!(is_mobile_tw("912345678")) // 9开头
  assert_true!(is_mobile_tw("812345678")) // 8开头

  // 无效的台湾手机号
  assert_false!(is_mobile_tw("712345678")) // 无效前缀
  assert_false!(is_mobile_tw("91234567")) // 长度不足
  assert_false!(is_mobile_tw("9123456789")) // 长度过长
  assert_false!(is_mobile_tw("91234567a")) // 包含字母
}

test "mo_mobile_validation" {
  // 有效的澳门手机号
  assert_true!(is_mobile_mo("62345678")) // 标准格式
  assert_true!(is_mobile_mo("66345678")) // 6开头
  assert_true!(is_mobile_mo("68345678")) // 合法前缀

  // 无效的澳门手机号
  assert_false!(is_mobile_mo("61345678")) // 无效第二位
  assert_false!(is_mobile_mo("6234567")) // 长度不足
  assert_false!(is_mobile_mo("623456789")) // 长度过长
  assert_false!(is_mobile_mo("6234567a")) // 包含字母
}

test "telephone_validation" {
  // 测试座机号码
  assert_true!(is_tel("010-12345678"))
  assert_true!(is_tel("0571-1234567"))
  assert_false!(is_tel("1234567"))
  assert_false!(is_tel("123-123456"))

  // 测试400/800电话
  assert_true!(is_tel_400_800("400-123-4567"))
  assert_true!(is_tel_400_800("8001234567"))
  assert_false!(is_tel_400_800("401-123-4567"))
  assert_false!(is_tel_400_800("400-1234-567"))
}

test "phone_hide" {
  let phone = "13812345678"

  // 测试隐藏功能
  assert_eq!(hide_before(phone), "*******5678")
  assert_eq!(hide_between(phone), "138****5678")
  assert_eq!(hide_after(phone), "1381234****")

  // 测试空字符串
  assert_eq!(hide_before(""), "")
  assert_eq!(hide_between(""), "")
  assert_eq!(hide_after(""), "")
}

test "phone_substring" {
  let phone = "13812345678"

  // 测试截取功能
  assert_eq!(sub_before(phone), "138")
  assert_eq!(sub_between(phone), "1234")
  assert_eq!(sub_after(phone), "5678")

  // 测试短字符串
  let short = "123"
  assert_eq!(sub_before(short), "123")
  assert_eq!(sub_between(short), "")
  assert_eq!(sub_after(short), "")
}
