# tools

该库是模仿 Java 的[hutool](https://github.com/dromara/hutool)工具库进行编写，编写一些实用的，偏向业务的工具库（判断身份证是否合法，手机号是否合法等）

同时该库的部分函数使用到了[正则表达式库](https://mooncakes.io/docs/#/yj-qin/regexp/)，因此使用该库需要先下载该库（ moon add yj-qin/regexp )

检测18位身份证是否合法

```

fn main {
    let id1 = "11010519491231002X";
    let id2 = "11010519491231002Y";
    let id3 = "123456789012345678";
    println(@tools.is_valid_18_card(id1)); // 应输出 true
    println(@tools.is_valid_18_card(id2)); // 应输出 false
    println(@tools.is_valid_18_card(id3)); // 应输出 false
}
```

隐藏身份证的部分号码

```
fn main {
    let id_18 = "110105199001011234"
    println("原始号码: " + id_18)///原始号码: 110105199001011234
    println("隐藏生日: " + @tools.hide_id_card(id_18, 6, 14))///隐藏生日: 110105********1234
    println("隐藏尾号: " + @tools.hide_id_card(id_18, 14, 18))///隐藏尾号: 11010519900101****
    
}
```

提取身份证的信息

```
fn main {
    let id_18 = "210202200107285894"
 // 提取身份证信息
    match @tools.parse_id_card(id_18) {
        Some(info) => {
            println("\n身份证信息:")
            println("省份代码: " + info.get_province_code()) ///省份代码: 21
            println("省份名称: " + info.get_province())///省份名称: 辽宁
            println("出生日期: " + info.get_birth_date())///出生日期: 2001-07-28
            let gender = if info.get_gender() == 1 { "男" } else { "女" }
            println("性别: " + gender)///性别: 男
            println("年龄: " + info.get_age().to_string())///年龄: 23
        }
        None => println("解析身份证信息失败")
    }
    
}

```

输出全部身份证信息

```

fn main {
    let id_18 = "210202200107285894"
 // 提取身份证信息
    match @tools.parse_id_card(id_18) {
        Some(info) => {
          print(info.to_string())
        }
        None => println("解析身份证信息失败")
    }
    
}
///输出IdCard{provinceCode='21', cityCode='2102', birthDate=2001-7-28, gender=1, age=23}
```

计算器函数

```
fn main {
  let s1 = "3/3 "
  let s2 = "3 + 3 * 3"
  let s3 = "3-(1+5)+3^3"
  let mut ans = @tools.calculate(s1)
  println(ans)// 1
  ans = @tools.calculate(s2)
  println(ans)// 12
  ans = @tools.calculate(s3)
  println(ans)// 24
}

```

排列组合函数

```
fn main {
   let test1 = @tools.arrangement_count(4, 2)
   println(test1)//A(4,2) = 12
    let test2 = @tools.arrangement_count(3, 3)
    println(test2)//A(3,3) = 6
    let test3 = @tools.combination_count(4, 2)
    println(test3)//C(4,2) = 6
    let test4 = @tools.combination_count(3, 3)
    println(test4)//C(3,3) = 1 
}

```



检测社会信用卡是否合法

```
fn main {
     let valid_code = "92371000MA3MXH0E3W"
     let invalid_code = "1234567890123456789"
     println(@tools.is_credit_code(valid_code))///true
     println(@tools.is_credit_code(invalid_code))///false
}
```

生成随机社会信用卡字符串

```
fn main {
     let valid_code = @tools.random_credit_code()
     println(valid_code)
     println(@tools.is_credit_code(valid_code))// 应输出true
   
}
```

验证邮箱是否合法

```

fn main {
  let valid_email = "test@example.com"
  let invalid_email = "testexample.com"
  println(@tools.is_valid_email(valid_email)) // true
  println(@tools.is_valid_email(invalid_email))//false
}
```



检测手机号是否合法

```
fn main {
    let phone1 = "13800138000";
    let phone2 = "12800138000";
    let phone3 = "1234567890";
    println(@tools.is_mobile_cn(phone1)); // 应输出 true
    println(@tools.is_mobile_cn(phone2)); // 应输出 false
    println(@tools.is_mobile_cn(phone3)); // 应输出 false
}

```

脱敏函数（隐藏手机号，姓名等敏感信息）

```
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
  let bank_card = "6222021234567890123"
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
//输出为
//脱敏后的id为：0
//脱敏后的姓名为：段**
//脱敏后的身份证号为：5***************1X
//脱敏后的手机号为：180****1999
//脱敏后的邮箱为：d*************@gmail.com.cn
//脱敏后的银行卡号为：6222 **** **** **** 123
//脱敏后的IPv4地址为：192.*.*.*
//脱敏后的IPv6地址为：2001:*:*:*:*:*:*:*
//脱敏后的字符串为：1********
//清空后的字符串为：
```

验证车牌号是否有效(支持电动车和非电动车车牌)

```

fn main {
  let car_license_valid = @tools.is_valid_car_license("京A12345".to_string())
  let electric_car_license_valid = @tools.is_valid_car_license("沪BD67890")
  println(car_license_valid)// true
  println(electric_car_license_valid)     // true
  let car_license_invalid = @tools.is_valid_car_license("京12345")
  println(car_license_invalid) // false
}


```



检测字符串是否为存英文，纯数字

```
fn main {
  let test1 = @tools.is_number("bbb")
  println(test1) // false
  let test2 = @tools.is_number("114514")
  println(test2)  // true
  let test3 = @tools.is_chinese("中文")
  println(test3)  // true
  let test4 = @tools.is_chinese("中文123")
  println(test4)  // false
}

```

检测文件路径是否合法

```
fn main {
  let test1 = @tools.is_windows_path("C:\\Windows\\System32")
  println(test1) // true
  let test2 = @tools.is_windows_path("1:/Documents/test.txt")
  println(test2) // false
  let test3 = @tools.is_linux_path("/usr/local/bin")
  println(test3) // true
  let test4 = @tools.is_linux_path("/test//file")
  println(test4) // false 
}


```

