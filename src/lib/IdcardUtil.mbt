// 定义常量 
const CHINA_ID_MIN_LENGTH = 15
const CHINA_ID_MAX_LENGTH = 18

// 省市代码表，使用Map存储
pub(all) struct CityCode {
  code: String
  name: String
}

pub fn get_province_name(code: String) -> String {
  match code {
    "11" => "北京"
    "12" => "天津"
    "13" => "河北"
    "14" => "山西"
    "15" => "内蒙古"
    "21" => "辽宁"
    "22" => "吉林"
    "23" => "黑龙江"
    "31" => "上海"
    "32" => "江苏"
    "33" => "浙江"
    "34" => "安徽"
    "35" => "福建"
    "36" => "江西"
    "37" => "山东"
    "41" => "河南"
    "42" => "湖北"
    "43" => "湖南"
    "44" => "广东"
    "45" => "广西"
    "46" => "海南"
    "50" => "重庆"
    "51" => "四川"
    "52" => "贵州"
    "53" => "云南"
    "54" => "西藏"
    "61" => "陕西"
    "62" => "甘肃"
    "63" => "青海"
    "64" => "宁夏"
    "65" => "新疆"
    "71" => "台湾"
    "81" => "香港"
    "82" => "澳门"
    "83" => "台湾"// 台湾身份证号码以83开头，但是行政区划为71
    "91" => "国外"
    _ => "未知省份"
  }
}

pub(all) struct IdCard {
  province_code: String
  city_code: String
  birth_year: Int
  birth_month: Int
  birth_day: Int
  gender: Int // 1:男, 0:女
  age: Int
}

// 检查号码长度和格式
pub fn check_length(id: String) -> Bool {
  let len = id.length()
  len == CHINA_ID_MIN_LENGTH || len == CHINA_ID_MAX_LENGTH
}

// 验证生日
pub fn check_birthday(year: Int, month: Int, day: Int) -> Bool {
  if year < 1900 || year > 2100 {
    return false
  }
  if month < 1 || month > 12 {
    return false
  }
  
  let days = match month {
    2 => if is_leap_year(year) { 29 } else { 28 }
    4 | 6 | 9 | 11 => 30
    _ => 31
  }
  
  if day < 1 || day > days {
    return false
  }
  true
}

// 判断闰年
pub fn is_leap_year(year: Int) -> Bool {
  year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)
}

// 验证18位身份证
pub fn is_valid_18_card(id: String) -> Bool {
  if id.length() != 18 {
    return false
  }
  
  // 验证数字格式
  for i = 0; i < 17; i = i + 1 {
    let c = id[i]
    if c < '0' || c > '9' {
      return false
    }
  }
  
  // 验证最后一位校验码
  let last = id[17]
  if (last >= '0' && last <= '9' || last == 'X' || last == 'x')==false {
    return false
  }
  
  // 验证生日
  let year = @strconv.parse_int?(id.substring(start=6, end=10) ).unwrap()
  let month = @strconv.parse_int?(id.substring(start=10, end=12) ).unwrap()
  let day = @strconv.parse_int?(id.substring(start=12, end=14) ).unwrap()
  
  if check_birthday(year, month, day)==false {
    return false
  }
  
  // 验证校验码
  let coefficients = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2]
  let check_codes = ['1', '0', 'X', '9', '8', '7', '6', '5', '4', '3', '2']
  
  let mut sum = 0
  for i = 0; i < 17; i = i + 1 {
    sum += (id[i] - '0') * coefficients[i]
  }
  
  let check = check_codes[sum % 11]
  if id[17] == 'x' {
    check == 'X'
  } else {
    check == id[17]
  }
}
// 验证15位身份证
pub fn is_valid_card_15(id: String) -> Bool {
    if id.length() != CHINA_ID_MIN_LENGTH {
        return false
    }
    
    // 验证数字格式
    for i = 0; i < 15; i = i + 1 {
        if id[i] < '0' || id[i] > '9' {
            return false
        }
    }
    
    // 验证省份
    let province = id.substring(start=0, end=2)
    if get_province_name(province) == "未知省份" {
        return false
    }
    
    // 验证生日（两位年份，补充为19XX）
    let year = @strconv.parse_int?("19" + id.substring(start=6, end=8)).unwrap()
    let month = @strconv.parse_int?(id.substring(start=8, end=10)).unwrap()
    let day = @strconv.parse_int?(id.substring(start=10, end=12)).unwrap()
    
    check_birthday(year, month, day)
}
// 验证香港身份证
pub fn is_valid_hk_card(id: String) -> Bool {
    // 验证格式
    if id.length() != 10 {
        return false
    }
    
    // 验证首位是否为字母
    let first = id[0]
    if first < 'A' || first > 'Z' {
        return false
    }
    
    // 计算校验和
    let mut sum = (first - 'A' + 10) * 9
    
    // 验证后续数字
    for i = 1; i < 7; i = i + 1 {
        if id[i] < '0' || id[i] > '9' {
            return false
        }
        sum += (id[i] - '0') * (8 - i)
    }
    
    // 验证校验位
    let check = id[7]
    if check == 'A' {
        sum += 10
    } else if check >= '0' && check <= '9' {
        sum += check - '0'
    } else {
        return false
    }
    
    sum % 11 == 0
}
// 验证台湾身份证
pub fn is_valid_tw_card(id: String) -> Bool {
    // 验证格式
    if id.length() != 10 {
        return false
    }
    
    // 验证首位字母
    let first = id[0]
    if first < 'A' || first > 'Z' {
        return false
    }
    
    // 验证第二位性别码
    let gender = id[1]
    if gender != '1' && gender != '2' {
        return false
    }
    
    // 验证后续数字
    for i = 2; i < 10; i = i + 1 {
        if id[i] < '0' || id[i] > '9' {
            return false
        }
    }
    
    true
}
// 验证10位身份证(港澳台)
pub fn is_valid_card_10(id: String) -> Array[String] {
    if id.length() != 10 {
        return []
    }
    
    // 验证台湾身份证
    if is_valid_tw_card(id) {
        let gender = if id[1] == '1' { "M" } else { "F" }
        return ["台湾", gender, "true"]
    }
    
    // 验证香港身份证
    if is_valid_hk_card(id) {
        return ["香港", "N", "true"]
    }
    
    // 验证澳门身份证
    if id[0] >= '1' && id[0] <= '7' {
        return ["澳门", "N", "true"]
    }
    
    []
}

