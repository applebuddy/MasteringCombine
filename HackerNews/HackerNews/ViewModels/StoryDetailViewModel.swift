//
//  StoryDetailViewModel.swift
//  HackerNews
//
//  Created by MinKyeongTae on 2022/09/29.
//

import Foundation
import Combine

class StoryDetailViewModel: ObservableObject {

  private var cancellable: AnyCancellable?
  // @Published 객체인 story가 변화할때마다 그에 맞게 관련하여 바인딩 된 View가 업데이트 된다.
  @Published private var story: Story?
  
  /// intializer가 아닌 fetchStoryDetails가 View의 onAppear에서 호출되는 시점에 API를 호출한다.
  func fetchStoryDetails(storyId: Int) {
    print("abount to make a network request") // StoryDetailViewModel이 생성될 때마다 호출이 된다... 개선할 수 있는 방법이 없을까?
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
    return self.story?.title ?? "N/A"
  }
  
  var url: String {
    return self.story?.url ?? ""
  }
}
