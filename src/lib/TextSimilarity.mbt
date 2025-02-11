///| 
// 字符串相似度计算工具
// 使用莱文斯坦距离(Levenshtein distance)算法计算相似度

///|
// 计算两个字符串的相似度
pub fn similar(str_a : String, str_b : String) -> Double {
  let (new_str_a, new_str_b) = if str_a.length() < str_b.length() {
    (remove_sign(str_b), remove_sign(str_a))
  } else {
    (remove_sign(str_a), remove_sign(str_b))
  }

  // 用较大的字符串长度作为分母，相似子串作为分子计算出字串相似度
  let temp = max(new_str_a.length(), new_str_b.length())
  if temp == 0 {
    // 两个都是空串相似度为1，被认为是相同的串
    return 1.0
  }
  let common_length = longest_common_substring_length(new_str_a, new_str_b)
  common_length.to_double() / temp.to_double()
}

///|
// 去除字符串中的无意义字符
fn remove_sign(str : String) -> String {
  let mut result = ""
  // 遍历字符串，只保留汉字、数字和字母
  for i = 0; i < str.length(); i = i + 1 {
    let c = str[i]
    if is_valid_char(c) {
      result = result + c.to_string()
    }
  }
  result
}

///|
// 判断字符是否为汉字、数字或字母
fn is_valid_char(c : Char) -> Bool {
  (c.to_int() >= 0x4E00 && c.to_int() <= 0x9FFF) || // 汉字范围
  (c >= 'a' && c <= 'z') || // 小写字母
  (c >= 'A' && c <= 'Z') || // 大写字母
  (c >= '0' && c <= '9') // 数字
}

///|
// 计算最长公共子串长度
fn longest_common_substring_length(str_a : String, str_b : String) -> Int {
  let matrix = generate_matrix(str_a, str_b)
  matrix[str_a.length()][str_b.length()]
}

///|
// 生成动态规划矩阵
fn generate_matrix(str_a : String, str_b : String) -> Array[Array[Int]] {
  let m = str_a.length()
  let n = str_b.length()

  // 初始化矩阵
  let matrix = Array::makei(m + 1, fn(i : Int) -> Array[Int] {
    Array::makei(n + 1, fn(j : Int) -> Int { 0 })
  })
  for i = 1; i <= m; i = i + 1 {
    for j = 1; j <= n; j = j + 1 {
      if str_a[i - 1] == str_b[j - 1] {
        matrix[i][j] = matrix[i - 1][j - 1] + 1
      } else {
        matrix[i][j] = max(matrix[i][j - 1], matrix[i - 1][j])
      }
    }
  }
  matrix
}

///|
// 获取最大值
fn max(a : Int, b : Int) -> Int {
  if a > b {
    a
  } else {
    b
  }
}

///|
test "text_similarity" {
  // 测试完全相同的字符串
  assert_eq!(similar("hello", "hello"), 1.0)

  // 测试部分相似的字符串
  assert_eq!(similar("hello", "helo") >= 0.7, true)
  // 测试包含特殊字符的字符串
  assert_eq!(similar("hello!", "hello?"), 1.0)

  // 测试包含中文的字符串
  assert_eq!(similar("你好世界", "你好地球") >= 0.5, true)

  // 测试空字符串
  assert_eq!(similar("", ""), 1.0)
}
