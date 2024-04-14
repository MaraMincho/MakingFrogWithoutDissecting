//
//  main.cpp
//  4th of Obejct Oriented Language Task
//
//  Created by MaraMincho on 4/3/24.
//
#include <iostream>
#include "ATMachine.hpp"
enum Tst {
  case1,
  cas2,
};
Tst Test() {
  return cas2;
}


using namespace std;
int main() {
  auto val = Test();

  int select;
  // 고객 수(100명), ATM 잔금 초기화, 관리자 암호
  ATMachine atm(100, 50000, "admin");
  while(1) {
    atm.displayMenu();
    std::cout << "메뉴를 선택하세요: " ;
    cin >> select;
    cout << endl;
    switch(select) {
      case 1:
        atm.createAccount();
        break;
      case 2:
        atm.checkMoney();
        break;
      case 3:
        atm.close();
        break;
      case 4:
        atm.depositMoney();
        break;
      case 5:
        atm.withdrawMoney();
        break;
      case 9:
        return 0;
      default:
        cout<<"번호 확인 후 다시 입력하세요."<<endl;
    }
  }
  return 0;
}
