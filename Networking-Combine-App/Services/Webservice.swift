//
//  Webservice.swift
//  Networking-Combine-App
//
//  Created by Mohammad Azam on 10/18/19.
//  Copyright © 2019 Mohammad Azam. All rights reserved.
//

import Foundation
import Combine

class Webservice {

    func getPosts() -> AnyPublisher<[Post], Error> {
    
    guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
          fatalError("Invalid URL")
      }
      
      return URLSession.shared.dataTaskPublisher(for: url).map { $0.data }
      .decode(type: [Post].self, decoder: JSONDecoder())
      .receive(on: RunLoop.main) // UI를 다룰때에는 Main 스레드에서 동작해야하므로, 이를 보장하기 위해 메인 스레드에서 동작하도록 한다.
      .eraseToAnyPublisher()
        
    }
    
}
