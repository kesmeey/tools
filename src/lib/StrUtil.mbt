

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