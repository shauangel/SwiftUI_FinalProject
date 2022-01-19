//
//  WaitingAnimationView.swift.swift
//  SwiftUI_FinalProject
//
//  Created by 邵安祺 on 2022/1/14.
//

import SwiftUI

struct MyColorPlate {
    static let cadet: Color = Color(red: 85/255, green: 111/255, blue: 122/255)
    static let silverPink: Color = Color(red: 0.90, green: 0.58, blue: 0.59)
    static let lightCyan: Color = Color(red: 214/255, green: 255/255, blue: 246/255)
    static let pewterBlue: Color = Color(red: 147/255, green: 170/255, blue: 180/255)
    static let cerise: Color = Color(red: 219/255, green: 39/255, blue: 99/255)
}

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











