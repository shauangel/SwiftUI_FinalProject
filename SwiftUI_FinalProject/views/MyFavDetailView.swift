//
//  MyFavDetailView.swift
//  SwiftUI_FinalProject
//
//  Created by 邵安祺 on 2022/1/19.
//

import SwiftUI


struct MyFavDetailPageView: View {
    private var compWidth: CGFloat { UIScreen.main.bounds.width }
    @ObservedObject var myFav: MyFav
    @State private var userNote: String
    @Environment(\.managedObjectContext) private var viewContext
    
    init(myFav: MyFav) {
        self.myFav = myFav
        self.userNote =  myFav.userNote ?? "無"
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .center) {
                Spacer().frame(height: 50)
                Text(myFav.gymName!)
                    .font(.title)
                Rectangle()
                    .fill(MyColorPlate.cadet)
                    .frame(width: compWidth-40, height: 3)
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        Image(systemName: "location.square")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .padding(.leading)
                        Spacer()
                        Text(myFav.gymAddr ?? "loading")
                            .font(.title2)
                            .padding(.trailing)
                    }
                    .padding()
                    Divider()
                    HStack(alignment: .center) {
                        Image(systemName: "phone.down.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .padding(.leading)
                        Spacer()
                        Text(myFav.teleNum ?? "loading")
                            .font(.title2)
                            .padding(.trailing)
                    }
                    .padding()
                    Divider()
                    HStack {
                        VStack(alignment: .leading) {
                            Text("紀錄時間: ")
                            DetailTimestamp(date: myFav.timestamp!)
                        }
                        .foregroundColor(.gray)
                        Spacer()
                        NavigationLink {
                            GymDetailPageView(gymInfo: GymInfo(name: myFav.gymName!, gymId: Int(myFav.gymID), telephone: myFav.teleNum!, address: myFav.gymAddr!, rate: 0, gymFunc: "", photoURL: "", openState: myFav.openState!, landAttrName: "", rentState: myFav.rentState!, Declaration: "", Distance: 0.0, LatLng: "", RateCount: 0))
                        } label: {
                            Image(systemName: "arrow.right.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                        }
                    }
                    .padding()
                    Divider()
                    VStack(alignment: .leading) {
                        Text("My Memo")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(MyColorPlate.cadet)
                        TextEditor(text: $userNote)
                            .frame(height: 300)
                            .padding()
                            .border(MyColorPlate.cadet, width: 5)
                    }
                    .padding()
                }
                .frame(width: compWidth-40)
                .background(
                    Color.white
                        .shadow(color: .gray, radius: 6, x: 4, y: 6))
                .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
            }
            .frame(width: compWidth)
        }
        .onChange(of: userNote) { note in
            modifyRecord(myFav)
        }
    }
    
    func modifyRecord(_ gym: MyFav) {
        withAnimation {
            self.myFav.userNote = self.userNote
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    //timestamp dateformatter
    struct DetailTimestamp: View {
        var date: Date
        var body: some View {
            let formatter = DateFormatter()
            formatter.dateStyle = .full
            return Text("\(date, formatter: formatter)")
        }
    }
}



