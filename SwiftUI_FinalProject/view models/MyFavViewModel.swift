////
////  MyFavViewModel.swift
////  SwiftUI_FinalProject
////
////  Created by 邵安祺 on 2022/1/19.
////
//
//import Foundation
//import CoreData
//
//
//class MyFavViewModel: ObservableObject {
//
//    struct RecordState {
//        var gymId: Int
//        var isRecorded: Bool
//    }
//
//    func checkIfExists(gymID: Int) -> Bool {
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MyFav")
//        fetchRequest.predicate = NSPredicate(format: "gymID == %@", NSNumber(value: gymID))
//        var results: [NSManagedObject] = []
//        do {
//            results = try viewContext.fetch(fetchRequest)
//        }
//        catch {
//            print("error executing fetch request: \(error)")
//        }
//        return results.count > 0
//    }
//
//}
//
//
//
//
//
//
//
//
