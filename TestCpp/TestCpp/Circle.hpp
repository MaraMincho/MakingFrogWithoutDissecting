//
//  Circle.hpp
//  TestCpp
//
//  Created by MaraMincho on 3/28/24.
//

#ifndef Circle_hpp
#define Circle_hpp

#include <stdio.h>

#endif /* Circle_hpp */

#include <iostream>

using namespace std;
class Circle {
  int radius;
public:
  Circle() : Circle(1) {};
  Circle(int r) {
    this->radius = r;
  }
  void setRadius(int r) { radius = r; }
  double getArea() { return 3.14*radius*radius; }
};
