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
                        NavigationLink {
                            GymDetailPageView(gymInfo: gym)
                        } label: {
                            GymInfoView(gymInfo: gym)
                        }
                    }
                }
            }
            .navigationTitle("體育場館")
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

//詳細資訊頁面
struct GymDetailPageView: View {
    var gymInfo: GymInfo
    @StateObject var gymDetailViewModel = GymDetailViewModel()
    private var compWidth: CGFloat { UIScreen.main.bounds.width }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .center) {
                //照片滑頁
                GymPhotoSlideView(photoURLList: gymDetailViewModel.getImage())
                
                //地址、電話、首頁連結分享、加入最愛
                GymMainDetailView(telephone: gymDetailViewModel.gymDetail?.telephone, address: gymDetailViewModel.gymDetail?.address, name: gymDetailViewModel.gymDetail?.name, webpage: gymDetailViewModel.gymDetail?.webURL)
                
                //開放狀態、付費方式、停車場、交通
                SecondaryInfoCard(gymInfo: gymInfo, gymDetailViewModel: gymDetailViewModel)
                
                //簡介、建立年代、賽事經歷
                GymIntroduction(gymDetailViewModel: gymDetailViewModel)
                
                //無障礙資訊
                List {
                    HStack {
                        Text("testing")
                        Text(String(1))
                        Image(systemName: "figure.roll")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .padding(.leading)
                    }
                }
            }
        }
        .onAppear {
            gymDetailViewModel.fetchGymDetail(gymId: gymInfo.gymId)
        }
        .overlay {
            if gymDetailViewModel.gymDetail == nil {
                ZStack {
                    Color(red: 85/255, green: 111/255, blue: 122/255)
                    Text("loading....")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
}

//相簿滑頁
struct GymPhotoSlideView: View {
    var photoURLList: [String]
    private var compWidth: CGFloat { UIScreen.main.bounds.width }
    
    var body: some View {
        ZStack {
            Color(red: 85/255, green: 111/255, blue: 122/255)
                .opacity(0.5)
                .frame(width: compWidth, height: 300)
            TabView {
                ForEach(0..<2) { idx in
                    AsyncImage(url: URL(string: photoURLList[idx])) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ImagePlaceholdView(frameH: 100)
                    }
                }
            }
            .tabViewStyle(.page)
        }
    }
}

//場館主要資訊卡
struct GymMainDetailView: View {
    var telephone: String?
    var address: String?
    var name: String?
    var webpage: String?
    private var compWidth: CGFloat { UIScreen.main.bounds.width }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                Text(name ?? "loading")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding()
                //顯示地址
                HStack(alignment: .center) {
                    Image(systemName: "location.square")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .padding(.leading)
                    Spacer()
                    Text(address ?? "loading")
                        .padding(.trailing)
                }
                .frame(width: compWidth-40)
                .padding()
                
                //顯示電話
                HStack(alignment: .center) {
                    Image(systemName: "phone.down.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .padding(.leading)
                    Spacer()
                    Text(telephone ?? "loading")
                        .padding(.trailing)
                }
                .frame(width: compWidth-40)
                .padding()
                /*-------------*/
                Divider()
                /*-------------*/
                //分享、加入最愛按鈕
                HStack {
                    Spacer()
                    Menu {
                        Button(action: {
                            UIPasteboard.general.string = webpage!
                        }, label: {
                            HStack {
                                Image(systemName: "doc.on.doc")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                Text("Copy Link")
                            }
                        })
                        Link(destination: URL(string: urlEncoder(url: webpage))!, label: {
                            HStack {
                                Image(systemName: "safari")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                Text("以瀏覽器開啟")
                            }
                        })
                    } label: {
                        HStack {
                            Image(systemName: "link")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            Text("Website")
                        }
                    }
                    Spacer()
                    Divider()
                    Spacer()
                    Button(action: {
                        print("liked")
                    }, label: {
                        HStack {
                            Image(systemName: "heart")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            Text("Add to Favorite")
                        }
                    })
                    Spacer()
                }
                .foregroundColor(.gray)
                .frame(width: compWidth-40, height: 50)
            }
        }
        .frame(width: compWidth-40)
        .background(
            Color.white
                .shadow(color: .gray, radius: 6, x: 4, y: 6))
        .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
    }
}

