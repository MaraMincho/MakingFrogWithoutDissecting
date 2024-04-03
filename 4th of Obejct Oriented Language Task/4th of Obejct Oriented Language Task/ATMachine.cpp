//
//  ATMachine.cpp
//  4th of Obejct Oriented Language Task
//
//  Created by MaraMincho on 4/3/24.
//

#include "ATMachine.hpp"

ATMachine::ATMachine(int size, int balance, string password) {
  this->nCurrentAccountNum = 0;
  this->nMachineBalance = balance;
  this->strManagerPassword = password;
  this->nMaxAccountNum = size;
  this->pAcctArray = new Account[this->nMaxAccountNum];
};

ATMachine::~ATMachine() {
};

void ATMachine::displayMenu(){
  cout<< "\n\n======================" << endl;
  cout<< "-    TUKOREA BANK    -" << endl;
  cout<< "1. 계좌 개설" << endl;
  cout<< "2. 계좌 조회" << endl;
  cout<< "3. 계좌 해지" << endl;
  cout<< "4. 계좌 입금" << endl;
  cout<< "5. 계좌 출금" << endl;
  cout<< "9. 업무 종료" << endl;
}


void ATMachine::createAccount() {
  string name = enterName();
  string pw = enterPW();
  int id = createID();
  
  auto cur = &pAcctArray[nCurrentAccountNum];
  cur->create(id, 0, name, pw);
  cout << name << "님 " << id << "계좌가 성공적으로 생성되었습니다." << endl;
  
  nCurrentAccountNum += 1;
}

void ATMachine::checkMoney() {
  int id = enterID();
  string pw = enterPW();
  for (int ind = 0 ; ind < nCurrentAccountNum ; ind ++) {
    auto cur = &pAcctArray[ind];
    if (cur->check(id, pw) != AUTHENTIFICATION_FAIL) {
      cout << "현재 금액은 : " << cur->getBalance() << endl;
      return;
    }
  }
  cout << "계좌 혹은 비밀번호를 확인해주세요" << endl;
}

void ATMachine::close() {
  int id = enterID();
  string pw = enterPW();
  for (int ind = 0 ; ind < nCurrentAccountNum ; ind ++) {
    auto cur = &pAcctArray[ind];
    if (cur->check(id, pw) != AUTHENTIFICATION_FAIL) {
      cur->closeAccount() == ACCOUNT_CLOSE_SUCCESS ?
      cout << "성공적으로 계좌를 해지했습니다."<< endl :
      cout << "잔금이 남아있어 계좌 해지에 실패했습니다." << endl;
      return;
    }
  }
  cout << "계좌 혹은 비밀번호를 확인해주세요" << endl;
}

void ATMachine::depositMoney() {
  int id = enterID();
  string pw = enterPW();
  int money = enterMoney("예금하실 금액을 입력해주세요: ");
  for (int ind = 0 ; ind < nCurrentAccountNum ; ind ++) {
    auto cur = &pAcctArray[ind];
    if (cur->deposit(id, pw, money) != AUTHENTIFICATION_FAIL) {
      cout << "현재 잔액: " << cur->getBalance() << endl;
      nMachineBalance += money;
      return;
    }
  }
  cout << "계좌 혹은 비밀번호를 확인해주세요" << endl;
}

void ATMachine::withdrawMoney() {
  int id = enterID();
  string pw = enterPW();
  int money = enterMoney("예금하실 금액을 입력해주세요: ");
  
  if (money >= nMachineBalance){
    cout << "ATM에 충분한 돈이 들어있지 않습니다.\n" << nMachineBalance << "이하의 가격을 입력해 주세요" << endl;
    return;
  }
  
  for (int ind = 0 ; ind < nCurrentAccountNum ; ind ++) {
    auto cur = &pAcctArray[ind];
    if (cur->withdraw(id, pw, money) != AUTHENTIFICATION_FAIL) {
      cout << "현재 잔액: " << cur->getBalance() << endl;
      nMachineBalance -= money;
      return;
    }
  }
  cout << "계좌, 비밀번호 혹은 통장잔고를 확인해주세요" << endl;
}

string ATMachine::enterName() {
  string name = "";
  cout << "이름을 입력하세요: ";
  cin >> name;
  return name;
}

int ATMachine::enterID(){
  int id;
  cout << "계좌번호를 입력하세요: ";
  cin >> id;
  return id;
}

string ATMachine::enterPW() {
  string pw;
  cout << "비밀번호를 입력하세요: ";
  cin >> pw;
  return pw;
}

int ATMachine::enterMoney(string description) {
  cout << description;
  int money = 0;
  cin >> money;
  return money;
}

int ATMachine::createID() {
    random_device rd;  // 시드 생성
    mt19937 gen(rd()); // 메르센 트위스터 엔진 초기화
    uniform_int_distribution<> distrib(100, 999); // 100 ~ 999 범위의 균등 분포

    return distrib(gen); // 랜덤 계좌 번호 생성 후 반환
}
