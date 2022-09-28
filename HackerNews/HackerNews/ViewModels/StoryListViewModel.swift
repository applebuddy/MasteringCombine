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
    self.cancellable = Webservice().getAllTopStories().map { storyIds in
      storyIds.map { StoryViewModel(id: $0) }
    }.sink(receiveCompletion: { _ in }) { storyViewModels in
      self.stories = storyViewModels
    }
  }
}

struct StoryViewModel {
  let id: Int
}
