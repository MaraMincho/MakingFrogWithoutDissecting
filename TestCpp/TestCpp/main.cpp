#include <iostream>
#include <string>
using namespace std;

class Person {
protected:
  string name;
  int height;
  int weight;
};

class Artist : public Person {
public: virtual void makeContent() const = 0;
};

class Youtuber : public Artist {
public: void makeContent() const override { cout << "YoutubeContent" << endl; }
};

class DramaPD : public Artist {
public: void makeContent() const override { cout << "DramaContent" <<endl; };
};

//int main() {
//  Artist* worker;
//  Youtuber youtuber;
//  DramaPD pd;
//
//  int num = 0;
//  cout << "누구한테 외주를 맞기겠습니까? \n 1: 유튜버, 2: 드라마 PD" << endl;
//  cin >> num;
//
//  if (num == 1) { worker = &youtuber; }
//  else if (num == 2) { worker = &pd; }
//  else { worker = nullptr; }
//  worker->makeContent();
//
//  return 0;
//}
#include <iostream>

using namespace std;

class Calculator {
public: 
  virtual int add(int a, int b) = 0; // 두 정수의 합 리턴
  virtual int subtract(int a, int b) = 0; // 두 정수의 차 리턴
  virtual double average(int a [], int size) = 0; // 배열 a의 평균 리턴. size는 배열의 크기
};

#include <iostream>
using namespace std;
class GoodCalc : public Calculator {
  
public:
  int add(int a, int b) { return a + b; }
  
  int subtract(int a, int b) { return a - b; }
  
  double average(int a [], int size) {
    double sum = 0;
    for(int i=0; i<size; i++)
      sum += a[i];
    return sum/size;
  }
  
};

class Fluid {

public:
  virtual void isTakable() = 0;
  virtual ~Fluid() {
    cout << "Fluid was deinit" << endl;
  };
  double amount;
  bool isTakableProperty;
};

class Water: public Fluid {
public:
  virtual void isTakable() {
    this->isTakableProperty = true;
  }
  
};

class Cola: public Fluid {
public:
  virtual ~Cola() {
    cout << "deinit Cola" << endl;
  }
  virtual void isTakable() {
    cout << "not Takable" << endl;
  };
};
int main() {
  Cola thisCola;
  thisCola.isTakable();
}
