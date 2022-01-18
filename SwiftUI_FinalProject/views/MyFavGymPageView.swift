//
//  MyFavGymPageView.swift
//  SwiftUI_FinalProject
//
//  Created by 邵安祺 on 2022/1/18.
//
import UIKit
import SwiftUI

struct MyFavGymListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \MyFav.timestamp, ascending: true)], animation: .default)
    private var MyFavList: FetchedResults<MyFav>
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(MyFavList) { myFav in
                    HStack {
                        Text(myFav.gymName!)
                        Spacer()
                        Timestamp(date: myFav.timestamp!)
                    }
                }
                .onDelete(perform: deleteFavItems)
            }
            .background(
                Image("bg")
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.5)
            )
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(.inset)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Image(systemName: "heart.fill")
                        Text("My Favorite")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Image(systemName: "heart.fill")
                    }
                    .foregroundColor(Color.white)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                        .foregroundColor(.white)
                }
                ToolbarItem {
                    Button(action: addFavItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                    .foregroundColor(.white)
                }
            }
            .navigationBarColor(backgroundColor: UIColor(red: 206/255, green: 181/255, blue: 183/255, alpha: 1), titleColor: UIColor.white)
        }
    }
    
    private func addFavItem() {
        withAnimation {
            let newItem = MyFav(context: viewContext)
            newItem.timestamp = Date()
            newItem.gymName = "testing"
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteFavItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { MyFavList[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

//timestamp dateformatter
struct Timestamp: View {
    var date: Date
    var body: some View {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return Text("\(date, formatter: formatter)")
    }
}


struct MyFavListView_Previews: PreviewProvider {
    static var previews: some View {
        MyFavGymListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
}
