//: A UIKit based Playground for presenting user interface
  
import UIKit
import Combine

let ptSubject = PassthroughSubject<Int, Error>()
let ptSubject2 = PassthroughSubject<Int, Error>()
let cvSubject = CurrentValueSubject<Int, Error>(3)
let cvSubject2 = CurrentValueSubject<Int, Error>(5)

var cancellables = Set<AnyCancellable>()
Just(2) // -> Just<Int>
  .map { value in
    value * 2
  }
  .subscribe(on: RunLoop.main)
  .map { value in
    value * 3
  }
  .receive(on: RunLoop.main)
  .eraseToAnyPublisher()
  .sink { completion in
    print(completion)
  } receiveValue: { value in
    print(value)
  }
  .store(in: &cancellables)
//  .store(in: &cancellables)

ptSubject.sink { completion in
  print(completion)
} receiveValue: { value in
  print("1 : \(value)")
}
  .store(in: &cancellables)

ptSubject2.sink { completion in
  print(completion)
} receiveValue: { value in
  print("2 : \(value)")
}
  .store(in: &cancellables)

// MARK: CombineLatest, 각 publisher의 가장 최신 이벤트가 있을 경우 쌍으로 방출
/*
let combineLatestPublisher = Publishers.CombineLatest(ptSubject, ptSubject2)
  .map { ($0.0, $0.1) }
  .eraseToAnyPublisher()
combineLatestPublisher.sink { completion in
  print(completion)
} receiveValue: { value in
  print(value)
}
  .store(in: &cancellables)
 */

/*
Publishers.Concatenate(prefix: ptSubject, suffix: ptSubject2)
  .sink { completion in
    print(completion)
  } receiveValue: { value in
    print(value)
  }
  .store(in: &cancellables)
 
 ptSubject.send(3) // 3 nil
 ptSubject2.send(4) // 3 4 -> CombineLatest event occur
 ptSubject.send(5) // 5 4 -> CombineLatest event occur
 ptSubject2.send(6) // 5 6 -> CombineLatest event occur
 */
/*
Publishers.Concatenate(prefix: cvSubject, suffix: cvSubject2)
  .sink { completion in
    print(completion)
  } receiveValue: { value in
    print(value)
  }
  .store(in: &cancellables)
*/

// 모든 subject의 이벤트를 시간순으로 수신받는다.
// Merge Operator, 시간순으로 이벤트를 방출
/*
Publishers.Merge(cvSubject, cvSubject2)
  .sink { completion in
    print(completion)
  } receiveValue: { value in
    print("receiveValue : \(value)") // currentValueSubject -> 구독과 동시에 초기값을 수신한다.
  }
  .store(in: &cancellables)

cvSubject.send(30)
cvSubject.send(40)
cvSubject2.send(50)
cvSubject.send(60)
*/

// MARK: Zip Operator, 각 publisher 동일 순서 이벤트를 방출
/*
Publishers.Zip(cvSubject, cvSubject2)
  .sink { completion in
    print(completion)
  } receiveValue: { value in
    print("receiveValue : \(value)") // currentValueSubject -> 구독과 동시에 초기값을 수신한다.
  }
  .store(in: &cancellables)

cvSubject.zip(cvSubject2)
  .sink { completion in
    print(completion)
  } receiveValue: { value in
    print(value)
  }
  .store(in: &cancellables)

// 각 subject의 동일한 순서의 이벤트가 있을때 튜플 쌍으로 이벤트를 뿌린다.
cvSubject.send(30)
cvSubject.send(40)
cvSubject2.send(50)
cvSubject.send(60)
cvSubject2.send(80)
cvSubject2.send(100)
 */

// MARK: SwitchToLatest, Publisher를 방출하는 Publisher에 사용 가능, 최근 방출한 Publisher의 이벤트를 수신
/*
let pttSubject = PassthroughSubject<CurrentValueSubject<Int, Error>, Error>()
pttSubject.switchToLatest()
  .sink { completion in
    print("completion : \(completion)")
  } receiveValue: { value in
    print("switchToLatest : \(value)")
  }
  .store(in: &cancellables)

pttSubject.send(cvSubject) // switchToLatest -> CurrentValueSubject, cvSubject의 초기값 출력
cvSubject2.send(10)
cvSubject2.send(20)
pttSubject.send(cvSubject2) // switchToLatest -> CurrentValueSubject, cvSubject2의 초기값 출력
cvSubject.send(30)
cvSubject2.send(50) // switchToLatest -> CurrentValueSubject, cvSubject2가 방출한 이벤트를 수신, cvSubject2를 가장 최근에 방출했으니, cvSubject 이벤트를 방출한다.
*/

