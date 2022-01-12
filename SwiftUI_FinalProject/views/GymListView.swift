//
//  GymListView.swift
//  SwiftUI_FinalProject
//
//  Created by 邵安祺 on 2022/1/9.
//

import SwiftUI

struct GymListView: View {
    @StateObject var gymListViewModel = GymListViewModel()
    @State var searchKey: String = "臺北市"
    
    var body: some View {
        NavigationView {
            List {
                ForEach(gymListViewModel.gymList) { gymInfo in
                    Text(gymInfo.name)
                }
            }
            .navigationTitle("體育場館")
        }
        .searchable(text: $searchKey, placement: .navigationBarDrawer(displayMode: .always))
        .onAppear {
            gymListViewModel.fetchGymInfo(city: searchKey)
            print(gymListViewModel.gymList)
        }
    }
}

struct GymInfoView: View {
    private var compWidth: CGFloat { UIScreen.main.bounds.width }
    var gymInfo: GymInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ZStack {
                RoundedRectangle(cornerRadius: 15, style: .circular)
                    .frame(width: compWidth-40, height: compWidth/2-20)
                AsyncImage(url: URL(string: gymInfo.getImage())) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Color(.gray)
                }
            }
            Text(gymInfo.name)
                .font(.title)
                .frame(width: compWidth-40, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
            HStack {
                Spacer()
                Text("評分: ")
                Rectangle()
            }
            .frame(width: compWidth-40)
        }
        .frame(width: compWidth-40, height: compWidth/2)
    }
}


struct GymView_Previews: PreviewProvider {
    
    static var previews: some View {
        GymInfoView(gymInfo: GymInfo(name: "百齡高中活動中心", gymId: 1068, telephone: "02-28831568", address: "臺北市士林區義信里承德路4段177號", rate: 0.0, gymFunc: "籃球場,排球場(館),羽球場(館)", photoURL: "https://iplay.sa.gov.tw/Upload/photogym/20140529142146_百齡高中活動中心.jpg", openState: "E", landAttrName: "單一功能型運動場館（非前三項運動場館型態，且運動場館 僅含一項運動設施）", rentState: "付費對外場地租借", Declaration: nil, Distance: 0.0, LatLng: "25.0864539762441,121.523551940918", RateCount: 0))
    }
}







