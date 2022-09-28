

// MARK: 81. Understanding @Binding

import SwiftUI

struct ContentView : View {
  
  let episode = Episode(name: "Macbreak Weekly", track: "WWDC 2022")
  
  @State private var isPlaying = false
  
  var body: some View {
    
    VStack {
      
      Text(self.episode.name)
        .font(.title)
        .foregroundColor(self.isPlaying ? .green : Color(UIColor.darkGray))
      
      Text(self.episode.track)
        .foregroundColor(.secondary)
      
      // PlayButton View와 isPlaying State 변수를 바인딩, PlayButton에서는 @Binding 변수를 통해서 바인딩 값을 받아서 다룰 수 있다.
      // PlayButton을 클릭했을때, 바인딩 변수의 변화를 통해, 메인화면를 업데이트할 수 있다.
      PlayButton(isPlaying: $isPlaying)
      
    }
    
  }
}

struct PlayButton: View {
  
  @Binding var isPlaying: Bool
  
  var body: some View {
    
    Button(action: {
      self.isPlaying.toggle()
    }) {
      Text("Play")
    }.padding(12)
    
  }
  
}


#if DEBUG
struct ContentView_Previews : PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
#endif
