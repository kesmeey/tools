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
