# MasteringCombine
Study for Udemy lecture; The Complete Guide to Combine Framework in iOS Using Swift
* Lecture URL (udemy) : https://www.udemy.com/course/the-complete-guide-to-combine-framework-in-ios-using-swift/

<div>

<image width="500" src="https://user-images.githubusercontent.com/4410021/193034681-ea6d1539-ceb0-4cfb-9857-8d0eb58bdc84.jpeg">

</div>



## Lecture 5. What is functional Programming?

- 기존 명령형 프로그래밍에서는 변수를 지정하고 그 변수의 상태를 바꾸기 위해 별도 위치에서 다른 값을 할당하는 등의 동작이 필요하다.
- Imparative(명령형) 프로그래밍과 달리, functional(함수형) 프로그래밍은 상태가 바뀌는 값이 immutable하게 구성될 수 있다.
  - 함수형 프로그래밍은 race condition, dead lock등의 문제점을 해소할 수 있다.
  - 사용되는 고차함수들은 특정 입력에 대해서 동일한 결과값을 내놓으므로, 사이드 이펙트를 줄일 수 있다.



## Lecture 6. What is Combine Framework?

- Combine framework는 비동기 이벤트를 처리하는 reactive framework입니다.



## Lecture 8. Hello Publishers and Subscribers

- Combine에는 subject, subscriber, publisher가 존재합니다.
- Subscriber가 Publisher를 구독하면, Publisher는 데이터 이벤트를 Subscriber에게 전달합니다.
  - Publisher -----> Stream of Data  ----->  Subscriber
  - 구독 시 Publisher는 Subscriber에게 subscription을 전달한다. 이때 Subscriber는 얼마나 이벤트를 받을지 요청할 수 있다.
  - Publisher는 요청받은 만큼의 이벤트를 Subscriber에게 전달한다. Subscriber는 이벤트 값을 받으면 이에 맞는 request를 하거나 그냥 받기만 할 수 있다.
  - 구독이 종료되면, Subscriber는 completion 이벤트를 받는다.

## Lecture 9. Sending Notifications Using Publisher and Subscriber

- Combine의 Publisher는 구독(sink)이 가능하다. 클로져를 통해 구독한 Publisher의 이벤트를 수신 받을 수 있다.
  - Combine의 Publisher는 RxSwift의 Observable와 유사, (둘 다 Subject, Subscriber(RxSwift Observer)를 가짐)
- sink는 AnyCancellable 타입을 반환한다. RxSwift의 subscribe가 Disposable을 반환하는 것과 유사하다.
- RxSwift, Combine의 구독 예시

~~~swift
let disposable = NotificationCenter.default.rx.notification(notification)
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { _ in
        print("RxSwift Notification received")
      }).disposed(by: disposeBag)

let publisher = NotificationCenter.default.publisher(for: notification, object: nil)
let subscription = publisher.sink { _ in
  print("Combine Notification received")
}

// 구독이 시작되면, 구독 해지 이전까지 Publisher의 이벤트를 받을 수 있다.
NotificationCenter.default.post(name: notification, object: nil)
~~~



## Lecture 10. Understanding Cancellable

- New Paper를 예로 들어보자. 구독을 하다가 취소를 해야 신문을 그만 볼 수 있다.
- 구독 취소 후의 Observable, Publisher 이벤트는 받을 수 없다.
- 구독 해지를 할때 구독을 통해 반환받은 AnyCancellable을 갖고 있다가 중간에 nil을 할당하거나, 사용 영역 생애주기가 끝나면 자동으로 해제된다. (Cancellable은 cancel()로 해제해주어야 함), 혹은 store에 Set<AnyCancellable> 인스턴스를 넣어서 구독정보 관리가 가능하다.



## Lecture 11. Subscriber

- Publisher의 이벤트를 감지하기 위해서는 구독이 필요했다. 그 구독을 하는 것이 Subscriber이다. Subscriber는 Input, Failure 제네릭타입을 갖고 있는데, Publisher의 Output과 Subscriber의 Input이, 양쪽의 Failure가 일치해야 구독을 할 수 있다.
- Publisher와 Subscriber의 구독 후 상호관계 feat. Subscriber 프로토콜을 채택한 StringSubscriber 생성

~~~swift
class StringSubscriber: Subscriber {
  // Publisher            Subscriber 의 상호 관계
  // <-------- subscribes
  //         gives subscription -->
  // <-------- requests values
  //         sends values -------->
  //         sends completion ---->
  
