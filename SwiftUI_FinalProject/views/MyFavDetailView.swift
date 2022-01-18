//
//  MyFavDetailView.swift
//  SwiftUI_FinalProject
//
//  Created by 邵安祺 on 2022/1/19.
//

import SwiftUI


struct MyFavDetailPageView: View {
    
    @ObservedObject var myFav: MyFav
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        VStack {
            
        }
    }
    
    func modifyRecord(_ gym: MyFav) {
        withAnimation {
            myFav.userNote = gym.userNote
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}



