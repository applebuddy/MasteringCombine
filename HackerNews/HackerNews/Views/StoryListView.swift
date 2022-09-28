//
//  StoryListView.swift
//  HackerNews
//
//  Created by MinKyeongTae on 2022/09/29.
//

import SwiftUI

struct StoryListView: View {
  // StoryListViewModel은 ObservableObject이므로, View에서 사용할때에는 변수 정의 앞에 @ObservedObject annotation을 붙혀줍니다.
  @ObservedObject private var storyListViewModel = StoryListViewModel()
  
  var body: some View {
    NavigationView {
      List(self.storyListViewModel.stories, id: \.id) { storyViewModel in
        NavigationLink(destination: StoryDetailView(storyId: storyViewModel.id)) {
          Text("\(storyViewModel.title)")
        }
      }
      .navigationTitle("Hacker News")
    }
  }
}

struct StoryListView_Previews: PreviewProvider {
  static var previews: some View {
    StoryListView()
  }
}
