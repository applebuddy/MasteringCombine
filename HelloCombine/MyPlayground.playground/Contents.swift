import UIKit
import Combine

// MARK: 34 ~ 35. Challenge: Filter all the things with solution
/*
Challenge: Filter all the things

Create an example that publishes a collection of numbers from 1 through 100, and use filtering operators to:

1. Skip the first 50 values emitted by the upstream publisher.
2. Task the next 20 values after those first 50 values.
3. Only task even numbers.

The output of your example should produce the follwing numbers, one per line:
*/

let publisher = (1...100).publisher
publisher
  .dropFirst(50) // or, drop(while: { $0 <= 50 }), 1) 처음 50개의 이벤트는 무시합니다.
  .prefix(20) // 50개 이벤트 버린 후, 처음 20개의 이벤트는 방출합니다.
  .filter({ $0 & 1 == 0 }) // 방출하는 20개 이벤트 중, 짝수만 방출합니다.
  .sink(receiveValue: {
    print($0)
  })

// MARK: 33. prefix(_:), prefix(while:) operator
// 1) prefix operator는 Sequence의 첫번째부터 N개의 이벤트만 방출하도록 할때 사용합니다.
// 2) prefix(while:) operator는 특정 조건을 충족하지 않는 이벤트가 나오기 전까지의 prefix event를 방출합니다.
/*
let numbers = (1...10).publisher
print("What is the prefix operator in Combine?")
numbers
  .prefix(3) // 1, 2, 3
  .sink { element in
    print(element)
  }

print("Next, Let's go to learn How to use prefix(while:) operator!")
numbers
  .prefix(while: { $0 % 3 != 0 })
  .sink {
    print($0)
  }
 */

// MARK: 32. dropUntilOutputFrom operator
// dropUntilOutputFrom operator는 특정 publisher(untilOutputFrom의 인자)로부터 이벤트를 받기 전까지 이벤트를 무시한다.
/*
let taps = PassthroughSubject<Int, Never>()
let isReady = PassthroughSubject<Void, Never>()
taps.drop(untilOutputFrom: isReady)
  .sink(receiveValue: {
    print($0)
  })

// isReady publisher가 이벤트 방출하기 전까지 taps subject의 이벤트는 무시됩니다.
// isReady subject(publisher)가 이벤트를 방출한 이후부터 tap subject의 이벤트가 방출됩니다.
(1...10).forEach { n in
  if n == 6 { isReady.send(()) }
  taps.send(n) // isReady가 이벤트를 방출한 이후부터 tap subject(publisher)는 이벤트를 방출합니다.
}
 */

// MARK: 31. dropWhile operator
// dropWhile은 Sequence에서 특정 조건을 충족하는 동안은 이벤트를 무시하고 조건에 부합되지 않는 이벤트부터 이벤트를 방출한다.
/*
let numbers = (1...10).publisher
numbers.drop(while: { $0 != 3 }) // 1, 2는 3이 아니므로 무시되며, 3부터 이후의 이벤트가 방출된다.
  .sink {
    print($0)
  }
*/

// MARK: 30. dropFirst operator
// dropFirst는 Sequence에서 최초 N개의 이벤트를 무시하고자할때 사용가능하다.
/*
let numbers = (1...10).publisher
numbers.dropFirst(5)
  .sink {
    print($0) // 5개 이벤트를 무시하고 6 ~ 10 의 값이 방출된다.
  }
 */

// MARK: 28. first operator
// first operator는 Sequence의 첫번째 혹은 특정 조건에 맞는 첫번째 값을 방출할때 사용할 수 있습니다.
// MARK: 29. last operator
// last operator는 Sequence의 마지막 혹은 특정 조건에 맞는 마지막 값을 방출할때 사용할 수 있습니다.
/*
let numbers = (1...9).publisher

numbers.first(where: { $0 % 2 == 0 }) // 짝수인 첫번째 값을 방출
  .sink {
    print($0) // 2 (sequence publisher의 첫번째 홀수 값
  }

numbers.last(where: { $0 % 2 == 1 }) // 홀수인 마지막 값을 방출
  .sink {
    print($0) // 9 (sequence publisher의 마지막 홀수 값)
  }
 */

