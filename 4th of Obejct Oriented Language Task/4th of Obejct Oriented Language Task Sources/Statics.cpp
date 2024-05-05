//
//  Statics.cpp
//  4th of Obejct Oriented Language Task
//
//  Created by MaraMincho on 5/5/24.
//

#include "Statics.hpp"

using namespace std;

int Statistics::sum(Account *pArray, int size) {
  int sum = 0;
  
  for (int ind = 0; ind < size ; ind ++) {
    Account* cur = (pArray + ind);
    if (cur->activeAccount()) {
      sum += cur->getBalance();
    }
  }
  return sum;
};

int Statistics::average(Account *pArray, int size) {
  int activeAccountCount = 0;
  int sum = 0;
  
  for (int ind = 0; ind < size ; ind ++) {
    Account* cur = (pArray + ind);
    if (cur->activeAccount()) {
      activeAccountCount += 1;
      sum += cur->getBalance();
    }
  }
  return sum / activeAccountCount;
}

int Statistics::min(Account *pArray, int size){
  int minVal = 2147483647;
  
  for (int ind = 0; ind < size ; ind ++) {
    Account* cur = (pArray + ind);
    if (cur->activeAccount()) {
      minVal = (minVal > cur->getBalance()) ? cur->getBalance() : minVal;
    }
  }
  return (minVal == 2147483647) ? FAILED_GET_MINVAL_OF_ACCOUNTS : minVal;
}

int Statistics::max(Account *pArray, int size) {
  int maxVal = -2147483648;
  
  for (int ind = 0; ind < size ; ind ++) {
    Account* cur = (pArray + ind);
    if (cur->activeAccount()) {
      maxVal = (maxVal < cur->getBalance()) ? cur->getBalance() : maxVal;
    }
  }
  return (maxVal == -2147483648) ? FAILED_GET_MINVAL_OF_ACCOUNTS : maxVal;
}


void Statistics::sort(Account *pArray, int size) {
  int activeAccountCount = 0;
  
  for (int ind = 0; ind < size ; ind ++) {
    Account* cur = (pArray + ind);
    if (cur->activeAccount()) {
      activeAccountCount += 1;
    }
  }
  
  Account activeAccounts[activeAccountCount];
  int activeAccountsInd = 0;
  for (int ind = 0; ind < size ; ind ++) {
    Account* cur = (pArray + ind);
    if (cur->activeAccount()) {
      activeAccounts[activeAccountsInd] = *cur;
      activeAccountsInd += 1;
    }
  }
  
  for (int fInd = 0 ; fInd < activeAccountCount - 1; fInd ++) {
    for (int sInd = fInd + 1; sInd < activeAccountCount; sInd++) {
      if (activeAccounts[fInd].getBalance() < activeAccounts[sInd].getBalance()) {
        auto temp = activeAccounts[fInd];
        activeAccounts[fInd] = activeAccounts[sInd];
        activeAccounts[sInd] = temp;
      }
    }
  }
  
  
  
  for (int ind = 0; ind < activeAccountCount ; ind++) {
    Account cur = activeAccounts[ind];
    cout << ind + 1 << ". " << cur.getAccountName() << "    " << cur.getAcctID() << "    " << cur.getBalance() << endl;
    
  }
  
}
