//
//  ChalkboardButtonView.swift
//  ChalkboardMath-SwiftUI
//
//  Created by Kurt Niemi on 10/16/20.
//

import SwiftUI

struct ChalkboardButtonView: View {
    
    let buttonText:String
    let fontSize: CGFloat = 33.0
    let onClick: (() -> Void)? = nil
    @State var selected:Bool = false

    var body: some View {
        ZStack {
            if (selected) {
            Circle()
                .strokeBorder(Color.white, lineWidth: 2)
                .frame(minWidth: nil, idealWidth: 40, maxWidth: 40, minHeight: 0, idealHeight: 40, maxHeight: 40, alignment: .center)
            }
            
            Button(buttonText) {
                selected.toggle()
                onClick?()
            }.foregroundColor(.white).font(Font.custom("Chalkduster", size: fontSize))
        }
    }
}

struct ChalkboardButtonView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
        ZStack {
            Image("Chalkboard").resizable()
            ChalkboardButtonView(buttonText: "1", selected: true)
        }.previewLayout(.fixed(width: 150, height: 150))
        
        ZStack {
            Image("Chalkboard").resizable()
            ChalkboardButtonView(buttonText: "1")
        }.preferredColorScheme(.dark).previewLayout(.fixed(width: 150, height: 150))

    }
    }
}
