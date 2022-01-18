//
//  GymDetailView.swift
//  SwiftUI_FinalProject
//
//  Created by 邵安祺 on 2022/1/18.
//

import SwiftUI

//詳細資訊頁面
struct GymDetailPageView: View {
    var gymInfo: GymInfo
    @StateObject var gymDetailViewModel = GymDetailViewModel()
    private var compWidth: CGFloat { UIScreen.main.bounds.width }
    
    @State var showPassEasyImage = false
    @State var displayImgURL: String = ""
    
    var content: some View {
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
                PassEasyInfoCard(gymDetailViewModel: gymDetailViewModel, showPassEasyImage: $showPassEasyImage, displayImgURL: $displayImgURL)
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
    
    var body: some View {
        ZStack {
            content
            ActionSheetCard(photoURL: displayImgURL, isShowing: $showPassEasyImage)
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
                        Button(action: { UIPasteboard.general.string = webpage! }, label: {
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
                    //加入喜好列表機制
                    Button(action: { print("liked") }, label: {
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

//次要場館資訊（開放狀態、交通、付費方法）
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

//建築物介紹
struct GymIntroduction: View {
    @StateObject var gymDetailViewModel: GymDetailViewModel
    private var compWidth: CGFloat { UIScreen.main.bounds.width }
    
    var body: some View {
        VStack(alignment: .leading) {
            //區塊標題
            ZStack {
                Rectangle()
                    .stroke(Color(red: 85/255, green: 111/255, blue: 122/255), style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round, dash: [10, 10]))
                Text("場館介紹")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
            }
            .padding(.bottom)
            //場館簡介
            Text("簡介")
                .font(.title3)
                .fontWeight(.bold)
            Text(gymDetailViewModel.gymDetail?.intro ?? "loading")
            Divider()
            //場館建立時間（年月）
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
                        Text(String(gymDetailViewModel.unwrapInt(number: gymDetailViewModel.gymDetail?.EnableYear))) +
                        Text("　年　") +
                        Text(String(gymDetailViewModel.unwrapInt(number: gymDetailViewModel.gymDetail?.EnableMonth))) +
                        Text("　月")
                    }
                    .padding(.trailing)
                }
            }
            Divider()
            //場館賽事介紹
            Text("賽事經歷")
                .font(.title3)
                .fontWeight(.bold)
            Group {
                Text("(") +
                Text(gymDetailViewModel.gymDetail?.Contest ?? "loading") +
                Text(")")
            }
            .foregroundColor(.gray)
            Text(gymDetailViewModel.gymDetail?.ContestIntro ?? "無")
        }
        .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
        .frame(width: compWidth-40)
        .background(
            Color.white
                .shadow(color: .gray, radius: 4, x: 6, y: 4))
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
    }
}

struct PassEasyInfoCard: View {
    @StateObject var gymDetailViewModel: GymDetailViewModel
    private var compWidth: CGFloat { UIScreen.main.bounds.width }
    @Binding var showPassEasyImage: Bool
    @Binding var displayImgURL: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "figure.roll")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                Text("無障礙設施")
                    .font(.title3)
                    .fontWeight(.bold)
            }
            if gymDetailViewModel.gymDetail != nil {
                ForEach(gymDetailViewModel.getPassEasyInfo(), id: \.self) { item in
                    HStack {
                        Text(item.name)
                            .padding(.trailing)
                        Text(String(item.number))
                        Spacer()
                        Button(action: {
                            displayImgURL = item.photoURL
                            showPassEasyImage.toggle()
                        }, label: {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                        })
                    }
                }
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