// 解析身份证信息

pub fn parse_id_card(id: String) -> IdCard? {
  if is_valid_18_card(id)==false {
    return None
  }
  
  let birth_year = @strconv.parse_int?(id.substring(start=6, end=10)).unwrap()
  let birth_month = @strconv.parse_int?(id.substring(start=10, end=12)).unwrap()
  let birth_day = @strconv.parse_int?(id.substring(start=12, end=14)).unwrap()
  let gen = if (id[16] - '0') % 2 == 0 { 0 } else { 1 }

  let card = {
    province_code: id.substring(start=0, end=2),
    city_code: id.substring(start=0, end=4),
    birth_year: birth_year,
    birth_month: birth_month,
    birth_day: birth_day,
    gender:gen,
    age: 2024 - birth_year
  }
  
  Some(card)
}
// 获取份代码
pub fn IdCard::get_province_code(self: IdCard) -> String {
    self.province_code
}

  // 获取省份名称
pub fn IdCard::get_province(self: IdCard) -> String {
     get_province_name(self.province_code)
}

  // 获取市级编码
pub fn IdCard::get_city_code(self: IdCard) -> String {
    self.city_code
  }

  // 获取性别
pub fn IdCard::get_gender(self: IdCard) -> Int {
    self.gender
}
pub fn IdCard::get_birth_date(self: IdCard) -> String {
    // 将月和日补齐为两位数
    let month_str = if self.birth_month < 10 {
        "0" + self.birth_month.to_string()
    } else {
        self.birth_month.to_string()
    }
    
    let day_str = if self.birth_day < 10 {
        "0" + self.birth_day.to_string()
    } else {
        self.birth_day.to_string()
    }
    
    // 返回格式化的日期字符串
    self.birth_year.to_string() + "-" + month_str + "-" + day_str
}

  // 获取年龄
pub fn IdCard::get_age(self: IdCard) -> Int {
    self.age
  }

  // toString方法
pub fn IdCard::to_string(self: IdCard) -> String {
    "IdCard{provinceCode='" + self.province_code + 
    "', cityCode='" + self.city_code +
    "', birthDate=" + self.birth_year.to_string() + "-" + 
    self.birth_month.to_string() + "-" + self.birth_day.to_string() +
    ", gender=" + self.gender.to_string() +
    ", age=" + self.age.to_string() + "}"
}

/// 隐藏身份证号码指定位置的数字，替换为 "*"
pub fn hide_id_card(id: String, start_include: Int, end_exclude: Int) -> String {
    // 验证参数
    if start_include < 0 || end_exclude > id.length() || start_include >= end_exclude {
        return id
    }
    
    // 生成替换用的星号
    let stars = "*".repeat(end_exclude - start_include)
    
    // 拼接结果
    id.substring(start=0, end=start_include) + 
    stars + 
    id.substring(start=end_exclude, end=id.length())
}
/// 15位转18位身份证号码
pub fn convert_15_to_18(id: String) -> String? {
    // 验证长度
    if id.length() != CHINA_ID_MIN_LENGTH {
        return None
    }
    
    // 验证是否全为数字
    for i = 0; i < 15; i = i + 1 {
        if id[i] < '0' || id[i] > '9' {
            return None
        }
    }
    
    // 获取出生年月日
    let year_prefix = "19"  // 15位身份证都是19xx年
    let year_suffix = id.substring(start=6, end=8)
    let month = id.substring(start=8, end=10)
    let day = id.substring(start=10, end=12)
    
    // 组装18位号码(不含校验位)
    let id_17 = id.substring(start=0, end=6) + 
                year_prefix + year_suffix +
                id.substring(start=8, end=15)
    
    // 计算校验码
    let coefficients = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2]
    let check_codes = ['1', '0', 'X', '9', '8', '7', '6', '5', '4', '3', '2']
    
    let mut sum = 0
    for i = 0; i < 17; i = i + 1 {
        sum += (id_17[i] - '0') * coefficients[i]
    }
    
    // 返回完整的18位号码
    Some(id_17 + check_codes[sum % 11].to_string())
}
/// 18位身份证转15位
pub fn convert_18_to_15(id: String) -> String? {
    // 验证18位身份证
    if id.length() != CHINA_ID_MAX_LENGTH || is_valid_18_card(id)==false {
        return None
    }
    // 截取前6位 + 截取后8位(去掉年份前缀和最后一位校验码)
    Some(
        id.substring(start=0, end=6) + 
        id.substring(start=8, end=17)
    )
}

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
