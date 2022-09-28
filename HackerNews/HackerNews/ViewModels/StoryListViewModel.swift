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
      stories.map { StoryViewModel(story: $0) }
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
