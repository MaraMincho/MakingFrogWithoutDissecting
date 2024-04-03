//
//  Adder.cpp
//  TestCpp
//
//  Created by MaraMincho on 3/21/24.
//

#include "Adder.hpp"

Adder::Adder(int a, int b) {
  op1 = a; op2 = b;
}

int Adder::process() {
  return op1 + op2;
}