  // subscribe 이후, publisher로부터 subscription을 수신했을때 호출 됩니다.
  func receive(subscription: Subscription) {
    print("Received Subscription")
    subscription.request(.max(3)) // publiser야 최대 3개의 값만 줘봐
  }
  
  // publisher로부터 input 값을 수신했을때 호출됩니다.
  func receive(_ input: String) -> Subscribers.Demand {
    print("Received value : \(input)")
    return .none // publisher한테 더이상 받을 것 없어
//    return .unlimited // 줄 수 있는거 다 받을래
  }
  
  // publisher가 publish 이벤트를 마쳤을때 호출 됩니다.
  func receive(completion: Subscribers.Completion<Never>) {
    print("Completed")
  }

  typealias Input = String
  typealias Failure = Never // Failure를 Never로 지정하면 fail이 발생하지 않습니다.
}

~~~

- Custom Subscriber로 Publisher 구독 후 사용하기

~~~swift
let publisher = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K"].publisher
let subscriber = StringSubscriber()
publisher.subscribe(subscriber)
// 출력 결과 
// -> .max(3)으로 request를 했으므로 "A", "B", "C" 세개의 이벤트를 받습니다.
// * unlimited로 input을 받는 경우, 모든 이벤트를 받습니다.
// * 요청하고 싶지 않으면 .none을 반환하면 됩니다.
/*
Received Subscription
Received value : A
Received value : B
Received value : C
 */
~~~



## Lecture 12. Subjects

- Subject는 이벤트를 방출할 수 있는 Publisher면서 구독이 가능한 Subscriber입니다.
  - RxSwift의 Subject는 이벤트를 방출할 수 있는 Observable이면서 구독이 가능한 Observer입니다.

~~~swift
let subscriber = StringSubscriber()
let subject = PassThroughSubject<String, MyError>()
// Subject는 Publisher처럼 구독이 가능합니다. 즉, Subscriber가 구독하여 이벤트를 받을 수 있으며, Subject에서 원할 때 이벤트를 Subscriber로 보낼 수 있습니다.

// 1) Subscriber는 Subject를 구독할 수 있습니다.
subject.subscribe(subscriber)

// 2) Subject는 Publisher로서 이벤트를 방출할 수도 있습니다.
let subscription = subject.sink { completion in 
	print("Received Completion from sink")
} receiveValue: { value in
  print("Received Value from sink, value: \(value)")
}

subject.send("A") // Received value : A
subject.send("B") // Received value : B
subject.send("C") // .max(2)로 request를 했을 경우, 세번째 이벤트인 C는 방출되지 않습니다. input을 받을때 .none 대신 .max(1)을 반환하면 이벤트를 추가로 받을 수 있다.
subject.send("B")

subscription.cancel()

subject.send("ㅜㅜ") // 구독이 취소되면 이후 이벤트는 방출되지 않아요.
subject.send("ㅠㅠ")
~~~



## Lecture  13. Type Eraser (eraseToPublisher)

- 사용한 Publisher 연산 결과의 타입을 가리고 싶을때 Type Eraser로서 eraseToPublisher를 사용할 수 있다.
- eraseToAnyPublisher를 사용하면 AnyPublisher타입으로 바뀐다. (기존 Publisher 결과타입을 래핑한다.)
- 다양한 operator를 가져가는 경우 타입이 매우 복잡해지고, 파이프라인이 모두 외부에 노출되는 문제가 있다.
  - 이때 eraseToAnyPublisher를 사용하면 기존의 데이터 스트림과 상관없이 최종적인 형태의 Publisher를 반환한다. 최종적으로 받게 되는 데이터를 전달하는 목적으로만 타입을 변환하여 사용할 수 있다.

~~~swift
let publisher = PassthroughSubject<Int, Never>() // PassthroughSubject<Int, Never>
  .map { $0 } // Publisher.Map<PassthroughSubject<Int, Never>, Int>
  .eraseToAnyPublisher()
// => AnyPublisher<Int, Publishers.Map<PassthroughSubject<Int, Never>, Int>.Failure>
~~~



# Operators

## Lecture 14. Understandinig Transforming operators

- 기존 Sequence를 각각의 element에 대해 특정 연산을 적용한 새로운 Sequence로 변환시킨다.

~~~swift
// ex) [1, 2, 3] -> ["1", "2", "3"]
// 필요에 따라 사용가능한 다양한 Transformation Operator가 존재한다.
~~~



## 15. Collect operator

- collect operator는 방출할 모든 이벤트를 하나로 모아놓은 Array로 반환한다.
- collect N : Int 인자를 넣으면 N개 단위로 나누어서 Array를 반환한다.

