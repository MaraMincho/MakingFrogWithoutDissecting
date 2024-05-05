//
//  Statics.hpp
//  4th of Obejct Oriented Language Task
//
//  Created by MaraMincho on 5/5/24.
//

#ifndef Statics_hpp
#define Statics_hpp

#include <stdio.h>
#include "Account.hpp"

#define FAILED_GET_MINVAL_OF_ACCOUNTS -1
#define FAILED_GET_MAXVAL_OF_ACCOUNTS -1

class Statistics {
private:
  
  static bool compare(Account lhs, Account rhs) {
    return (lhs.getBalance() > rhs.getBalance());
  }
public:
  // 계좌 잔고 총합
  static int sum(Account * pArray, int size);
  // 계좌 잔고 평균
  static int average(Account * pArray, int size);
  
  // 계좌 잔고 최소
  static int min(Account * pArray, int size);
  // 계좌 잔고 최고
  static int max(Account * pArray, int size);
  // (잔액 기준) 내림 차순 정렬
  // 자료구조 없이 구현
  static void sort(Account* pArray, int size) ;
  

};

#endif /* Statics_hpp */
