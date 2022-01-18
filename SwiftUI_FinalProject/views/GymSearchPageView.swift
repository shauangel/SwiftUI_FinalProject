//
//  GymListView.swift
//  SwiftUI_FinalProject
//
//  Created by 邵安祺 on 2022/1/9.
//

import SwiftUI
import CoreData

//體育場館列表
struct GymListView: View {
    @StateObject var gymListViewModel = GymListViewModel()
    @State var searchKey: String = "臺北市"
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \MyFav.timestamp, ascending: true)], animation: .default)
    private var MyFavList: FetchedResults<MyFav>
    
    init() {
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .black
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                Spacer()
                    .frame(height: 50)
                let columns = [GridItem()]
                LazyVGrid(columns: columns) {
                    if !gymListViewModel.gymList.isEmpty {
                        ForEach(gymListViewModel.gymList) { gym in
                            NavigationLink {
                                GymDetailPageView(gymInfo: gym)
                            } label: {
                                GymInfoView(gymInfo: gym)
                            }
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
            if gymListViewModel.gymList.isEmpty {
                gymListViewModel.fetchGymInfo(city: searchKey)
                print(gymListViewModel.gymList)
            }
        }
        .onChange(of: searchKey) { sKey in
            gymListViewModel.fetchGymInfo(city: sKey)
        }
    }
}

//單欄體育場館資訊
struct GymInfoView: View {
    private var compWidth: CGFloat { UIScreen.main.bounds.width }
    var gymInfo: GymInfo
    @State var liked: Bool = false
    
    @Environment(\.managedObjectContext) private var viewContext
    //all
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \MyFav.timestamp, ascending: true)], animation: .default)
    private var MyFavList: FetchedResults<MyFav>
    
    init(gymInfo: GymInfo) {
        self.gymInfo = gymInfo
    }
    
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
                    if checkIfExists(gymID: gymInfo.gymId) {
                        liked = false
                        deleteFavItems(gymID: gymInfo.gymId)
                        print("cancel")
                    }
                    else {
                        liked = true
                        print("add to core data")
                        addFavItem()
                        //加到喜愛列表
                    }
                }, label: {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                })
                    .foregroundColor(liked == true ? Color.pink : Color.gray)
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
    
    private func addFavItem() {
        withAnimation {
            let newItem = MyFav(context: viewContext)
            newItem.timestamp = Date()
            newItem.gymName = self.gymInfo.name
            newItem.gymAddr = self.gymInfo.address
            newItem.gymID = Int64(self.gymInfo.gymId)
            newItem.teleNum = self.gymInfo.telephone
            newItem.userNote = ""
            newItem.openState = self.gymInfo.openState
            newItem.rentState = self.gymInfo.rentState
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func checkIfExists(gymID: Int) -> Bool {
        print()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MyFav")
        fetchRequest.predicate = NSPredicate(format: "gymID == %@", NSNumber(value: gymID))
        var results: [NSManagedObject] = []
        do {
            results = try viewContext.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }

        return results.count > 0
    }
    
    private func deleteFavItems(gymID: Int) {
        let fetchRequest = NSFetchRequest<MyFav>(entityName: "MyFav")
        let predicate = NSPredicate(format: "gymID == %@", NSNumber(value: gymID))
        fetchRequest.predicate = predicate
        let moc = viewContext
        let result = try? moc.fetch(fetchRequest)
        for object in result! {
            moc.delete(object)
        }
        do {
            try moc.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
}


