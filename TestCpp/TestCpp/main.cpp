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

int main() {
  Artist* worker;
  Youtuber youtuber;
  DramaPD pd;
  
  int num = 0;
  cout << "누구한테 외주를 맞기겠습니까? \n 1: 유튜버, 2: 드라마 PD" << endl;
  cin >> num;
  
  if (num == 1) { worker = &youtuber; }
  else if (num == 2) { worker = &pd; }
  else { worker = nullptr; }
  worker->makeContent();
  
  return 0;
}


class Parent {
public:
    virtual ~Parent() {
      cout << "부모 소멸자" << endl;
    }
};

class Child : public Parent {
public:
    ~Child() override {
      cout << "자식 소멸자" << endl;
    }
};
