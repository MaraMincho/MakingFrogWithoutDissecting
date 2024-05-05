//
//  ATMachine.cpp
//  4th of Obejct Oriented Language Task
//
//  Created by MaraMincho on 4/3/24.
//

#include "ATMachine.hpp"
#include "Statics.hpp"

ATMachine::ATMachine(int size, int balance, string password) {
  this->nCurrentAccountNum = 0;
  this->nMachineBalance = balance;
  this->strManagerPassword = password;
  this->nMaxAccountNum = size;
  this->pAcctArray = new Account[this->nMaxAccountNum];
};

ATMachine::~ATMachine() {
  delete [] pAcctArray;
};

void ATMachine::displayMenu(){
  cout<< "\n\n======================" << endl;
  cout<< "-    TUKOREA BANK    -" << endl;
  cout<< "1. 계좌 개설" << endl;
  cout<< "2. 계좌 조회" << endl;
  cout<< "3. 계좌 해지" << endl;
  cout<< "4. 계좌 입금" << endl;
  cout<< "5. 계좌 출금" << endl;
  cout<< "6. 계좌 이체" << endl;
  cout<< "7. 고객 관리" << endl;
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
  Account* curAccount = checkAccount(id, pw);
  if (curAccount == NULL) {
    cout << "계좌 혹은 비밀번호를 확인해주세요" << endl;
  }else {
    cout << "현재 금액은 : " << curAccount->getBalance() << endl;
  }
}

Account* ATMachine::checkID(int id) {
  for (int ind = 0 ; ind < nCurrentAccountNum ; ind ++) {
    auto cur = &pAcctArray[ind];
    if (cur->isMatchID(id)) {
      return cur;
    }
  }
  return NULL;
}

Account* ATMachine::checkAccount(int id, string pw) {
  for (int ind = 0 ; ind < nCurrentAccountNum ; ind ++) {
    auto cur = &pAcctArray[ind];
    if (cur->check(id, pw) != AUTHENTIFICATION_FAIL) {
      return cur;
    }
  }
  return NULL;
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
    random_device rd;
    mt19937 gen(rd());
    uniform_int_distribution<> distrib(100, 999);
    return distrib(gen);
}

void ATMachine::transfer() {
  int currentID = enterID();
  string currentPW = enterPW();
  int transferTargetID = enterID();
  int money = enterMoney("이체금액 입력: ");
  
  Account* currentUser = checkAccount(currentID, currentPW);
  Account* transferTargetUser = checkID(transferTargetID);
  
  if (currentUser == NULL || transferTargetUser == NULL) {
    cout << "상대 계좌번호 혹은, 보내는분의 계정 정보가 일치하지 않습니다." << endl;
    return;
  }
  
  if (currentUser->withdraw(money) == NOT_ENOUGH_TO_WITHDRAW_MONEY)  {
    cout << "계좌 이체할만한 충분한 잔고가 없습니다." << endl;
    return;
  }
  cout << "현재 잔액 : " << currentUser->getBalance() << endl;
  transferTargetUser->deposit(transferTargetID, money);
  
}

bool ATMachine::isManager(string password) {
  return (password == "admin") ? true : false;
}

void ATMachine::managerMode(){
  cout << "------  관리  ------" << endl;
  string pw;
  cout << "관리자 비밀번호를 입력하세요: ";
  cin >> pw;
  if (!isManager(pw)) {
    cout << "잘못된 관리자 접근입니다." <<endl ;
    return;
  }
  
  cout << "관리자 입니다." << endl << endl;
  cout << "____________________" <<endl;
  cout << "ATM 현재 잔고: " << this->nMachineBalance << endl;
  
  cout << "고객 잔고 총액: " << Statistics::sum(this->pAcctArray, nMaxAccountNum) << "(총" << getNumberOfActiveAccount() << "명)" << endl;
  cout << "고객 잔고 평균: " << Statistics::average(this->pAcctArray, nMaxAccountNum) << endl;
  cout << "고객 잔고 최소: " << Statistics::min(this->pAcctArray, nMaxAccountNum) << endl;
  cout << "고객 잔고 최대: " << Statistics::max(this->pAcctArray, nMaxAccountNum) << endl;
  cout << "====================\n" << "-   고객 계좌 목록   -\n" << "====================" << endl;
  Statistics::sort(this->pAcctArray, nMaxAccountNum);
}

int ATMachine::getNumberOfActiveAccount() {
  int count = 0;
  for (int ind = 0 ; ind < nCurrentAccountNum ; ind ++) {
    auto cur = &pAcctArray[ind];
    if (cur -> activeAccount()) {
      count += 1;
    }
  }
  return count;
};
