//
//  main.cpp
//  StickerMachine
//
//  Created by MaraMincho on 5/22/24.
//

#include <iostream>
#include "Paper.hpp"
#include "vector"

using namespace std;

int main(int argc, const char * argv[]) {
  MathTest* ptr = new AutoText();
  
  vector<Testable> curTest;
  ptr->end();
  cout << ptr->isError() << endl;
  return 0;
}

class CurInterFace {
public:
  virtual void printPicture() = 0;
  virtual void testPicture() = 0;
  virtual void confirmPicture() = 0;
  virtual ~CurInterFace() = 0;
};