~~~swift
let anyCancellable = ["A", "B", "C", "D"].publisher.collect(3)
	.sink { element in 
	print(element)
}

anyCancellable.cancel()
~~~



## map operator

~~~swift
// MARK: 16. map operator
// ex) [100, 23] -> ["one hundred and twenty three"]로 변환하는 방법?

let formatter = NumberFormatter()
formatter.numberStyle = .spellOut

[213, 45, 67].publisher.map {
  // map operator를 통해 Sequence에 있는 각각의 elements를 특정 연산하여 또다른 Sequence를 반환할 수 있다.
  formatter.string(from: NSNumber(integerLiteral: $0))
}.sink { element in
  print(element)
}
~~~



## map with keyPath

~~~swift
// MARK: 17. map KeyPath
// map operator에서 KeyPath를 사용하여 structure의 개별 값들을 접근하여 다룰 수 있습니다.

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
~~~



## replaceNil operator

- publisher sequence에 nil이 있을 경우 nil을 특정 값으로 변환한 sequence를 반환합니다.

~~~swift
// MARK: 19. replaceNil operator
// replaceNil : publiser sequence에 nil이 있을 경우 nil을 특정 값으로 변환한 sequence를 반환합니다.
// MARK: 20. Challenge - Unwrapping the Optional Values Received from replaceNil
// Q. replaceNil이 반환하는 [String?] 타입 대신 [String] 타입이 내려오게 하는 방법은?
// 1) map { $0! } 을 사용하여 언래핑을 할 수 있다. 강제 옵셔널 언래핑은 안전하지 않은 방법이다. 하지만 replaceNiil을 통해 nil인 값을 다른 값으로 바꾸었기 때문에 정상적으로 언래핑 됨. (그냥 아니면 compactMap 쓰면 됨)
["A", "B", nil, "C"].publisher.replaceNil(with: "x")
	.map { %0! }
  .sink {
    print($0)
  }
~~~



## replaceEmpty operator

~~~swift
// MARK: 22. replaceEmpty operator
// Empty<Int, Never> Publisher는 어떠한 값을 방출하지 않으며, 에러또한 방출하지 않습니다.
let empty = Empty<Int, Never>()
//let cancellable = [1, 2, 3, 4, 5].publisher.sink { print($0) }
//cancellable.cancel()

empty
  .replaceEmpty(with: 1) // replaceEmpty operator를 통해 Empty Publisher의 값을 특정 값으로 바꾸어 구독자에게 전달 가능
  .sink(receiveCompletion: {
  print($0) // 1, finished
}, receiveValue: {
  print($0)
})
~~~



## scan operator

~~~swift
// MARK: 23. scan operator
// RxSwift의 scan와 이름이 동일하고 기능도 유사한 operator로 Sequence의 연산 결과를 모두 반환한다.
let publisher = (1...10).publisher
publisher.scan([]) { numbers, value -> [Int] in
// numbers: [Int]에 연산이 누적된다., value: Int 는 publisher의 각각의 element
  return numbers + [value] // publisher 값을 순차적으로 append 하고 있다.
}.sink { scanValue in
  print(scanValue) // scan operator의 appending 연산 과정이 모두 출력된다.
}
~~~



## filter operator

~~~swift
// MARK: - Section 4. Filtering Operators
// MARK: 24. filter operator
// RxSwift의 filter와 동일하다. 기존 Sequence를 특정 조건을 충족하는 값만 있는 Sequence로 반환한다.
let numbers = (1...20).publisher
numbers.filter { $0 % 2 == 0 }.sink(receiveValue: {
  print($0) // (1...20) 값들 중 짝수값만 출력된다.
})
~~~



## removeDuplicates operator

~~~swift
// MARK: 25. removeDuplicates operator
// removeDuplicates operator를 사용하면 Sequence의 중복값을 제거한 Sequence로 반환받을 수 있다.
// removeDuplicates를 사용할때 모든 중복값이 제거되는 것은 아니다. Sequence에서 연속된 중복값만 한하여 무시하여 필터링한다.
// 중복 문자열이 있는 배열에 대한 publisher를 선언한다.
let words = "apple apple fruit apple mango watermelon apple".components(separatedBy: " ").publisher
  .removeDuplicates()
words.sink {
  print($0)
}
~~~





## 🐵 operator exercise

