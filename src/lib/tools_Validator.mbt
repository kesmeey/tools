///检测身份证是否合法
pub fn pub fn is_valid_id_card(id: String) -> Bool {
    if id.length() != 18 {
        return false;
    }
    
    let mut sum = 0;
    let coefficients = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2];
    let check_codes = ['1', '0', 'X', '9', '8', '7', '6', '5', '4', '3', '2'];
    for i=0;i<17;i=i+1 {
        let c = id[i]-'0'
        if c<0 || c>9 {
            return false;
        }
        let digit = c
        sum += coefficients[i] * digit;
    }

    let remainder = sum % 11;
    let expected = check_codes[remainder];
    let mut last_char = id[17];
    if(last_char=='x'){
      last_char='X'
    }
    last_char == expected
}
//检测手机号是否合法
pub fn is_valid_mobile_phone(phone: String) -> Bool {
    if phone.length() != 11 {
        return false;
    }
    let first_two = phone.substring(start=0,end=2)
    let valid_prefixes = ["13", "14", "15", "16", "17", "18", "19"];
    if valid_prefixes.contains(first_two)==false {
        return false;
    }
    for i=0;i<phone.length();i=i+1{
      if phone[i]>'9' || phone[i] <'0'{
        return false
      }
    }

    true
}



//检查字符串是否为数字
pub fn is_number(str: String) -> Bool {
    if str.length() == 0 {
        return false
    }
    
    let mut start = 0
    //处理负号
    if str[0] == '-' {
        if str.length() == 1 {
            return false
        }
        start = 1
    }
    
    //检查每个字符
    for i = start; i < str.length(); i = i + 1 {
        if str[i] > '9' || str[i] < '0' {
            return false
        }
    }
    
    true
}

//检查字符串是否为数字
pub fn is_number(str: String) -> Bool {
    if str.length() == 0 {
        return false
    }
    
    let mut start = 0
    //处理负号
    if str[0] == '-' {
        if str.length() == 1 {
            return false
        }
        start = 1
    }
    
    //检查每个字符
    for i = start; i < str.length(); i = i + 1 {
        if str[i] > '9' || str[i] < '0' {
            return false
        }
    }
    
    true
}
//验证字符串是否全部为中文
pub fn is_chinese(str: String) -> Bool {
    if str.length() == 0 {
        return false
    }
    
    //检查每个字符是否在中文编码范围内
    //中文字符Unicode范围：\u4e00-\u9fa5
    for i = 0; i < str.length(); i = i + 1 {
        let code = str[i].to_int()
        if code < 0x4e00 || code > 0x9fa5 {
            return false
        }
    }
    
    true
}