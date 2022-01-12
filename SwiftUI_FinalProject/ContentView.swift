//
//  ContentView.swift
//  SwiftUI_FinalProject
//
//  Created by 邵安祺 on 2021/12/28.
//

import SwiftUI
import Foundation

struct ContentView: View {
    //@StateObject var gymListViewModel = GymListViewModel()
    @StateObject var gymDetailViewModel = GymRowViewModel()
    
    
    var body: some View {
        ZStack {
            /*
            Color(.black)
                .ignoresSafeArea()
            AsyncImage(url: URL(string: "https://cataas.com/cat/cute"))
                .opacity(0.5)
             */
            Button {
                //gymListViewModel.fetchGymInfo(city: "臺北市")
                gymDetailViewModel.fetchGymDetail(gymId: 13338)
            } label : {
                Text("testing API!!")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
