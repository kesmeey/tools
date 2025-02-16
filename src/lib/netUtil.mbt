///| 验证IPv4地址是否合法
pub fn is_valid_ipv4(ip : String) -> Bool {
  if ip.length() == 0 {
    return false
  }

  // 检查开头和结尾是否有点
  if ip[0] == '.' || ip[ip.length() - 1] == '.' {
    return false
  }

  // 分割IP地址
  let parts = ip.split(".").to_array()
  if parts.length() != 4 {
    return false
  }

  // 验证每个部分
  for i = 0; i < parts.length(); i = i + 1 {
    let part = parts[i]
    // 检查长度
    if part.length() == 0 || part.length() > 3 {
      return false
    }

    // 检查是否有前导零
    if part.length() > 1 && part[0] == '0' {
      return false
    }

    // 转换为数字并验证范围
    let mut num = 0
    for j = 0; j < part.length(); j = j + 1 {
      let c = part[j]
      if c < '0' || c > '9' {
        return false
      }
      num = num * 10 + (c.to_int() - '0'.to_int())
    }

    // 验证范围 0-255
    if num < 0 || num > 255 {
      return false
    }
  }
  true
}

///| 根据long值获取ipv4地址
pub fn long_to_ipv4(long_ip : Int64) -> String {
  // 处理超出范围的情况
  if long_ip < 0 || long_ip > 4294967295 {
    return ""
  }

  // 分别获取4个段的值
  let ip1 = ((long_ip >> 24) & 0xFF).to_int()
  let ip2 = ((long_ip >> 16) & 0xFF).to_int()
  let ip3 = ((long_ip >> 8) & 0xFF).to_int()
  let ip4 = (long_ip & 0xFF).to_int()

  // 拼接IP地址字符串
  ip1.to_string() +
  "." +
  ip2.to_string() +
  "." +
  ip3.to_string() +
  "." +
  ip4.to_string()
}

///| 根据IPv4地址计算出long型的数据
pub fn ipv4_to_long(str_ip : String) -> Int64 {
  // 先验证IP地址格式是否正确
  if is_valid_ipv4(str_ip) == false {
    return -1
  }

  // 分割IP地址
  let parts = str_ip.split(".").to_array()

  // 转换每一段为数字并计算long值
  let a = @strconv.parse_int?(parts[0]).unwrap()
  let part1 = Int64::from_int(@strconv.parse_int?(parts[0]).unwrap())
  let part2 = Int64::from_int(@strconv.parse_int?(parts[1]).unwrap())
  let part3 = Int64::from_int(@strconv.parse_int?(parts[2]).unwrap())
  let part4 = Int64::from_int(@strconv.parse_int?(parts[3]).unwrap())

  // 通过位运算组合成long值
  (part1 << 24) | (part2 << 16) | (part3 << 8) | part4
}

///| 验证IPv6地址是否合法
pub fn is_valid_ipv6(ip : String) -> Bool {
  if ip.length() == 0 {
    return false
  }

  // 检查是否包含多个连续的冒号
  if ip.contains(":::") {
    return false
  }

  // 分割IPv6地址
  let parts = ip.split(":").to_array()
  let parts_len = parts.length()

  // IPv6地址段数必须为8，或者包含"::"时可以少于8
  if parts_len > 8 {
    return false
  }

  // 检查是否有空段以及段的有效性
  let mut has_empty = false
  let mut empty_groups = 0
  for i = 0; i < parts_len; i = i + 1 {
    let part = parts[i]

    // 处理空段 (::)
    if part.length() == 0 {
      empty_groups += 1
      if empty_groups > 2 {
        return false
      }
      if has_empty && empty_groups > 1 {
        // 只允许出现一次连续的冒号
        return false
      }
      has_empty = true
      continue
    }

    // 检查每段的长度
    if part.length() > 4 {
      return false
    }

    // 验证每个字符是否为有效的十六进制数字
    for j = 0; j < part.length(); j = j + 1 {
      let c = part[j]
      if (
          (c >= '0' && c <= '9') ||
          (c >= 'a' && c <= 'f') ||
          (c >= 'A' && c <= 'F')
        ) ==
        false {
        return false
      }
    }
  }

  // 检查压缩的段数是否合法
  let actual_groups = parts_len - empty_groups
  let compressed_groups = 8 - actual_groups
  if has_empty == false && actual_groups != 8 {
    return false
  }
  if has_empty && compressed_groups < 1 {
    return false
  }
  true
}

