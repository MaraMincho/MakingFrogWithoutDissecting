//
//  Acount.hpp
//  4th of Obejct Oriented Language Task
//
//  Created by MaraMincho on 4/3/24.
//

#ifndef Acount_hpp
#define Acount_hpp

#include <iostream>
#include <string>

using std::string;
#define AUTHENTIFICATION_FAIL -1 // 계정 인증 실패
#define AUTHENTIFICATION_SUCCESS 1 // 계정 인증 성공
#define BASE_ACCOUNT_ID 100 // 계좌번호는 100번 부터 999 사이 랜덤으로 부여

#define ACCOUNT_CLOSE_SUCCESS 1
#define ACCOUNT_CLOSE_FAIL -1

class Account {
private:
  int nID; // 계좌 번호 (초기 값 = -1) , 계좌 해지시 초기값으로 변경
  int nBalance; // 잔고 (초기 값 = 0)
  string strAccountName; // 고객 명
  string strPassword; // 계좌 비밀번호
  bool accountStatus;
  
private:
  inline bool authenticate(int id, string passwd); // 인증 성공 : true(1), 인증 실패 : false(0)
  
public:
  Account() { };
  void create(int id, int money, string name, string password); // 계좌 개설
  int check(int id, string password); // return 값 : nBalance (잔고) or 인증 실패(AUTHENTIFICATION_FAIL)
  int getAcctID() { return nID; } // 계좌 번호 읽어오기
  int getBalance() { return nBalance; }
  
  int closeAccount();
  bool activeAccount() { return accountStatus;};
  int deposit(int id, string password, int money);
  int withdraw(int id, string password, int money);
  
  void display() {
    std::cout << "id:  " << nID << "\n" << "비밀번호:  " << strPassword << std::endl;
  }
};
#endif /* Acount_hpp */
