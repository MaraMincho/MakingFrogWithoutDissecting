#include <iostream>
#include <string> 
#include <map>
#include <random>
using namespace std;

int main() {
  vector<int> curStack;
  for(int i = 0; i < 5; i ++) {
    int curRanVal = random() % 10;
    int curVal = 0;
    for(int i = 0; i < curRanVal; i ++)
      curVal = random() % 100;
    cout << curVal << " ";
    curStack.push_back(curVal);
  }
  sort(curStack.begin(), curStack.end());
  
  int targetVal = 50;
  
  for_each(curStack.begin(), curStack.end(), [targetVal](int x) -> void {
    cout << "targetVal(" << x << ") is " << ((x < 50) ? "smaller" : "bigger") << " then 50" << endl;
  });
  
  int sum = 0;
  
  for_each(curStack.begin(), curStack.end(), [&sum](auto x) -> void {
    sum += x;
    return ;
  });
  
  cout << "썸은 ? : " <<sum << endl;
  
  for(auto cur: curStack) {
    cout << cur << " ";
  }
}
