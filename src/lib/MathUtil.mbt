///|
pub struct Calculator {
  operators : @sorted_map.T[Char, Int]
  op_stack : Array[Char]
  num_stack : Array[Int]
}

///|
pub fn Calculator::new() -> Calculator {
  let ops = @sorted_map.new()
  ops.add('+', 1)
  ops.add('-', 1)
  ops.add('*', 2)
  ops.add('/', 2)
  ops.add('^', 3)
  { operators: ops, op_stack: [], num_stack: [] }
}

///|
pub fn Calculator::eval(self : Calculator) -> Unit {
  if self.num_stack.length() < 2 || self.op_stack.length() < 1 {
    return
  }
  let a = self.num_stack[self.num_stack.length() - 1]
  ignore(self.num_stack.unsafe_pop())
  let b = self.num_stack[self.num_stack.length() - 1]
  ignore(self.num_stack.unsafe_pop())
  let op = self.op_stack[self.op_stack.length() - 1]
  ignore(self.op_stack.unsafe_pop())
  let ans = match op {
    '+' => b + a
    '-' => b - a
    '*' => b * a
    '/' => b / a
    '^' => {
      let mut result = 1
      let mut power = a
      while power > 0 {
        result = result * b
        power = power - 1
      }
      result
    }
    _ => 0
  }
  self.num_stack.push(ans)
}

///|
pub fn calculate(expr : String) -> Int {
  let calc = Calculator::new()
  let mut i = 0
  while i < expr.length() {
    let c = expr[i]
    if c >= '0' && c <= '9' {
      let mut num = 0
      let mut j = i
      while j < expr.length() && expr[j] >= '0' && expr[j] <= '9' {
        num = num * 10 + (expr[j].to_int() - '0'.to_int())
        j = j + 1
      }
      calc.num_stack.push(num)
      i = j
      continue
    } else if c == '(' {
      calc.op_stack.push(c)
    } else if c == ')' {
      // 计算括号内的表达式直到遇到左括号
      while calc.op_stack.length() > 0 &&
            calc.op_stack[calc.op_stack.length() - 1] != '(' {
        calc.eval()
      }
      // 弹出左括号
      if calc.op_stack.length() > 0 {
        ignore(calc.op_stack.unsafe_pop())
      }
    } else if c != ' ' {
      // 处理运算符优先级
      while calc.op_stack.length() > 0 &&
            calc.op_stack[calc.op_stack.length() - 1] != '(' &&
            calc.operators
            .get(calc.op_stack[calc.op_stack.length() - 1])
            .unwrap() >=
            calc.operators.get(c).unwrap() {
        calc.eval()
      }
      calc.op_stack.push(c)
    }
    i = i + 1
  }
  while calc.op_stack.length() > 0 {
    calc.eval()
  }
  if calc.num_stack.length() > 0 {
    calc.num_stack[0]
  } else {
    0
  }
}
// 排列组合部分
fn factorial(n: Int) -> Int {
    if n <= 1 { 1 } else { n * factorial(n - 1) }
}

fn factorial_range(n: Int, m: Int) -> Int {
    let mut result = 1
    for i = m + 1; i <= n; i = i + 1 {
        result = result * i
    }
    result
}

// 计算排列数
pub fn arrangement_count(n: Int, m: Int) -> Int {
    if n == m {
        factorial(n)
    } else if n > m {
        factorial_range(n, n - m)
    } else {
        0
    }
}

// 计算组合数
pub fn combination_count(n: Int, m: Int) -> Int {
    if m == 0 || n == m {
        1
    } else if n > m {
        factorial_range(n, n - m) / factorial(m)
    } else {
        0
    }
}