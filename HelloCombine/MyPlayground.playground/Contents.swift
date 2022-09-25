import UIKit
import Combine

// MARK: 15. collect operator
// collect operator는 방출할 모든 이벤트를 하나로 모아놓은 Array로 반환한다.
// collect N: Int 인자를 넣으면 N개 단위로 나누어서 Array를 반환한다.

let anyCancellable = ["A", "B", "C", "D"].publisher.collect(3)
  .sink { element in
    print(element)
  }

anyCancellable.cancel()

// MARK: - 14. Understanding Transforming Operators
// 기존 Sequence를 각각의 elemenet에 대하여 특정연산을 적용한 새로운 Sequence로 변환시킨다.
// ex) [1, 2, 3] -> ["1", "2", "3"]
// 필요에 따라 사용가능한 다양한 Transformation Operators가 존재한다.

// MARK: - 13. Type Eraser
// 사용한 Publisher의 타입을 가리고 싶을때가 있을 수 있다.
// eraseToAnyPublisher를 사용하면 AnyPublisher로 타입이 바뀐다. (기존 publisher 타입을 래핑한다.)
// 다양한 오퍼레이터를 거쳐가는 경우 타입이 매우 복잡해지고, 파이프라인이 모둔 외부에 노출되는 문제가 있다.
// -> eraseToAnyPublisher를 사용하면 기존의 데이터 스트림과 상관엇이 최종적인 형태의 Publisher를 반환한다. 최종적으로 받게 되는 데이터를 전달하는 목적으로만 타입을 변환하여 사용할 수 있다.
/*
let publisher = PassthroughSubject<Int, Never>() // PassthroughSubject<Int, Never>
  .map { $0 } // Publisher.Map<PassthroughSubject<Int, Never>, Int>
  .eraseToAnyPublisher()
// => AnyPublisher<Int, Publishers.Map<PassthroughSubject<Int, Never>, Int>.Failure>
 */

// MARK: - 8. Hello Publishers and Subscribers
// - Subscriber가 Publisher를 구독하면, Publisher는 데이터 이벤트를 Subscriber에게 전달합니다.
// Publisher ---- stream of data ----> Subscriber


// MARK: - 6. What is Combine Framework?
// combine framework는 비동기 이벤트를 처리하는 reactive framework입니다.

// MARK: - 5. What is Functional Programming
// 기존 명령형 프로그래밍에서는 변수를 지정하고 그 변수의 상태를 바꾸기 위해서는 별도 위치에서 다른 값을 할당하는 등의 동작이 필요하다.
// Imparative(명령형) 프로그래밍과 달리, functional(함수형) 프로그래밍은 상태가 바뀌는 값이 immutable하게 구성될 수 있다.
// 1) 함수형 프로그래밍은 race condition, dead lock 등의 문제점을 해소할 수 있다.
// 2) 사용되는 고차항수들은 특정 입력에 대해서 동일한 결과값을 내놓으므로, 사이드 이펙트를 줄일 수 있다.
