//
//  Acount.cpp
//  4th of Obejct Oriented Language Task
//
//  Created by MaraMincho on 4/3/24.
//

#include "Account.hpp"

void Account::create(int id, int money, string name, string password) {
  this->nID = id;
  this->nBalance = 0;
  this->strAccountName = name;
  this->strPassword = password;
  this->accountStatus = true;
};

int Account::check(int id, string password) {
  if (authenticate(id, password)) {
    return this->nBalance;
  }
  return AUTHENTIFICATION_FAIL;
}

bool Account::authenticate(int id, string passwd) {
  return (
          this->accountStatus &&
          this->nID == id &&
          this->strPassword == passwd
          );
}

int Account::closeAccount() {
  if (this->nBalance > 0) {
    return ACCOUNT_CLOSE_FAIL;
  }
  this->accountStatus = false;
  return ACCOUNT_CLOSE_SUCCESS;
}

int Account::deposit(int id, string password, int money) {
  if (authenticate(id, password)) {
    this->nBalance += money;
    return this->nBalance;
  }
  return AUTHENTIFICATION_FAIL;
}

int Account::withdraw(int id, string password, int money) {
  if (authenticate(id, password) && nBalance - money >= 0) {
    this->nBalance -= money;
    return this->nBalance;
  }
  return AUTHENTIFICATION_FAIL;
}