// MARK: 27. ignoreOutput operator
// ignoreOutput operator는 completion event만 받고 그 이외의 이벤트는 무시하고자 할 때 사용 가능합니다.
/*
let numbers = (1...5000).publisher
numbers
  .ignoreOutput() // ignoreOutput operator를 사용하면 completion 이벤트만 받고 이외의 이벤트는 무시합니다.
  .sink {
  print($0) // finished Completion만 전달 받습니다.
} receiveValue: {
  print($0) // 1...5000의 값은 출력되지 않습니다.
}
*/

// MARK: 26. compactMap operator
// compactMap operator는 map과 유사한 동작을 하지만 연산 결과가 non-optional인 값만 모아서 Sequence로 반환하는 차이점이 있다. 즉, compactMap operator는 non-optional Sequence로 반환한다.
/*
let strings = ["a", "1.24", "b", "3.45", "6.7"]
  .publisher.compactMap { Float($0) }
  .sink {
    print($0)
  }
 */

// MARK: 25. removeDuplicates operator
// removeDuplicates operator를 사용하면 Sequence의 중복값을 제거한 Sequence로 반환받을 수 있다.
// removeDuplicates를 사용할때 모든 중복값이 제거되는 것은 아니다. Sequence에서 연속된 중복값만 한하여 무시하여 필터링한다.
// 중복 문자열이 있는 배열에 대한 publisher를 선언한다.
/*
let words = "apple apple fruit apple mango watermelon apple".components(separatedBy: " ").publisher
  .removeDuplicates()
words.sink {
  print($0)
}
 */

// MARK: - Section 4. Filtering Operators
// MARK: 24. filter operator
/*
// RxSwift의 filter와 동일하다. 기존 Sequence를 특정 조건을 충족하는 값만 있는 Sequence로 반환한다.
let numbers = (1...20).publisher
numbers.filter { $0 % 2 == 0 }.sink(receiveValue: {
  print($0) // (1...20) 값들 중 짝수값만 출력된디ㅏ.
})
 */

// MARK: 23. scan operator
// RxSwift의 scan와 이름이 동일하고 기능도 유사한 operator로 Sequence의 연산 결과를 모두 반환한다.
/*
let publisher = (1...10).publisher
publisher.scan([]) { numbers, value -> [Int] in
// numbers: [Int]에 연산이 누적된다., value: Int 는 publisher의 각각의 element
  return numbers + [value] // publisher 값을 순차적으로 append 하고 있다.
}.sink { scanValue in
  print(scanValue) // scan operator의 appending 연산 과정이 모두 출력된다.
}
 */

// MARK: 22. replaceEmpty operator
// Empty<Int, Never> Publisher는 어떠한 값을 방출하지 않으며, 에러또한 방출하지 않습니다.
/*
let empty = Empty<Int, Never>()
//let cancellable = [1, 2, 3, 4, 5].publisher.sink { print($0) }
//cancellable.cancel()

empty
  .replaceEmpty(with: 1) // replaceEmpty operator를 통해 Empty Publisher의 값을 특정 값으로 바꾸어 구독자에게 전달 가능
  .sink(receiveCompletion: {
  print($0) // 1, finiished
}, receiveValue: {
  print($0)
})
*/

// MARK: 19. replaceNil operator
// replaceNil : publiser sequence에 nil이 있을 경우 nil을 특정 값으로 변환한 sequence를 반환합니다.
// MARK: 20. Challenge - Unwrapping the Optional Values Received from replaceNil
// Q. replaceNil이 반환하는 [String?] 타입 대신 [String] 타입이 내려오게 하는 방법은?
// 1) map { $0! } 을 사용하여 언래핑을 할 수 있다. 강제 옵셔널 언래핑은 안전하지 않은 방법이다. 하지만 replaceNiil을 통해 nil인 값을 다른 값으로 바꾸었기 때문에 정상적으로 언래핑 후 값이 출력된다.
/*
["A", "B", nil, "C"].publisher.replaceNil(with: "x")
  .map { $0! }
  .sink {
    print($0)
  }
*/

// MARK: 18. flatMap operator
// flatMap operator는 많은 transformation operator들 중 중요한 operator 중 하나입니다.
// flatMap operator를 사용하면 다수의 업 스트림 publisher들을 하나의 downstream publisher로 변환할 수 있습니다.
/*
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
 
 */

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
