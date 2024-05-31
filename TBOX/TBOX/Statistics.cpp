//
//  Statistics.cpp
//  TBOX
//
//  Created by MaraMincho on 5/31/24.
//

#include "Statistics.hpp"

int Statistics::totalRevenue(Screen *pScreen) {
  Ticket** tickets = pScreen->getTicketArray();
  int sumOfRevenue = 0;
  for (int row = 0; row < pScreen->getRowMax() ; row ++) {
    for (int col = 0; col < pScreen->getColMax(); col ++) {
      sumOfRevenue += (tickets[row][col].isChargeTicket()) ? tickets[row][col].getPayAmount() : 0;
    }
  }
  return sumOfRevenue;
};

int Statistics::totalSalesCount(Screen *pScreen) {
  Ticket** tickets = pScreen->getTicketArray();
  int sumOfRevenue = 0;
  for (int row = 0; row < pScreen->getRowMax() ; row ++) {
    for (int col = 0; col < pScreen->getColMax(); col ++) {
      sumOfRevenue += (tickets[row][col].isChargeTicket()) ? 1 : 0;
    }
  }
  return sumOfRevenue;
}
