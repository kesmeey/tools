///| 
// Simhash 相关常量
const BIT_NUM = 64

///|
const DEFAULT_FRAC_COUNT = 4

///|
const DEFAULT_HAMMING_THRESH = 3

///| 
// 计算文本的 simhash 值
pub fn calc_simhash(seg_list : Array[String]) -> Int64 {
  let weight = Array::makei(BIT_NUM, fn(i : Int) -> Int { i })

  // 计算每个分词的hash值并更新权重数组
  for i = 0; i < seg_list.length(); i = i + 1 {
    let word_hash = murmur_hash_64(seg_list[i])
    for j = 0; j < BIT_NUM; j = j + 1 {
      if ((word_hash >> j) & 1) == 1 {
        weight[j] += 1
      } else {
        weight[j] -= 1
      }
    }
  }

  // 构建simhash值
  let mut result = Int64::from_int(0)
  for i = 0; i < BIT_NUM; i = i + 1 {
    if weight[i] > 0 {
      result = result | (Int64::from_int(1) << i)
    }
  }
  result
}

///| 
// 计算汉明距离
pub fn hamming_distance(s1 : Int64, s2 : Int64) -> Int {
  let mut dis = 0
  for i = 0; i < BIT_NUM; i = i + 1 {
    if ((s1 >> i) & 1) != ((s2 >> i) & 1) {
      dis += 1
    }
  }
  dis
}

///| 
// 将simhash分成n段
pub fn split_simhash(simhash : Int64, frac_count : Int) -> Array[String] {
  let frac_bit_num = BIT_NUM / frac_count
  let result : Array[String] = Array::makei(frac_count, fn(i : Int) -> String {
    ""
  })
  for i = 0; i < frac_count; i = i + 1 {
    let mut frac = ""
    for j = 0; j < frac_bit_num; j = j + 1 {
      let bit_pos = i * frac_bit_num + j
      frac = frac + ((simhash >> bit_pos) & 1).to_string()
    }
    result[i] = frac
  }
  result
}

///| 
/// 
// 从字节数组中获取Int64值

// 判断两个文本是否相似
///|
pub fn is_similar(text1 : Array[String], text2 : Array[String]) -> Bool {
  let hash1 = calc_simhash(text1)
  let hash2 = calc_simhash(text2)
  hamming_distance(hash1, hash2) < DEFAULT_HAMMING_THRESH
}

///|
fn get_int64_from_bytes(bytes : Bytes, offset : Int) -> Int64 {
  let mut result = Int64::from_int(0)

  // 按小端序读取8个字节组成Int64
  for i = 0; i < 8; i = i + 1 {
    if offset + i < bytes.length() {
      let byte_val = Int64::from_int(bytes[offset + i].to_int() & 0xFF)
      result = result | (byte_val << (i * 8))
    }
  }
  result
}

///| 
// MurmurHash实现
fn murmur_hash_64(key : String) -> Int64 {
  let seed = Int64::from_int(0x1234ABCD)
  let m : Int64 = 0xc6a4a7935bd1e995
  let r = 47
  let mut h = seed ^ (Int64::from_int(key.length()) * m)

  // String.to_bytes() 返回 Array[Int]
  let data : Bytes = key.to_bytes()
  let len = data.length()
  let mut i = 0
  while i + 8 <= len {
    let mut k = get_int64_from_bytes(data, i)
    k = k * m
    k = k ^ (k >> r)
    k = k * m
    h = h ^ k
    h = h * m
    i = i + 8
  }

  // 处理剩余字节
  if i < len {
    let mut k = Int64::from_int(0)
    for j = len - 1; j >= i; j = j - 1 {
      k = (k << 8) | Int64::from_int(data[j].to_int() & 0xFF)
    }
    h = h ^ k
    h = h * m
  }
  h
}

///|
test "simhash" {
  // 测试相似文本
  let text1 = ["这是", "一个", "测试", "文本"]
  let text2 = ["这是", "一个", "测试", "样例"]
  print(is_similar(text1, text2))

  // 测试不相似文本
  let text3 = ["完全", "不同", "的", "例子"]
  print(is_similar(text1, text3))

  // 测试汉明距离
  let hash1 = calc_simhash(text1)
  let hash2 = calc_simhash(text2)
  //print(hamming_distance(hash1, hash2) < DEFAULT_HAMMING_THRESH)
}
