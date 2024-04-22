#include <iostream>
using namespace std;


class Beverage {
public:
  char * name = nullptr;
  int volume;
  Beverage(int volume): volume(volume) {};
  Beverage(const char *name, int volume = 100) {
    setName(name);
    this->volume = volume;
  }
  void setName(const char *name) {
    if (this->name != nullptr) {
      delete [] this->name;
    }
    auto length = strlen(name);
    this->name = new char[length];
    strcpy(this->name, name);
  };
  
  Beverage(Beverage const &other) {
    volume = other.volume;
    setName(other.name);
  }
  
  ~Beverage() {
    if(this-> name != nullptr) {
      delete [] this->name;
    };
  }
};



int main() {
  auto cola = Beverage("cola");
  cout << "cola Name:" << cola.name << endl;

  auto coffee = cola;
  coffee.setName("coffee");
  cout << "cola Name:" << cola.name << endl;
  cout << "coffee Name:" << coffee.name << endl;
  
  return 0;
}
