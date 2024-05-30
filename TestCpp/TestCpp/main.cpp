#include <iostream>
using namespace std;

// baseexp 값을 계산하여 ret에 저장
bool getExp(int base, int exp, int &ret) {
  if(base <= 0 || exp <= 0) {
    return false;
  }
  int value=1;
  for(int n=0; n<exp; n++)
    value = value * base;
  
  ret = value;
  return true;
}
int main() {
  int v = 0;
  if(getExp(2, 3, v)) // v = 23 = 8. getExp()는 true 리턴
    cout << "2의 3승은 " << v << "입니다." << endl;
  else
    cout << " 오류. 2의 3승은 " << "계산할 수 없습니다." << endl;
  
  int e=0;
  if(getExp(2, -3, e)) // 2-3 ? getExp()는 false 리턴
    cout << "2의 -3승은 " << e << "입니다." << endl;
  else
    cout << "오류. 2의 -3승은 " << "계산할 수 없습니다." << endl;
}
