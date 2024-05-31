//
//  TicketBox.hpp
//  TBOX
//
//  Created by MaraMincho on 5/30/24.
//

#ifndef TicketBox_hpp
#define TicketBox_hpp

#include <iostream>
#include "Screen.hpp"
#include "Statistics.hpp"
#define TICKETBOX_MANAGER_PWD "admin"
using namespace std;

class TicketBox {
public:
  virtual Screen * selectMenu() {
    return NULL;
  } // 상영관 선택 메뉴
  void Initialize() {
    
  }
};

class TUKoreaTBox : public TicketBox {
  CGVScreen * pCGVScreen;
  LotteCinemaScreen* pLotteCinemaScreen;
  MegaboxScreen * pMegaBoxScreen;
public:
  TUKoreaTBox();
  ~TUKoreaTBox();
  Screen * selectMenu() override;
  void Initialize();
  void Manage();
};


#endif /* TicketBox_hpp */
