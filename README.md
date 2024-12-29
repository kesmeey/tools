# tools

该库是模仿 Java 的[hutool](https://github.com/dromara/hutool)工具库进行编写，编写一些实用的工具库（判断身份证是否合法，手机号是否合法等）

检测18位身份证是否合法

```
fn main {
    let id1 = "11010519491231002X";
    let id2 = "11010519491231002Y";
    let id3 = "123456789012345678";
    println(is_valid_18_card(id1)); // 应输出 true
    println(is_valid_18_card(id2)); // 应输出 false
    println(is_valid_18_card(id3)); // 应输出 false
}
```

隐藏身份证的部分号码

```
fn main {
    let id_18 = "110105199001011234"
    println("原始号码: " + id_18)///原始号码: 110105199001011234
    println("隐藏生日: " + hide_id_card(id_18, 6, 14))///隐藏生日: 110105********1234
    println("隐藏尾号: " + hide_id_card(id_18, 14, 18))///隐藏尾号: 11010519900101****
    
}
```



提取身份证的信息

```
fn main {
    let id_18 = "210202200107285894"
 // 提取身份证信息
    match parse_id_card(id_18) {
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
    match parse_id_card(id_18) {
        Some(info) => {
          print(info.to_string())
        }
        None => println("解析身份证信息失败")
    }
    
}
///输出IdCard{provinceCode='21', cityCode='2102', birthDate=2001-7-28, gender=1, age=23}
```





检测手机号是否合法

```
fn main {
    let phone1 = "13800138000";
    let phone2 = "12800138000";
    let phone3 = "1234567890";
    println(is_valid_mobile_phone(phone1)); // 应输出 true
    println(is_valid_mobile_phone(phone2)); // 应输出 false
    println(is_valid_mobile_phone(phone3)); // 应输出 false
}

```
