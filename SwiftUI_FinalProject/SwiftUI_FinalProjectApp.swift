//
//  SwiftUI_FinalProjectApp.swift
//  SwiftUI_FinalProject
//
//  Created by 邵安祺 on 2021/12/28.
//

import SwiftUI

@main
struct SwiftUI_FinalProjectApp: App {
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {

        WindowGroup {
            MainPageView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            //GymDetailPageView(gymID: 2505)
            //MainPageView()
            //GymInfoView(gymInfo: GymInfo(name: "百齡高中活動中心", gymId: 1068, telephone: "02-28831568", address: "臺北市士林區義信里承德路4段177號", rate: 0.0, gymFunc: "籃球場,排球場(館),羽球場(館)", photoURL: "https://iplay.sa.gov.tw/Upload/photogym/20140529142146_百齡高中活動中心.jpg", openState: "E", landAttrName: "單一功能型運動場館（非前三項運動場館型態，且運動場館 僅含一項運動設施）", rentState: "付費對外場地租借", Declaration: nil, Distance: 0.0, LatLng: "25.0864539762441,121.523551940918", RateCount: 0))
        }
    }
}