///| 将IPv6地址规范化（展开缩写形式）
pub fn normalize_ipv6(ip : String) -> String {
  if is_valid_ipv6(ip) == false {
    return ""
  }

  // 分割地址
  let parts = ip.split(":").to_array()
  let result = Array::makei(8, fn(i : Int) -> String { "0000" })
  let mut index = 0
  let mut has_empty = false
  for i = 0; i < parts.length(); i = i + 1 {
    let part = parts[i]
    if part.length() == 0 {
      if has_empty {
        continue
      }
      // 计算需要补充的0段数量
      let zeros = 8 - (parts.length() - 1)
      index = index + zeros
      has_empty = true
      continue
    }

    // 补齐4位
    let padded = "0000" + part
    result[index] = padded.substring(
      start=padded.length() - 4,
      end=padded.length(),
    )
    index = index + 1
  }

  // 拼接结果
  let mut normalized = ""
  for i = 0; i < 8; i = i + 1 {
    if i > 0 {
      normalized = normalized + ":"
    }
    normalized = normalized + result[i]
  }
  normalized
}

///|
test "ipv6" {
  // 测试有效的IPv6地址
  assert_true!(is_valid_ipv6("2001:0db8:85a3:0000:0000:8a2e:0370:7334"))
  assert_true!(is_valid_ipv6("2001:db8:85a3:0:0:8a2e:370:7334"))
  assert_true!(is_valid_ipv6("2001:db8:85a3::8a2e:370:7334"))
  // 无效的
  assert_false!(is_valid_ipv6("2001:0db8:85a3:::0000:8a2e:0370:7334"))
  assert_false!(is_valid_ipv6("gggg:0db8:85a3:0000:0000:8a2e:0370:7334"))
}

///|
test "is_valid_ipv4" {
  // 有效的IP地址
  assert_true!(is_valid_ipv4("192.168.0.1"))
  assert_true!(is_valid_ipv4("127.0.0.1"))
  assert_true!(is_valid_ipv4("0.0.0.0"))
  assert_true!(is_valid_ipv4("255.255.255.255"))

  // 无效的IP地址
  assert_false!(is_valid_ipv4("")) // 空字符串
  assert_false!(is_valid_ipv4("192.168.1")) // 段数不够
  assert_false!(is_valid_ipv4("192.168.1.1.1")) // 段数过多
  assert_false!(is_valid_ipv4("256.1.2.3")) // 数字超过255
  assert_false!(is_valid_ipv4("1.1.1.1.")) // 结尾有点
  assert_false!(is_valid_ipv4(".1.1.1.1")) // 开头有点
  assert_false!(is_valid_ipv4("192.168.01.1")) // 有前导零
  assert_false!(is_valid_ipv4("192.168.1.1a")) // 包含非数字字符
}

///|
test "long_to_ipv4" {
  // 测试正常IP转换
  assert_eq!(long_to_ipv4(3232235777L), "192.168.1.1")
  assert_eq!(long_to_ipv4(2130706433), "127.0.0.1")
  assert_eq!(long_to_ipv4(0), "0.0.0.0")
  assert_eq!(long_to_ipv4(4294967295), "255.255.255.255")

  // 测试边界值
  assert_eq!(long_to_ipv4(-1), "") // 负数返回空字符串
  assert_eq!(long_to_ipv4(4294967296), "") // 超出范围返回空字符串
}

///|
test "ipv4_to_long" {
  // 测试正常IP转换
  assert_eq!(ipv4_to_long("192.168.1.1"), 3232235777)
  assert_eq!(ipv4_to_long("127.0.0.1"), 2130706433)
  assert_eq!(ipv4_to_long("0.0.0.0"), 0)
  assert_eq!(ipv4_to_long("255.255.255.255"), 4294967295)

  // 测试无效IP
  assert_eq!(ipv4_to_long(""), -1)
  assert_eq!(ipv4_to_long("256.1.2.3"), -1)
  assert_eq!(ipv4_to_long("1.1.1"), -1)
  assert_eq!(ipv4_to_long("1.1.1.1.1"), -1)

  // 测试转换的可逆性
  let ip = "192.168.1.1"
  let long_ip = ipv4_to_long(ip)
  assert_eq!(long_to_ipv4(long_ip), ip)
}
