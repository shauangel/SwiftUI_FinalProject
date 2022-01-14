//
//  GymListView.swift
//  SwiftUI_FinalProject
//
//  Created by 邵安祺 on 2022/1/9.
//

import SwiftUI

//體育場館列表
struct GymListView: View {
    @StateObject var gymListViewModel = GymListViewModel()
    @State var searchKey: String = "臺北市"
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                let columns = [GridItem()]
                LazyVGrid(columns: columns) {
                    ForEach(gymListViewModel.gymList) { gym in
                        GymInfoView(gymInfo: gym)
                    }
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

//單欄體育場館資訊
struct GymInfoView: View {
    private var compWidth: CGFloat { UIScreen.main.bounds.width }
    var gymInfo: GymInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ZStack {
                RoundedRectangle(cornerRadius: 15, style: .circular)
                AsyncImage(url: URL(string: gymInfo.getImage())) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ZStack {
                        Color(.gray)
                            .opacity(0.8)
                        VStack {
                            Image(systemName: "exclamationmark.triangle")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 60)
                                .foregroundColor(.white)
                            Text("Image Not Available...")
                                .foregroundColor(.white)
                                .font(.title3)
                        }
                    }
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .circular))
                }
            }
            .frame(width: compWidth-40, height: compWidth/2-20)
            Text(gymInfo.name)
                .font(.title2)
                .frame(width: compWidth-40, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
            HStack(spacing:15) {
                Button(action:{
                    print("hi there")
                    //加到喜愛列表
                }, label: {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                })
                    .foregroundColor(.gray)
                Text("評分:")
                    .foregroundColor(Color(.gray))
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(.gray))
                        .frame(width: 210, height: 8)
                        .opacity(0.5)
                    Rectangle()
                        .fill(Color(red: 0.90, green: 0.58, blue: 0.59))
                        .frame(width: 210/10*gymInfo.rate, height: 8)
                }
                Text(String(gymInfo.rate))
            }
            .frame(width: compWidth-40)
            Divider()
        }
        .frame(width: compWidth-40)
    }
}

struct GymDetailPageView: View {
    var gymID: Int
    @StateObject var gymDetailViewModel = GymDetailViewModel()
    private var compWidth: CGFloat { UIScreen.main.bounds.width }
    
    var body: some View {
        VStack(alignment: .center) {
            Text(gymDetailViewModel.gymDetail?.name ?? "err")
        }
        .onAppear {
            gymDetailViewModel.fetchGymDetail(gymId: gymID)
            print(gymDetailViewModel.gymDetail)
        }
    }
    
    
}



struct GymView_Previews: PreviewProvider {
    static var previews: some View {
        //GymListView()
        GymDetailPageView(gymID: 2505)
        //GymInfoView(gymInfo: GymInfo(name: "百齡高中活動中心", gymId: 1068, telephone: "02-28831568", address: "臺北市士林區義信里承德路4段177號", rate: 0.0, gymFunc: "籃球場,排球場(館),羽球場(館)", photoURL: "https://iplay.sa.gov.tw/Upload/photogym/20140529142146_百齡高中活動中心.jpg", openState: "E", landAttrName: "單一功能型運動場館（非前三項運動場館型態，且運動場館 僅含一項運動設施）", rentState: "付費對外場地租借", Declaration: nil, Distance: 0.0, LatLng: "25.0864539762441,121.523551940918", RateCount: 0))
    }
}