// sink, assign 등으로 Subscriber를 커스텀하게 만들필요 없다. 애플에서는 별도로 만드는것을 권장하지 않는다고 한다. 커스텀하게 만들수도 있긴 하다.

// MARK: Custom Subscriber
// Subscriber를 채택하여 Custom Subscriber를 정의할 수도 있다.
// Subscriber를 채택하고 그에 맞는 메서드를 구현해야하는데 대표적으로 subscription / value / completion을 받을때 3가지를 구현해야한다. 사황에 맞게 얼마나 구독값을 받을지 등의 demand값을 반환할 수 있다.
/*
let arrayPublisher = (0...6).publisher

class CustomSubscriber: Subscriber {
  
  // Publisher가 Output, Failure를 갖는데, Subscriber는 Input, Failure를 갖는다. 이타입을 typealias로 정의해줄 수 있다.
  typealias Input = Int
  typealias Failure = Never
  
  func receive(subscription: Subscription) {
    print("subscription received : \(subscription)")
  }
  
  func receive(_ input: Int) -> Subscribers.Demand {
    print("receive input value : \(input)")
    return .unlimited
  }
  
  func receive(completion: Subscribers.Completion<Never>) {
    print("completion : \(completion)")
  }
}

let subscriber = CustomSubscriber()

let currentValueSubject = CurrentValueSubject<Int, Never>(10)
//Just(1) // 콜드 옵저버블 중 하나, 구독과 동시에 값을 내려준다.
//  .subscribe(subscriber)
currentValueSubject
  .subscribe(subscriber) // Publisher의 Output, Failure -> Subscriber의 Input, Failure 타입이 각각 일치해야 구독이 가능하다.
arrayPublisher.subscribe(subscriber)
currentValueSubject.send(20)
currentValueSubject.send(30)

//subscriber.receive(completion: .finished)
*/

let arrayPublisher = (0...6).publisher

class CustomSubscriber: Subscriber {
  
  // Publisher가 Output, Failure를 갖는데, Subscriber는 Input, Failure를 갖는다. 이타입을 typealias로 정의해줄 수 있다.
  typealias Input = Int
  typealias Failure = Never
  
  func receive(subscription: Subscription) {
    print("subscription received : \(subscription)")
    subscription.request(.max(3))
  }
  
  func receive(_ input: Int) -> Subscribers.Demand {
    print("receive input value : \(input)")
    return .none
  }
  
  func receive(completion: Subscribers.Completion<Never>) {
    print("completion : \(completion)")
  }
}

let subscriber = CustomSubscriber()

let currentValueSubject = CurrentValueSubject<Int, Never>(10)
//Just(1) // 콜드 옵저버블 중 하나, 구독과 동시에 값을 내려준다.
//  .subscribe(subscriber)
// Publisher의 Output, Failure -> Subscriber의 Input, Failure 타입이 각각 일치해야 구독이 가능하다.
currentValueSubject
  .subscribe(subscriber) // currentValueSubject를 구독한 순간 첫 이벤트 발생
arrayPublisher.subscribe(subscriber) // 0, 1, 2 세개만 내려옴. 초기 구독셋팅해서 .max(3)으로 request 했기 때문
currentValueSubject.send(20) // currentValueSubject 두번째 이벤트
currentValueSubject.send(completion: .finished) // receive(completion: Subscribers.Completion<Never>) 호출
currentValueSubject.send(30) // currentValueSubject 세번째 이벤트까지는 받고 이후는 안받는다. .max(3)으로 reuqest했기 때문, 이전에 구독이 종료되면 이벤트 방출되지 않음
currentValueSubject.send(40) // x
currentValueSubject.send(50) // x
currentValueSubject.send(60) // x

//subscriber.receive(completion: .finished)
