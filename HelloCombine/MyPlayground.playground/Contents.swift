import UIKit

var greeting = "Hello, playground"
print(greeting)
// 기존 명령형 프로그래밍에서는 변수를 지정하고 그 변수의 상태를 바꾸기 위해서는 별도 위치에서 다른 값을 할당하는 등의 동작이 필요하다.
// Imparative(명령형) 프로그래밍과 달리, functional(함수형) 프로그래밍은 상태가 바뀌는 값이 immutable하게 구성될 수 있다.
// 1) 함수형 프로그래밍은 race condition, dead lock 등의 문제점을 해소할 수 있다.
// 2) 사용되는 고차항수들은 특정 입력에 대해서 동일한 결과값을 내놓으므로, 사이드 이펙트를 줄일 수 있다.
