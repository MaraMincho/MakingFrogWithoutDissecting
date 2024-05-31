//
//  Pay.hpp
//  TBOX
//
//  Created by MaraMincho on 5/31/24.
//

#pragma once
#ifndef Pay_hpp
#define Pay_hpp

#include <iostream>
#include "Ticket.hpp"

#define MOBILE_PHONE_PAYMENT 1
#define BANK_TRANSFER_PAYMENT 2
#define CREDIT_CARD_PAYMENT 3
#define MOBILE_PHONE_INTEREST_RATE 0.2 // 모바일 결제 수수료 비율(이자율)
#define BANK_TRANSFER_INTEREST_RATE 0.1 // 은행 이체 결제 수수료 비율 (이자율)
#define CREDIT_CARD_INTEREST_RATE 0.15 // 신용카드 결제 수수료 비율(이자율)

class Pay {
public: 
  virtual int charge(int amount) = 0; // 결제하기
};

class CardPay : public Pay { 
  double interest;
public:
  CardPay(double rate) { this->interest = rate; }
  int charge(int amount) override; // 결제금액 = 티켓 가격 + 티켓 가격 * 카드수수료 비율
  CardPay() {
    this -> interest = CREDIT_CARD_INTEREST_RATE;
  }
};

class BankTransfer : public Pay {
  double interest;
public:
  BankTransfer(double rate) { this->interest = rate; }
  int charge(int amount) override; // 결제금액 = 티켓 가격 + 티켓 가격 * 은행수수료 비율
  BankTransfer() {
    this->interest = BANK_TRANSFER_INTEREST_RATE;
  }

};

class MobilePay : public Pay {
  double interest;
public: 
  MobilePay(double rate) { this->interest = rate; }
  int charge(int amount) override; // 결제금액 = 티켓 가격 + 티켓 가격 * 모바일수수료 비율
  MobilePay(){
    this->interest = MOBILE_PHONE_INTEREST_RATE;
  }

};

class PaymentSystem {
private:
  Pay* payment[4];
  
public:
  PaymentSystem();
  ~PaymentSystem();
  
  void paymentProcess(int amount, Ticket* ticket);
  Pay* getPay(int ind) {
    if (0 < ind && ind <= 3) {
      return payment[ind];
    }
    return nullptr;
  }
};
#endif
