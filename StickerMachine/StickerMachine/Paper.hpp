//
//  Paper.hpp
//  StickerMachine
//
//  Created by MaraMincho on 5/22/24.
//

#ifndef Paper_hpp
#define Paper_hpp

#include <iostream>
using namespace std;

class Testable {
public:
  virtual int isTrueValue() = 0 ;
  virtual int isError() = 0;
  virtual void end() = 0;
};

class MathTest: public Testable {
public:
  int isError() override {
    return 1;
  };
  int isTrueValue() override {
    return 0;
  };
  void end() override {
    cout << "isEnd" << endl;
  };
};

class AutoText: public MathTest {
public:
  void end() override {
    cout << "autoTextEnd" << endl;
  };
  int isError() override {
    return 22;
  };
  int isTrueValue() override {
    return 33;
  };
};


#endif /* Paper_hpp */
