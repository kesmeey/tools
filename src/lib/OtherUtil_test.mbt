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
