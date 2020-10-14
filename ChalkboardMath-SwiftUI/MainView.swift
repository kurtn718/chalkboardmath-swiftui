//
//  MainView.swift
//  ChalkboardMath-SwiftUI
//
//  Created by Kurt Niemi on 10/13/20.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        ZStack {
            Image("Chalkboard").resizable()
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView()
            MainView()
                .preferredColorScheme(.dark)
        }
    }
}

#endif
