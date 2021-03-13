double __x0;
#include <stdio.h>
#include <stdlib.h>
#include <stdio.h>

void foo(double x){
  if (x>100){
    abort();
  }
  return;
}
int main(){
  int __passed=scanf ("%lf",&__x0);
if (__passed!=1) return 2;

  double x=__x0;
  foo(x);
  return 0;
}
//Expect variables no.  counted in two rounds are equal: 1 == 1
