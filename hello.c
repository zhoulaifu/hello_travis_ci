#include <stdlib.h>
#include <stdio.h>

void foo(double x){
  if (x>100){
    abort();
  }
  return;
}
int main(){
  double x = 2.9e200;
  //x=3.5;
  foo(x);
  return 0;
}
