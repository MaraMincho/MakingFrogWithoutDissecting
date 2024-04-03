//
//  Rectangle.cpp
//  TestCpp
//
//  Created by MaraMincho on 3/19/24.
//

#include "Rectangle.hpp"
#include <iostream>
using namespace std;
class Rectangle {
public:
  int width, height;
  Rectangle();
  Rectangle(int w, int h);
  Rectangle(int length);
  bool isSquare();
};

Rectangle::Rectangle() {
  width = height = 1;
}

Rectangle::Rectangle(int w, int h) {
  width = w; height = h;
}

Rectangle::Rectangle(int length) {
  width = height = length;
} // 정사각형이면 true를 리턴하는 멤버 함수

bool Rectangle::isSquare() {
  return width == height;
}
