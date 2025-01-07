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
  let re = @regexp.compile?(MOBILE_CN).unwrap().matches(phone)
  let result = re.success()
  result
}

// 验证香港手机号
///|
pub fn is_mobile_hk(phone : String) -> Bool {
  let re = @regexp.compile?(MOBILE_HK).unwrap().matches(phone)
  let result = re.success()
  result
}

// 验证台湾手机号
///|
pub fn is_mobile_tw(phone : String) -> Bool {
  let re = @regexp.compile?(MOBILE_TW).unwrap().matches(phone)
  let result = re.success()
  result
}

// 验证澳门手机号

///|
pub fn is_mobile_mo(phone : String) -> Bool {
  let re = @regexp.compile?(MOBILE_MO).unwrap().matches(phone)
  let result = re.success()
  result
}

// 验证座机号码

///|
pub fn is_tel(phone : String) -> Bool {
  let re = @regexp.compile?(TEL).unwrap().matches(phone)
  let result = re.success()
  result
}

// 验证400/800电话

///|
pub fn is_tel_400_800(phone : String) -> Bool {
  let re = @regexp.compile?(TEL_400_800).unwrap().matches(phone)
  let result = re.success()
  result
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
