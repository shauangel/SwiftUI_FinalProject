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
                Spacer()
                    .frame(height: 50)
                let columns = [GridItem()]
                LazyVGrid(columns: columns) {
                    ForEach(gymListViewModel.gymList) { gym in
                        NavigationLink {
                            GymDetailPageView(gymInfo: gym)
                        } label: {
                            GymInfoView(gymInfo: gym)
                        }
                    }
                }
            }
            .navigationBarTitle("體育場館", displayMode: .inline)
            .navigationBarColor(backgroundColor: UIColor(red: 85/255, green: 111/255, blue: 122/255, alpha: 1), titleColor: UIColor.white)
        }
        .foregroundColor(.black)
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
                    ImagePlaceholdView(frameH: 60)
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


