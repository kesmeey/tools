///|
fn main {
  // 示例：用户ID脱敏
  let id = "1234567890"
  let ans = @tools.desensitize(id.to_string(), @tools.UserId)
  println("脱敏后的id为：\{ans}")

  // 示例：中文姓名脱敏
  let name = "段正淳"
  let ans = @tools.desensitize(name.to_string(), @tools.ChineseName)
  println("脱敏后的姓名为：\{ans}")

  // 示例：身份证号脱敏
  let id_card = "51343620000320711X"
  let ans = @tools.desensitize(id_card.to_string(), @tools.IdCard)
  println("脱敏后的身份证号为：\{ans}")

  // 示例：手机号脱敏
  let phone = "18049531999"
  let ans = @tools.desensitize(phone.to_string(), @tools.MobilePhone)
  println("脱敏后的手机号为：\{ans}")

  // 示例：邮箱脱敏
  let email = "duandazhi-jack@gmail.com.cn"
  let ans = @tools.desensitize(email.to_string(), @tools.Email)
  println("脱敏后的邮箱为：\{ans}")

  // 示例：银行卡号脱敏
  let bank_card = "11011111222233333256"
  let ans = @tools.desensitize(bank_card.to_string(), @tools.BankCard)
  println("脱敏后的银行卡号为：\{ans}")

  // 示例：IPv4地址脱敏
  let ipv4 = "192.168.1.1"
  let ans = @tools.desensitize(ipv4.to_string(), @tools.IPV4)
  println("脱敏后的IPv4地址为：\{ans}")

  // 示例：IPv6地址脱敏
  let ipv6 = "2001:0db8:86a3:08d3:1319:8a2e:0370:7344"
  let ans = @tools.desensitize(ipv6.to_string(), @tools.IPV6)
  println("脱敏后的IPv6地址为：\{ans}")

  // 示例：仅显示第一个字符
  let str = "123456789"
  let ans = @tools.desensitize(str.to_string(), @tools.FirstMask)
  println("脱敏后的字符串为：\{ans}")

  // 示例：清空字符串
  let str = "123456789"
  let ans = @tools.desensitize(str.to_string(), @tools.ClearToEmpty)
  println("清空后的字符串为：\{ans}")
}
