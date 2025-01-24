test "arrangement_count" {
  // 基本排列数测试
  assert_eq!(arrangement_count(3, 2), 6) // A(3,2) = 6
  assert_eq!(arrangement_count(3, 3), 6) // A(3,3) = 6
  assert_eq!(arrangement_count(4, 2), 12) // A(4,2) = 12
  assert_eq!(arrangement_count(2, 3), 0) // 无效情况
}

test "combination_count" {
  // 基本组合数测试
  assert_eq!(combination_count(4, 2), 6) // C(4,2) = 6
  assert_eq!(combination_count(5, 3), 10) // C(5,3) = 10
  assert_eq!(combination_count(3, 3), 1) // C(3,3) = 1
  assert_eq!(combination_count(3, 0), 1) // C(3,0) = 1
  assert_eq!(combination_count(2, 3), 0) // 无效情况
}

test "calculator" {
  assert_eq!(calculate("1+1"), 2)
  assert_eq!(calculate("2-1"), 1)
  assert_eq!(calculate("2*3"), 6)
  assert_eq!(calculate("6/2"), 3)
  assert_eq!(calculate("2+3*4"), 14)
  assert_eq!(calculate("(2+3)*4"), 20)
}
