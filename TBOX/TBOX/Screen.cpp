//
//  Screen.cpp
//  TBOX
//
//  Created by MaraMincho on 5/30/24.
//

#include "Screen.hpp"


//MARK: Screen
Screen::Screen(string name, int price, int row, int col) {
  this->strMovieName = name;
  this->nTicketPrice = price;
  this->nRowMax = row;
  this->nColMax = col;
  this->nCurrentReservedId = 100;
  
  pSeatArray = new Ticket*[row];
  for (int t = 0; t < row; t ++) {
    pSeatArray[t] = new Ticket[col];
  }
  
  for (int currentRow = 0; currentRow < row; currentRow ++) {
    for (int currentCol = 0; currentCol < col ; currentCol ++ ) {
      //MARK: - 티켓 초기화
      Ticket * currentTicket = getTicket(currentRow, currentCol);
      currentTicket->setSeat(currentRow, currentCol);
      currentTicket->setReservedID(NOT_RESERVED_ID);
      currentTicket->setCheck(SEAT_EMPTY_MARK);
    }
  }
};

void Screen::showMovieMenu() {
  
  cout << "====================================" << endl;
  cout << "    메뉴: " << this->strMovieName << endl;
  cout << "====================================" << endl;
  cout << "1. 영화 정보" << endl;
  cout << "2. 예약 현황" << endl;
  cout << "3. 예약 하기" << endl;
  cout << "4. 좌석 변경" << endl;
  cout << "7. 메인 메뉴 이동" << endl << endl;
}

void Screen::showSeatMap() {
  cout << "좌석 예약 현황" << endl;
  
  cout << "        " ;
  for (int col = 0; col < this->nColMax ; col ++ ) {
    cout << "[" << col + 1 << "] ";
  }
  cout << endl;
    
  for (int row = 0; row < this->nRowMax ; row ++ ) {
    cout.width(8); // 정렬
    string curStr = "[" + to_string(row + 1) + "]" ;
    cout << left << curStr;
    for (int col = 0 ; col < this->nColMax; col ++) {
      Ticket * currentTicket = getTicket(row, col);
      cout << "[" << currentTicket->getCheck()  << "] ";
    }
    cout << endl;
  }
}

Screen::~Screen() {
  for (int t = 0; t < this->nRowMax; t ++) {
    delete [] pSeatArray[t];
  }
  
  delete [] pSeatArray;
}

// 추가기능1: 좌석 예약하기
void Screen::reserveTicket() {
  cout << "[ " << "좌석 예약" << "]" << endl;
  
  cout << "좌석 행 번호 입력 (" << this->nColMax << " ~ 1) : ";
  int userInputCol;
  cin >> userInputCol;
  
  cout << "좌석 열 번호 입력 (" << this->nRowMax << " ~ 1) : ";
  int userInputRow;
  cin >> userInputRow;
  
  // 가중치 조정
  userInputCol -= 1;
  userInputRow -= 1;
  
  auto seatAboutTicketByUserInput = getTicket(userInputRow, userInputCol);
  // 비어있을 때
  if (seatAboutTicketByUserInput->getCheck() == SEAT_EMPTY_MARK) {
    int currentReservationValue = ++nCurrentReservedId;
    seatAboutTicketByUserInput->setReservedID(currentReservationValue);
    seatAboutTicketByUserInput->setCheck(SEAT_RESERVED_MARK);
    
    cout << "행[" << userInputRow << "] 열[" << userInputCol
    << "] " << currentReservationValue << " 예약번호로 접수되었습니다." << endl;
  }else {
    cout << "이미 예약된 좌석입니다. 다른 좌석을 입력해 주세요" << endl << endl;
  }
  
}

// MARK: - CGV Screen
void CGVScreen::showMovieInfo() {
  cout<< "--------------------------" << endl;
  cout<< "[" << this->strMovieName << "]" << endl;
  cout<< "--------------------------" << endl;
  cout << "영화관 : CGV 솔로 1관" << endl;
  cout << "주인공 : 덴젤워싱턴, 다코타 패닝" << endl;
  cout << "줄거리 : 특수 요원 시절의 어두운 과거로 인해 괴로워하던 로버트 맥콜은..." << endl;
  cout << "가격 : " << this->nTicketPrice << endl << endl;
}

void LotteCinemaScreen::showMovieInfo() {
  cout<< "--------------------------" << endl;
  cout<< "[" << this->strMovieName << "]" << endl;
  cout<< "--------------------------" << endl;
  cout << "영화관 : 롯데 시네마 영화 2관" << endl;
  cout << "주인공 : 케이트 윈슬렛 랄프 파인즈" << endl;
  cout << "줄거리 :  10대 마이클은 30대 한나를 만나 사랑에 빠진다..." << endl;
  cout << "가격 : " << this->nTicketPrice << endl << endl;
}

void MegaboxScreen::showMovieInfo() {
  cout<< "--------------------------" << endl;
  cout<< "[" << this->strMovieName << "]" << endl;
  cout<< "--------------------------" << endl;
  cout << "영화관 : 메가박스 영화 3관" << endl;
  cout << "주인공 : 매투 맥커니히, 엔해서웨이" << endl;
  cout << "줄거리 : 세계 각국의 정부와 경제가 완전히 붕괴된 미래가 다가간다..." << endl;
  cout << "가격 : " << this->nTicketPrice << endl << endl;
}
