//
//  Adder.hpp
//  TestCpp
//
//  Created by MaraMincho on 3/21/24.
//

#ifndef Adder_hpp
#define Adder_hpp

#include <stdio.h>

class Adder { // 덧셈 모듈 클래스
  int op1, op2;
public:
  Adder(int a, int b);
  int process();
};


#endif /* Adder_hpp */
