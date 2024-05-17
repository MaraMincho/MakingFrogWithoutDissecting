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
public: 
  void makeContent() const override { cout << "YoutubeContent" << endl; }
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


class Calculator {
public:
  virtual int add(int a, int b) = 0; // 두 정수의 합 리턴
  virtual int subtract(int a, int b) = 0; // 두 정수의 차 리턴
  virtual double average(int a [], int size) = 0; // 배열 a의 평균 리턴. size는 배열의 크기
};
#include <iostream>

template <class T>
T add(T data [], int n) { // 배열 data에서 n개의 원소를 합한 결과를 리턴
  T sum = 0;
  for(int i=0; i<n; i++) {
    sum += data[i];
  }
  return sum; // sum와 타입과 리턴 타입이 모두 T로 선언되어 있음
}

template<class T>
class MyOptional {
  T value;
public:
  MyOptional() : value(T()) {} // Default constructor initializing value to default constructed T
  MyOptional(T value) : value(value) {}
};

template <class T>
class MyStack {
  int tos; // Top of Stack
  T data[100];
public:
  
  MyStack();
  void push(T element);
  T pop();
  MyOptional<T> popOptional() {
    MyOptional<T> retData;
    if(tos == - 1) {
      cout << "stack Empty";
      return retData;
    }
    retData = MyOptional<T>(data[tos--]);
    return retData;
  }
};

template <class T>
MyStack<T>::MyStack() {
  tos = -1;
};



template <class T>
void MyStack<T>::push(T element) {
  if (tos == 99) {
    cout << "stack Full" << endl;
    return;
  }
  tos++;
  data[tos] = element;
}

template <class T>
T MyStack<T>::pop() {
  T retData;
  if(tos == - 1) {
    cout << "stack Empty" << endl;
    return 0;
  }
  retData = data[tos--];
  return retData;
}



int main() {
  MyStack<int> iStack;
  iStack.push(3);
  cout << iStack.pop() << endl;
  
  auto doubleStack = MyStack<double>();
  doubleStack.push(3.5);
  cout << doubleStack.pop() << endl;
  
  MyStack<char> *p = new MyStack<char>();
  p->push('a');
  cout << p->pop() << p->pop() << endl;
  delete p;
  
  auto ss = MyStack<Youtuber>();
  ss.push(Youtuber());
  MyOptional<Youtuber> popedValue = ss.popOptional();
}
