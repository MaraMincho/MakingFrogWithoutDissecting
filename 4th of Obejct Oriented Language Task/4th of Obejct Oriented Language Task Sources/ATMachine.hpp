//
//  ATMachine.hpp
//  4th of Obejct Oriented Language Task
//
//  Created by MaraMincho on 4/3/24.
//

#ifndef ATMachine_hpp
#define ATMachine_hpp

#include "Account.hpp"
#include <string>
#include <random>


using namespace std;

#define NEGATIVE_ATM_BALANCE -10 // ATM 잔액 부족
class ATMachine {
private:
  Account * pAcctArray; // 동적 생성된 고객계좌 배열 포인터
  int nMachineBalance; // ATM 잔고
  int nMaxAccountNum; // 동적 생성된 고객계좌 배열 크기
  int nCurrentAccountNum; // 개설된 고객 계좌 수
  string strManagerPassword; // 관리자 비밀번호
  
  string enterName();
  int enterID();
  string enterPW();
  int createID();
  int enterMoney(string description);
  
  // 추가 기능 2,3 - 고객 관리 기능
  bool isManager(string password); // 메니저 암호 확인
  void displayReport(); // 통계 화면 처리
  Account* checkAccount(int id, string pw);
  Account* checkID(int id);
  
public:
  ATMachine(int size, int balance, string password); // 계좌 배열크기, ATM 잔고, 관리자 암호 초기화
  ~ATMachine();
  void displayMenu(); // ATM 기능 선택 화면
  void createAccount(); // 계좌 개설
  void checkMoney(); // 계좌 조회
  
  void close();
  void depositMoney();
  void withdrawMoney();
  
  // 추가 기능 2,3 - 고객 관리 기능
  void managerMode(); // 고객 관리
  void transfer(); // 계좌 이체
  int getNumberOfActiveAccount();
};
#endif
