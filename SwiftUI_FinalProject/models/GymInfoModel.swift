//
//  GymInfoModel.swift
//  SwiftUI_FinalProject
//
//  Created by 邵安祺 on 2022/1/9.
//

import Foundation

struct GymInfo: Codable, Identifiable {
    var id: Int { gymId }
    let name: String
    let gymId: Int
    let telephone: String
    let address: String
    let rate: Double
    let gymFunc: String
    let photoURL: String
    let openState: String
    let landAttrName: String
    let rentState: String
    
    //無用
    let Declaration: String?
    let Distance: Double
    let LatLng: String
    let RateCount: Int
    
    //自訂property名稱
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case gymId = "GymID"
        case telephone = "OperationTel"
        case address = "Address"
        case rate = "Rate"
        case gymFunc = "GymFuncList"
        case photoURL = "Photo1"
        case openState = "OpenState"
        case landAttrName = "LandAttrName"
        case rentState = "RentState"
        case Declaration
        case Distance
        case LatLng
        case RateCount
    }
    
    func getImage() -> String {
        return self.photoURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "encoding URL error"
    }
}

