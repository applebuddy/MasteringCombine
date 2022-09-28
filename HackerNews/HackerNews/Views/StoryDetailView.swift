//
//  StoryDetailView.swift
//  HackerNews
//
//  Created by MinKyeongTae on 2022/09/29.
//

import SwiftUI

struct StoryDetailView: View {
  
  let storyId: Int
  @ObservedObject private var storyDetailViewModel: StoryDetailViewModel
  
  init(storyId: Int) {
    // storyId에 맞는 ViewModel을 생성하여 ViewModel이 생성되면서 API를 호출, Story에 맞는 ViewModel 설정이 된다.
    // ViewModel은 ObservableObject이므로 이를 ObservedObject로 사용하고 있는 StoryDetailView는 ViewModel의 변화에 맞게 View를 rendering 하게 된다.
    // ViewModel에 바인딩 된 View를 업데이트 한다.
    self.storyId = storyId
    self.storyDetailViewModel = StoryDetailViewModel(storyId: storyId)
  }
  
  var body: some View {
    VStack {
      Text(self.storyDetailViewModel.title)
    }
  }
}

struct StoryDetailView_Previews: PreviewProvider {
  static var previews: some View {
    StoryDetailView(storyId: 8863)
  }
}
