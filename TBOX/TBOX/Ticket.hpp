//
//  Ticket.hpp
//  TBOX
//
//  Created by MaraMincho on 5/30/24.
//
#pragma once
#ifndef Ticket_hpp
#define Ticket_hpp

#define SEAT_EMPTY_MARK '-'
#define SEAT_RESERVED_MARK 'R'
#define SEAT_COMPLETION_MARK '$'
#define NOT_RESERVED_ID -1
class Ticket {
  int nRow; // 좌석 행
  int nCol; // 좌석 열
  char charCheck; // 예약 여부
  int nReservedID; // 예약 번호
  int nPayAmount; // 결제 금액
  int nPayMethod; // 결제 수단

public:
  Ticket() {}
  void setCheck(char check) { charCheck = check; }
  char getCheck() { return charCheck; }
  
  // 좌석 번호 저장
  void setSeat(int row, int col) { nRow = row; nCol = col; }
  // 좌석 예약 번호 저장
  void setReservedID(int reserved) { nReservedID = reserved; }
  int getReservedID() { return nReservedID; }
  
  void setPayAmount(int amount) { nPayAmount = amount; }
  int getPayAmount() { return nPayAmount;}
  void setPayMethod(int method) { nPayMethod = method; }
  
  int getRow() { return nRow; }
  int getCol() { return nCol; }
};


#endif /* Ticket_hpp */
