#include <iostream>
using namespace std;

class Beverage {
public:
  char * name = nullptr;
  int volume;
  Beverage(int volume): volume(volume) { }
  Beverage(Beverage &other) {
    volume = other.volume;
    setName(other.name);
  }
  Beverage(const char *name, int volume = 100) {
    setName(name);
    this->volume = volume;
  }
  void setName(const char *name) {
    if (this->name != nullptr) {
      delete [] this->name;
    }
    unsigned long length = strlen(name);
    this->name = new char[length];
    strcpy(this->name, name);
  }
  ~Beverage() {
    if (this->name != nullptr) {
      delete [] this->name;
    }
  }
};

int main() {
  Beverage cola("cola");
  Beverage coffee = cola; // 복사 생성자 호출
  return 0;
}

// 매개변수로 받은 음료와 똑같이 생긴 "새 음료수" 마시기
void drinkABeverage(Beverage beverage, int volume) {
  beverage.volume -= volume;
}

// 정확하게 "가르키고 있는 음료" 마시기
void drinkTheBeverage(Beverage *beverage, int volume) {
  beverage->volume -= volume;
}

// 음료 마시기
void drinkBeverage(Beverage &beverage, int volume) {
  beverage.volume -= volume;
}

void serveBeverage(Beverage drink) {
    // 함수 내에서 drink 객체 사용
}
Beverage createBeverage() {
    return Beverage("cola"); // 복사 생성자 호출 (임시 객체가 반환될 때)
}
int main() {
    Beverage cola("cola");
    serveBeverage(cola); // 복사 생성자 호출
    return 0;
}
