# tools

该库是模仿 Java 的[hutool](https://github.com/dromara/hutool)工具库进行编写，编写一些使用的工具库（判断身份证是否合法，手机号是否合法等）

检测身份证是否合法

```
fn main {
    let id1 = "11010519491231002X";
    let id2 = "11010519491231002Y";
    let id3 = "123456789012345678";
    println(is_valid_id_card(id1)); // 应输出 true
    println(is_valid_id_card(id2)); // 应输出 false
    println(is_valid_id_card(id3)); // 应输出 false
}
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
