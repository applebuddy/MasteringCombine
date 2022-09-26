//
//  PostListTableViewController.swift
//  Networking-Combine-App
//
//  Created by Mohammad Azam on 10/18/19.
//  Copyright © 2019 Mohammad Azam. All rights reserved.
//

// MARK: 52. Displaying posts on a TableView

import UIKit
import Combine

class PostListTableViewController: UITableViewController {
  
  private var webService = Webservice()
  /// viewController가 살아있는 동안 구독을 유지하는데 사용한다.
  private var cancellable: AnyCancellable?
  private var posts: [Post] = [] {
    didSet {
      self.tableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // 한번 호출된 이후에도 메모리에서 유지될 수 있도록 값을 할당해준다.
    // 1) assign 을 통한 tableView 업데이트
    /*
    self.cancellable = self.webService.getPosts()
      .catch { _ in Just([Post]()) } // 에러 발생 시, 빈 배열을 반환합니다.
      .assign(to: \.posts, on: self) // KeyPath를 통해 UIViewController 특정 멤버 프로퍼티에 이벤트 값을 적용할 수 있다.
     */
    
    // 2) sink를 사용한 tableView 업데이트
    self.cancellable = self.webService.getPosts()
      .catch { _ in Just([Post]()) }
      .sink(receiveCompletion: { _ in
        print("completed")
      }, receiveValue: { [weak self] posts in
        self?.posts = posts
      })
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.posts.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath)
    
    let post = self.posts[indexPath.row]
    cell.textLabel?.text = post.title
    
    return cell
  }
  
}
