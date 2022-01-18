//
//  MainPageView.swift
//  SwiftUI_FinalProject
//
//  Created by 邵安祺 on 2022/1/12.
//

import SwiftUI

//主要頁面（含各分頁）
struct MainPageView: View {
    var body: some View {
        TabView {
            Text("HOMEPAGE")
                .tabItem {
                    Label("首頁", systemImage: "house.fill")
                }
            GymListView()
                .tabItem {
                    Label("尋找場館", systemImage: "map.fill")
                }
            MyFavGymListView()
                .tabItem {
                    Label("我的最愛", systemImage: "heart.fill")
                }
            Text("MOREINFOPAGE")
                .tabItem {
                    Label("關於", systemImage: "info.circle.fill")
                }
        }
    }
}




