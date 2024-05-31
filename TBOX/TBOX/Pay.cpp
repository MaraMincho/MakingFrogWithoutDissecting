//
//  Pay.cpp
//  TBOX
//
//  Created by MaraMincho on 5/31/24.
//

#include "Pay.hpp"

int CardPay::charge(int amount) {
  std::cout << "[카드 결제]" << std::endl;
  std::cout << "카드 번호 입력(12자리 수)";
  std::string cardNumber;
  
  std::cin >> cardNumber;
  
  std::cout << "이름 :";
  std::string name;
  std::cin >> name;
  
  int ticketPrice = amount + amount * this->interest;
  
  std::cout << "TUKOREA CARD 결제가 완료되었습니다. :" << ticketPrice << std::endl;
  return ticketPrice;
};

int MobilePay::charge(int amount) {
  std::cout << "[휴대폰 결제]" << std::endl;
  std::cout << "휴대폰 번호 입력(11자리 수)";
  std::string cardNumber;
  
  std::cin >> cardNumber;
  
  std::cout << "이름 :";
  std::string name;
  std::cin >> name;
  
  int ticketPrice =  amount + amount * this->interest;
  
  std::cout << "TUKOREA 모바일 결제가 완료되었습니다. :" << ticketPrice << std::endl;
  return ticketPrice;
  
}
	
int BankTransfer::charge(int amount) {
  std::cout << "[은행 결제]" << std::endl;
  std::cout << "은행 번호 입력(11자리 수)";
  std::string cardNumber;
  
  std::cin >> cardNumber;
  
  std::cout << "이름 :";
  std::string name;
  std::cin >> name;
  
  int ticketPrice =  amount + amount * this->interest;
  
  std::cout << "TUKOREA 은행 결제가 완료되었습니다. :" << ticketPrice << std::endl;
  return ticketPrice;
}


PaymentSystem::PaymentSystem() {
    payment[0] = nullptr; // 인덱스 0은 사용하지 않음
    payment[MOBILE_PHONE_PAYMENT] = new MobilePay();
    payment[BANK_TRANSFER_PAYMENT] = new BankTransfer();
    payment[CREDIT_CARD_PAYMENT] = new CardPay();
}
PaymentSystem::~PaymentSystem() {
  for (int i = 0; i < 4; i ++) {
    delete payment[i];
  }
  
}


void PaymentSystem::paymentProcess(int amount, Ticket* ticket) {
    std::cout << "결제 유형을 선택하세요 (1: 휴대폰, 2: 은행, 3: 카드): ";
    int paymentType;
    std::cin >> paymentType;

    Pay* pay = getPay(paymentType);
    if (pay == nullptr) {
        std::cout << "유효하지 않은 결제 유형입니다." << std::endl;
        return;
    }

    ticket->setPayAmount(pay->charge(amount));
    ticket->setCheck(SEAT_COMPLETION_MARK);
}
