//
//  StoryDetailViewModel.swift
//  HackerNews
//
//  Created by MinKyeongTae on 2022/09/29.
//

import Foundation
import Combine

class StoryDetailViewModel: ObservableObject {
  var storyId: Int
  private var cancellable: AnyCancellable?
  // @Published 객체인 story가 변화할때마다 그에 맞게 관련하여 바인딩 된 View가 업데이트 된다.
  @Published private var story: Story!

  init(storyId: Int) {
    self.storyId = storyId
    // fetching story information
    self.cancellable = Webservice().getStoryById(storyId: storyId)
      .catch { _ in Just(Story.placeholder()) } // 에러 발생 시, nil이 아닌 placeholder Story 값으로 처리할 수 있습니다.
      .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] story in
        self?.story = story
      })
  }
}

extension StoryDetailViewModel {
  
  var title: String {
    return self.story.title
  }
  
  var url: String {
    return self.story.url
  }
}
