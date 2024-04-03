//
//  Vehicle.hpp
//  TestCpp
//
//  Created by MaraMincho on 3/21/24.
//

#ifndef Vehicle_hpp
#define Vehicle_hpp

#include <stdio.h>

#endif /* Vehicle_hpp */

class Vehicle {
  int tire;
  
private:
  Vehicle();

public:
  Vehicle(int countOfTire) {
    this->tire = countOfTire;
  }
};

