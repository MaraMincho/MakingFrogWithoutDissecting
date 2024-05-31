//
//  Screen.hpp
//  TBOX
//
//  Created by MaraMincho on 5/30/24.
//

#ifndef Screen_hpp
#define Screen_hpp

#include <iostream>
#include <cstring>
#include "Ticket.hpp"
#include "Pay.hpp"

using namespace std;
class Screen {
protected:
  int nTicketPrice; // 티켓 가격
  int nRowMax, nColMax; // 좌석 행과 열 최대 값
  int nCurrentReservedId; // 발급된 마지막 예약 번호
  Ticket ** pSeatArray; // 스크린 좌석에 대한 티켓 배열
  string strMovieName; // 스크린 상영중인 영화 제목
  
public:
  Screen(string name, int price, int row, int col); 
  ~Screen();
  
  void showSeatMap(); // 좌석 예약 여부 맵으로 보기
  virtual void showMovieMenu(); // 영화 예매 메뉴
  virtual void showMovieInfo() = 0; // 영화 소개 정보
  
  void reserveTicket(); // 좌석 예약하기
  Ticket* getTicket(int row, int col) {
    // Assuming a row-major order
    if (0 <= row && row < nRowMax && 0 <= col && col < nColMax) {
      return &pSeatArray[row][col];
    }
    return nullptr;
  };
  
  void changeTicket();// 좌석 변경
  Ticket* getTicket(int id) {
    for (int row = 0; row < nRowMax; row ++) {
      for( int col = 0; col < nColMax; col ++) {
        Ticket * currentTicket = getTicket(row, col);
        if (currentTicket->getReservedID() == id) {
          return currentTicket;
        }
      }
    }
    return nullptr;
  }
  
  int getTicketPrice() { return nTicketPrice; }
  void payment(); // 결제하기
  void printPaymentDescription();
  
  int getRowMax() { return nRowMax; }
  int getColMax() { return nColMax; }
  Ticket** getTicketArray() { return pSeatArray; }
};

class CGVScreen : public Screen {
public: 
  CGVScreen(string name, int price, int row, int col) : Screen( name, price, row, col) {}
  void showMovieInfo();
};

class LotteCinemaScreen : public Screen {
public: 
  LotteCinemaScreen(string name, int price, int row, int col) : Screen(name, price, row, col) {}
  void showMovieInfo();
};

class MegaboxScreen : public Screen {
public: 
  MegaboxScreen(string name, int price, int row, int col) : Screen(name, price, row, col) {}
  void showMovieInfo();
};

#endif /* Screen_hpp */