struct GymView_Previews: PreviewProvider {
    static var previews: some View {
        //GymListView()
        GymDetailPageView(gymInfo: GymInfo(name: "百齡高中活動中心", gymId: 1068, telephone: "02-28831568", address: "臺北市士林區義信里承德路4段177號", rate: 0.0, gymFunc: "籃球場,排球場(館),羽球場(館)", photoURL: "https://iplay.sa.gov.tw/Upload/photogym/20140529142146_百齡高中活動中心.jpg", openState: "E", landAttrName: "單一功能型運動場館（非前三項運動場館型態，且運動場館 僅含一項運動設施）", rentState: "付費對外場地租借", Declaration: nil, Distance: 0.0, LatLng: "25.0864539762441,121.523551940918", RateCount: 0))
    }
}

struct SecondaryInfoCard: View {
    var gymInfo: GymInfo
    @StateObject var gymDetailViewModel: GymDetailViewModel
    private var compWidth: CGFloat { UIScreen.main.bounds.width }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("開放狀態")
                .font(.title3)
                .fontWeight(.bold)
            Text(gymDetailViewModel.getOpenState(state: gymInfo.openState))
            Divider()
            Text("付費方式")
                .font(.title3)
                .fontWeight(.bold)
            Text(gymInfo.rentState)
            Divider()
            Text("停車場")
                .font(.title3)
                .fontWeight(.bold)
            Text(gymDetailViewModel.gymDetail?.ParkType ?? "無相關資訊")
            Divider()
            if gymDetailViewModel.gymDetail != nil {
                DisclosureGroup {
                    VStack(alignment: .leading) {
                        ForEach(gymDetailViewModel.getTransInfo(), id:\.self) { str in
                            Text(str)
                        }
                    }
                } label: {
                    Text("交通資訊")
                        .foregroundColor(.black)
                        .font(.title3)
                        .fontWeight(.bold)
                }
                .accentColor(.gray)
            }
        }
        .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
        .frame(width: compWidth-40)
        .background(
            Color.white
                .shadow(color: .gray, radius: 4, x: 6, y: 4))
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
    }
}

struct GymIntroduction: View {
    @StateObject var gymDetailViewModel: GymDetailViewModel
    private var compWidth: CGFloat { UIScreen.main.bounds.width }
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                Rectangle()
                    .stroke(Color(red: 85/255, green: 111/255, blue: 122/255), style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round, dash: [10, 10]))
                Text("場館介紹")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
            }
            .padding(.bottom)
            Text("簡介")
                .font(.title3)
                .fontWeight(.bold)
            Text(gymDetailViewModel.gymDetail?.intro ?? "loading")
            Divider()
            Text("建立時間")
                .font(.title3)
                .fontWeight(.bold)
            HStack(alignment: .center) {
                Image(systemName: "calendar")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .padding(.leading)
                Spacer()
                if gymDetailViewModel.gymDetail != nil {
                    Group {
                        Text("民國　") +
                        Text(String(gymDetailViewModel.unwrapEnableTime()[0])) +
                        Text("　年　") +
                        Text(String(gymDetailViewModel.unwrapEnableTime()[1])) +
                        Text("　月")
                    }
                    .padding(.trailing)
                }
            }
            Divider()
            Text("賽事經歷")
                .font(.title3)
                .fontWeight(.bold)
            Group {
                Text("(") +
                Text(gymDetailViewModel.gymDetail?.Contest ?? "loading") +
                Text(")")
            }
            .foregroundColor(.gray)
            Text(gymDetailViewModel.gymDetail?.ContestIntro ?? "loading")
        }
        .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
        .frame(width: compWidth-40)
        .background(
            Color.white
                .shadow(color: .gray, radius: 4, x: 6, y: 4))
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
    }
}
