//
//  Calculator.cpp
//  TestCpp
//
//  Created by MaraMincho on 3/21/24.
//

#include <iostream>
#include "Calculator.hpp"
#include "Adder.hpp"

void Calculator::run() {
  std::cout << "두 수를 입력하세요 \n" << std::endl;
  
  int a, b;
  std::cin >> a >> b; // 정수 두 개 입력
  Adder adder(a, b); // 덧셈기 생성
  std::cout << adder.process() << "\n" << std::endl; // 덧셈 계산
}
