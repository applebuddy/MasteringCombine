//
//  Webservice.swift
//  HackerNews
//
//  Created by MinKyeongTae on 2022/09/29.
//

import Foundation
import Combine

class Webservice {
  
  func getStoryById(storyId: Int) -> AnyPublisher<Story, Error> {
    guard let url = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(storyId).json?print=pretty") else {
      fatalError("Invalid URL")
    }
    return URLSession.shared.dataTaskPublisher(for: url)
      .map(\.data)
      .decode(type: Story.self, decoder: JSONDecoder())
//      .catch { _ in Empty<Story, Error>() } // error 발생 시 Empty publisher를 반환
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }
  
  private func mergeStories(ids storyIds: [Int]) -> AnyPublisher<Story, Error> {
    let storyIds = Array(storyIds.prefix(50)) // storyIds의 앞에서 50개의 storyId가 담긴 배열
    let initialPublisher = getStoryById(storyId: storyIds[0]) // 첫번째 storyId에 대한 AnyPublisher<Story, Error>
    let remainder = Array(storyIds.dropFirst()) // 첫번재 id를 제외한 storyIds Array
    // 첫번째 id에 대한 데이터를 요청하는 AnyPublisher부터 해서 다른 id에 대한 AnyPublisher까지 merge를 진행한다.
    // merge는 merge된 publisher에 대한 이벤트들을 시간순으로 동작할때 사용할 수 있다.
    return remainder.reduce(initialPublisher) { combined, id in
      // 첫번째 Story Output을 시작으로, ~50번째까지의 Story를 시간순으로 처리하여 시퀀스 방출, 이를 eraseToAnyPublisher로 타입을 숨겨서 반환
      return combined
        .merge(with: getStoryById(storyId: id))
        .eraseToAnyPublisher()
    }
  }
  
  // 모든 id들에 대한 Story 데이터 요청 Publisher를 반환하는 mergeStories 메서드를 활용해서 AnyPublisher<[Int], Error> 가 아닌, AnyPublisher<[Story], Error>로 방출이 가능하다.
  func getAllTopStories() -> AnyPublisher<[Story], Error> {
    guard let url = URL(string: "https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty") else {
      fatalError("Invalid URL")
    }
    
    return URLSession.shared.dataTaskPublisher(for: url)
      .map(\.data)
      .decode(type: [Int].self, decoder: JSONDecoder())
      .flatMap { storyIds in
        return self.mergeStories(ids: storyIds)
      }.scan([]) { stories, story -> [Story] in  // scan을 통해, ids에 대한 Story 데이터가 처리되어 누적될때마다, 이벤트를 방출할 수 있다.
        return stories + [story] // View에 보여지는 stories데이터에 flatMap을 통해 처리되는 story를 누적
      }
      .receive(on: RunLoop.main) // receive(on:)은 down stream에 한하여 지정된 thread의 동작을 보장한다.
      .eraseToAnyPublisher()
  }
}
