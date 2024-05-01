#include <iostream>
using namespace std;
class Power {
  int kick;
  
  int punch; 
public:
  Power(int kick=0, int punch=0) {
    this->kick = kick; this->punch = punch;
  } 
  void show(); // 프렌드 선언
  
  friend Power operator+(int op1, Power op2);
}; 
void Power::show() {
  cout << "kick=" << kick << ',' << "punch=" << punch << endl;
}
Power operator+(int op1, Power op2) {
  Power tmp; // 임시 객체 생성
  tmp.kick = op1 + op2.kick; //kick 더하기
  tmp.punch = op1 + op2.punch; //punch더하기
  return tmp; // 임시 객체 리턴
}

int main() {
  Power a(3,5), b;
  a.show();
  b.show();
  b = 2+a; // 파워 객체 더하기 연산
  a.show();
  b.show();
}
