//
//  StoryListViewModel.swift
//  HackerNews
//
//  Created by MinKyeongTae on 2022/09/29.
//

import Foundation
import Combine

class StoryListViewModel: ObservableObject {
  @Published var stories = [StoryViewModel]()
  private var cancellable: AnyCancellable?
  
  init() {
    fetchTopStories()
  }
  
  private func fetchTopStories() {
    // getAllTopStories() 반환타입 변경으로 storyIds 대신 story를 처리하는 것으로 변경
    self.cancellable = Webservice().getAllTopStories().map { stories in
      // 생성자 인자가 단 하나이고, up stream에서 해당 생성자 인자를 제공하는 경우, 좌측처럼 생성자만 지정해서 맵핑 가능
      stories.map(StoryViewModel.init)
    }.sink(receiveCompletion: { _ in }) { storyViewModels in
      self.stories = storyViewModels
    }
  }
}

struct StoryViewModel {
  let story: Story

  var id: Int {
    return story.id
  }
  
  var title: String {
    return story.title
  }
  
  var url: String {
    return self.story.url
  }
}
