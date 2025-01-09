test "desensitized_util" {
  // 中文姓名脱敏测试
  assert_eq!(desensitize("张三丰", DesensitizedType::ChineseName), "张**")
  assert_eq!(desensitize("李四", DesensitizedType::ChineseName), "李*")

  // 身份证脱敏测试
  assert_eq!(
    desensitize("110105199001011234", DesensitizedType::IdCard),
    "1***************34",
  )

  // 手机号脱敏测试
  assert_eq!(
    desensitize("13812345678", DesensitizedType::MobilePhone),
    "138****5678",
  )

  // 固定电话脱敏测试
  assert_eq!(
    desensitize("010-12345678", DesensitizedType::FixedPhone),
    "010-****5678",
  )
  assert_eq!(
    desensitize("0571-1234567", DesensitizedType::FixedPhone),
    "0571-***4567",
  )

  // 地址脱敏测试
  assert_eq!(
    desensitize("北京市海淀区西二旗街道", DesensitizedType::Address),
    "北京市海淀区西二***",
  )

  // 邮箱脱敏测试
  assert_eq!(
    desensitize("test@example.com", DesensitizedType::Email),
    "t***@example.com",
  )

  // 密码脱敏测试
  assert_eq!(
    desensitize("password123", DesensitizedType::Password),
    "***********",
  )

  // 银行卡脱敏测试
  assert_eq!(
    desensitize("6222021234567890123", DesensitizedType::BankCard),
    "6222 **** **** **** 123",
  )

  // 空字符串测试
  assert_eq!(desensitize("", DesensitizedType::ChineseName), "")

  // 清空测试
  assert_eq!(desensitize("test", DesensitizedType::ClearToEmpty), "")
}