~~~swift
let publisher = [1, 1, 1, 2, 2, 2, 3, 3, 3, 1, 1]
      .reduce(into: Set<Int>()) { result, value in // 중복 제거
        result.insert(value)
      }
      .sorted() // 중복 제거 후 오름차순 정렬
      .publisher // Publisher 변환 후 구독 진행
      .sink { value in
        print(value) // 1, 2, 3 수신
      }
~~~



## compactMap operator

- compactMap operator는 map과 유사한 동작을 하지만 연산 결과가 non-optional인 값만 모아서  Sequence로 변환하는 차이점이 있다. 즉, compactMap operator는  non-optional Sequence만 반환한다.

~~~swift
let strings = ["a", "1.24", "b", "3.45", "6.7"]
  .publisher.compactMap { Float($0) }
  .sink {
    print($0)
  }
~~~



## ignoreOutput operator

- ignoreOutput operator는  completiion event만 받고 그 이외의 이벤트는 무시하고자 할 때 사용 가능합니다.

~~~swift
let numbers = (1...5000).publisher
numbers
  .ignoreOutput() // ignoreOutput operator를 사용하면 completion 이벤트만 받고 이외의 이벤트는 무시합니다.
  .sink {
  print($0) // finished Completion만 전달 받습니다.
} receiveValue: {
  print($0) // 1...5000의 값은 출력되지 않습니다.
}
~~~



## first, last operator

- first operator는 Sequence의 첫번째 혹은 특정 조건에 맞는 첫번째 값을 방출할때 사용할 수 있습니다.
- last operator는 Sequence의 마지막 혹은 특정 조건에 맞는 마지막 값을 방출할때 사용할 수 있습니다.

~~~swift
// MARK: 28. first operator
// first operator는 Sequence의 첫번째 혹은 특정 조건에 맞는 첫번째 값을 방출할때 사용할 수 있습니다.
// MARK: 29. last operator
// last operator는 Sequence의 마지막 혹은 특정 조건에 맞는 마지막 값을 방출할때 사용할 수 있습니다.
let numbers = (1...9).publisher

numbers.first(where: { $0 % 2 == 0 }) // 짝수인 첫번째 값을 방출
  .sink {
    print($0) // 2 (sequence publisher의 첫번째 홀수 값
  }

numbers.last(where: { $0 % 2 == 1 }) // 홀수인 마지막 값을 방출
  .sink {
    print($0) // 9 (sequence publisher의 마지막 홀수 값)
  }
~~~



## dropFirst / dropWhile / dropUntilOutputFrom operator

- dropFirst는 Sequence에서 최초 N개의 이벤트를 무시하고자 할때 사용할 수 있다.
- dropWhile은 특정 조건을 충족하는 동안 이벤트를 무시하고자 할때 사용한다.
- dropUntilOutputFrom은 trigger용 Subject로부터 이벤트를 받기 전까지 이벤트를 무시할 수 있다.

~~~swift
// MARK: 30. dropFirst operator
// dropFirst는 Sequence에서 최초 N개의 이벤트를 무시하고자할때 사용가능하다.
let numbers = (1...10).publisher
numbers.dropFirst(5)
	.sink {
    print($0)
  }

// MARK: 31. dropWhile operator
// dropWhile은 Sequence에서 특정 조건을 충족하는 동안은 이벤트를 무시하고 조건에 부합되지 않는 이벤트부터 이벤트를 방출한다.
let numbers = (1...10).publisher
numbers.drop(while: { $0 != 3 }) // 1, 2는 3이 아니므로 무시, 3부터 이벤트가 방출
	.sink {
    print($0)
  }

// MARK: 32. dropUntilOutputFrom operator
// dropUntilOutputFrom operator는 특정 publisher(untilOutputFrom의 인자)로부터 이벤트를 받기 전까지 이벤트를 무시한다.
let taps = PassthroughSubject<Int, Never>() // 이벤트 구독 감지할 taps subject
let isReady = PassthroughSubject<Void, Never>() // trigger용 isReady subject
taps.drop(untilOutputFrom: isReady)
	.sink(receiveValue: {
    print($0)
  })
// isReady publisher가 이벤트를 방출하기 전까지 taps subject의 이벤트는 무시됩니다.
// isReady subject(publisher)가 이벤트를 방출한 이후부터 tap subject의 이벤트가 방출됩니다.
(1...10).forEach { n in
	if n == 6 { isReady.send(()) } // isReady subject에서 이벤트를 방출 하는 시점 부터 taps subject로부터 이벤트를 받음
	taps.send(n) // isReady가 이벤트를 방출한 이후부터 tap subject(publisher)는 이벤트를 방출, 구독 값 수신이 가능
}
~~~

