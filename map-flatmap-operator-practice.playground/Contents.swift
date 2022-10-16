
// MARK: map, flatMap operator review

import UIKit
import Combine

var anyCancellable: AnyCancellable?

struct Student  {
  var score: CurrentValueSubject<Int, Never>
}

var cancellables = Set<AnyCancellable>()
let john = Student(score: CurrentValueSubject<Int, Never>(75))
let mary = Student(score: CurrentValueSubject<Int, Never>(90))
let stdSubjectWithMap = PassthroughSubject<Student, Never>()
let stdSubjectWithFlatMap = PassthroughSubject<Student, Never>()

stdSubjectWithMap // PublishSubject<Student, Never>
  .eraseToAnyPublisher() // AnyPublisher<Student, Never>
  .map { $0.score.eraseToAnyPublisher() } //  -> 구독해서 사용하기 난해해짐... AnyPublisher<Int, Never>의 AnyPublisher타입이 되기 때문...
  .sink { anyPublisher in // 구독을 하면 Int값이 아닌 AnyPublisher<Int, Never> 타입을 받게 됨...
    print("anyPublisher ㅠㅠ : \(anyPublisher)")
  }
  .store(in: &cancellables)

// score 값이 출력되지 않음
stdSubjectWithMap.send(john)
stdSubjectWithMap.send(mary)
john.score.send(99)

stdSubjectWithFlatMap // PassthroughSubject<Student, Never>
  .eraseToAnyPublisher() // AnyPublisher<Student, Never>
  .flatMap {
    $0.score.eraseToAnyPublisher()
  } // AnyPublisher<Int> 타입이 되어 down stream에서 Int 값을 수신 가능함.
  .sink { score in // flatMap을 사용하면 score값을 온전히 사용 가능함.
    print("store : \(score)")
  }
  .store(in: &cancellables)
// 각 subject들에서 이벤트를 방출할때 score 값을 정상적으로 수신할 수 있음
stdSubjectWithFlatMap.send(john)
stdSubjectWithFlatMap.send(mary)
john.score.send(50)
