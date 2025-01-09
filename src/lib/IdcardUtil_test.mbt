test "is_valid_18_card_validation" {
  // 有效的身份证号
  assert_true!(is_valid_18_card("310105200504248170")) // 基本格式
  assert_true!(is_valid_18_card("11010519491231002X")) // X结尾
  assert_true!(is_valid_18_card("340221200002292965")) // 闰年2月29日

  // 无效格式
  assert_false!(is_valid_18_card("11010519900101")) // 长度不足
  assert_false!(is_valid_18_card("11010519900101123a")) // 小写x
  assert_false!(is_valid_18_card("12345678901234567X")) // 无效区域代码

  // 无效生日
  assert_false!(is_valid_18_card("110105199013011234")) // 13月
  assert_false!(is_valid_18_card("110105199001321234")) // 32日
  assert_false!(is_valid_18_card("110105201502291234")) // 非闰年2月29日

  // 校验位错误
  assert_false!(is_valid_18_card("110105199001011235")) // 校验位错误
  assert_false!(is_valid_18_card("110105199001011230")) // 校验位错误

  // 特殊字符
  assert_false!(is_valid_18_card("11010519900101123#")) // 特殊字符
  assert_false!(is_valid_18_card("110105199001011 23")) // 空格
  assert_false!(is_valid_18_card("")) // 空字符串
}
