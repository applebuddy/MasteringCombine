//
//  Webservice.swift
//  HackerNews
//
//  Created by MinKyeongTae on 2022/09/29.
//

import Foundation
import Combine

class Webservice {
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
