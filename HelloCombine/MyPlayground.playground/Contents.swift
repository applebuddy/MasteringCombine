import UIKit
import Combine

// MARK: 18. flatMap operator
// flatMap operator는 많은 transformation operator들 중 중요한 operator 중 하나입니다.
// flatMap operator를 사용하면 다수의 업 스트림 publisher들을 하나의 downstream publisher로 변환할 수 있습니다.
struct School {
  let name: String
  let noOfStudents: CurrentValueSubject<Int, Never>
  
  init(name: String, noOfStudents: Int) {
    self.name = name
    self.noOfStudents = CurrentValueSubject(noOfStudents)
  }
}

let citySchool = School(name: "Fountain Head School", noOfStudents: 100)
let school = CurrentValueSubject<School, Never>(citySchool)
/*
school.sink {
  // 구독하면서 초기 School 값 수신
  print($0)
}
*/

let anyCancellable = school.flatMap {
  // flatMap으로 내부 Publication event들을 감지하고 수신할 수 있다.
  // noOfStudents CurrentValueSubject를 구독하여 이벤트를 받을 수 있다.
  $0.noOfStudents
}
.eraseToAnyPublisher()
.sink {
  print($0)
}


let townSchool = School(name: "Town School", noOfStudents: 101)
// citySchool.noOfStudents.value += 1 // noOfStudyents.value를 바꾸어도 이벤트가 방출되지 않음

school.value = townSchool // 구독한 school CurrentValueSubject의 value를 바꾸니 이벤트가 수신
// flatMap을 활용해서 noOfStudents CurrentValueSubject를 구독하여 값이 변화할때 이벤트를 받을 수 있게 되었다.
townSchool.noOfStudents.value = 0
townSchool.noOfStudents.value += 100
townSchool.noOfStudents.value -= 100

// MARK: 17. map KeyPath
// map operator에서 KeyPath를 사용하여 structure의 개별 값들을 접근하여 다룰 수 있습니다.
/*
struct Point {
  let x: Int
  let y: Int
}

let publisher = PassthroughSubject<Point, Never>()
publisher.map(\.x, \.y).sink(receiveValue: { x, y in
  print("x is \(x) and y is \(y)")
})

publisher.send(Point(x: 1, y: 2))
publisher.send(Point(x: 10, y: 20))
 */

// MARK: 16. map operator
// ex) [100, 23] -> ["one hundred and twenty three"]로 변환하는 방법?
/*
let formatter = NumberFormatter()
formatter.numberStyle = .spellOut

[213, 45, 67].publisher.map {
  // map operator를 통해 Sequence에 있는 각각의 elements를 특정 연산하여 또다른 Sequence를 반환할 수 있다.
  formatter.string(from: NSNumber(integerLiteral: $0))
}.sink { element in
  print(element)
}
*/

// MARK: 15. collect operator
// collect operator는 방출할 모든 이벤트를 하나로 모아놓은 Array로 반환한다.
// collect N: Int 인자를 넣으면 N개 단위로 나누어서 Array를 반환한다.
/*
let anyCancellable = ["A", "B", "C", "D"].publisher.collect(3)
  .sink { element in
    print(element)
  }

anyCancellable.cancel()
 */

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
