//
//  CoverPageView.swift
//  SwiftUI_FinalProject
//
//  Created by 邵安祺 on 2022/1/12.
//

import SwiftUI


struct CoverPageView: View {
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(red: 214/255, green: 255/255, blue: 246/255), Color(red: 147/255, green: 170/255, blue: 180/255), Color(red: 85/255, green: 111/255, blue: 122/255)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            Image("vbSpike")
                .resizable()
                .scaledToFit()
                .padding()
            Image("vb")
                .resizable()
                .scaledToFit()
                .frame(width: 45)
                .offset(x:28, y: -223)
        }
    }
}


struct CoverPageView_Previews: PreviewProvider {
    static var previews: some View {
        CoverPageView()
    }
}




