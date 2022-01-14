//
//  WaitingAnimationView.swift.swift
//  SwiftUI_FinalProject
//
//  Created by 邵安祺 on 2022/1/14.
//

import SwiftUI

struct ImagePlaceholdView: View {
    var frameH: CGFloat
    
    var body: some View {
        ZStack {
            Color(.gray)
                .opacity(0.8)
            VStack {
                Image(systemName: "exclamationmark.triangle")
                    .resizable()
                    .scaledToFit()
                    .frame(height: frameH)
                    .foregroundColor(.white)
                Text("Image Not Available...")
                    .foregroundColor(.white)
                    .font(.title3)
            }
        }
    }
}











