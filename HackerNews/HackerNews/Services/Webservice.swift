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
      .catch { _ in Empty<Story, Error>() } // error 발생 시 Empty publisher를 반환
      .eraseToAnyPublisher()
  }
  
  func getAllTopStories() -> AnyPublisher<[Int], Error> {
    guard let url = URL(string: "https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty") else {
      fatalError("Invalid URL")
    }
    
    return URLSession.shared.dataTaskPublisher(for: url)
      .map(\.data)
      .decode(type: [Int].self, decoder: JSONDecoder())
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }
}
