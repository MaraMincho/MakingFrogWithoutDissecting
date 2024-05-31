//
//  TicketBox.cpp
//  TBOX
//
//  Created by MaraMincho on 5/30/24.
//

#include "TicketBox.hpp"


//MARK: - TUKOREA BOX
TUKoreaTBox::TUKoreaTBox() {
  pCGVScreen = nullptr;
  pLotteCinemaScreen = nullptr;
  pMegaBoxScreen = nullptr;
}

TUKoreaTBox::~TUKoreaTBox() {
  delete pCGVScreen;
  delete pLotteCinemaScreen;
  delete pMegaBoxScreen;
}

void TUKoreaTBox::Initialize() {
  pCGVScreen = new CGVScreen("더이퀄라이져 3", 15000, 8, 8);
  pLotteCinemaScreen = new LotteCinemaScreen("더 리더: 책 읽어주는 남자", 12000, 10, 10);
  pMegaBoxScreen = new MegaboxScreen("인터스텔라", 20000, 8, 8);
}

Screen* TUKoreaTBox::selectMenu() {
  cout << "========================" <<endl;
  cout << "    상영관 메인 메뉴" << endl;
  cout << "========================" <<endl;
  cout << "1. CJ CGV       솔로 1관" <<endl;
  cout << "2. 롯데시네마       영화 2관" <<endl;
  cout << "3. 메가박스       영화 3관" <<endl;
  cout << "9. 통계 관리" << endl;
  cout << endl;
  cout << "선택 그 외 종료 : ";
  int currentIndex = 0;
  cin >> currentIndex;
  
  Screen * res = nullptr;
  switch (currentIndex) {
    case 1:
      res = pCGVScreen;
      break;
    case 2:
      res = pLotteCinemaScreen;
      break;
    case 3:
      res = pMegaBoxScreen;
      break;
    case 9:
      Manage();
      exit(0);
  }
  if (currentIndex <= 0 || currentIndex > 3) {
    return nullptr;
  }
  return res;
}

void TUKoreaTBox::Manage() {
  cout << "================" << endl;
  cout << "관리자 메뉴" << endl;
  cout << "================" << endl;
  cout << "관리자 비밀번호 입력" ;
  string pw;
  cin >> pw;
  if (pw == TICKETBOX_MANAGER_PWD) {
    cout << "1. CJ CGV상영관 결제 금액: " << Statistics::totalRevenue(pCGVScreen ) << endl;
    cout << "2. 롯데시네마 상영관 결제금액 : " << Statistics::totalRevenue(pLotteCinemaScreen) << endl;
    cout << "3. 메가박스 상영관 결제금액 : "<< Statistics::totalRevenue(pMegaBoxScreen) << endl;
    auto salesCount = [](Screen* screen) -> int{
      return Statistics::totalSalesCount(screen);
    };
    int totalTicketSalesCount = salesCount(pCGVScreen) + salesCount(pLotteCinemaScreen) + salesCount(pMegaBoxScreen);
    cout << "4 전체 티켓 판매량: " << totalTicketSalesCount << endl << endl;
  }else {
    cout << "관리자 비밀번호가 일치하지 않습니다." <<endl << endl;
  }
}
