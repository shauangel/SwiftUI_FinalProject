//
//  GymDetailModel.swift
//  SwiftUI_FinalProject
//
//  Created by 邵安祺 on 2022/1/9.
//

import Foundation

struct GymDetail: Codable {
    let address: String
    let gymType: String
    let gymId: Int
    let intro: String
    let lat: Double
    let lng: Double
    let name: String
    let telephone: String
    let photoURL1: String?
    let photoURL2: String?
    let rate: Double
    let webURL: String
    //少用
    let Contest: String
    let ContestIntro: String?
    let Declaration: String?
    let DeclarationUrl: URL?
    let EnableMonth: Int
    let EnableYear: Int
    let ParkType: String?
    let PassEasyEle: String?
    let PassEasyElePhotoUrl: URL?
    let PassEasyFuncOthers: String?
    let PassEasyParking: String?
    let PassEasyParkingPhotoUrl: URL?
    let PassEasyShower: String?
    let PassEasyShowerPhotoUrl: URL?
    let PassEasyToilet: String?
    let PassEasyToiletPhotoUrl: URL?
    let PassEasyWay: String?
    let PassEasyWayPhotoUrl: URL?
    let PublicTransport: String?
    let RateCount: Int?
    let WheelchairAuditorium: String?
    let WheelchairAuditoriumPhotoUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case address = "Addr"
        case gymType = "GymType"
        case gymId = "ID"
        case intro = "Introduction"
        case lat = "Lat"
        case lng = "Lng"
        case name = "Name"
        case telephone = "OperationTel"
        case photoURL1 = "Photo1Url"
        case photoURL2 = "Photo2Url"
        case rate = "Rate"
        case webURL = "WebUrl"
        case Contest
        case ContestIntro
        case Declaration
        case DeclarationUrl
        case EnableMonth
        case EnableYear
        case ParkType
        case PassEasyEle
        case PassEasyElePhotoUrl
        case PassEasyFuncOthers
        case PassEasyParking
        case PassEasyParkingPhotoUrl
        case PassEasyShower
        case PassEasyShowerPhotoUrl
        case PassEasyToilet
        case PassEasyToiletPhotoUrl
        case PassEasyWay
        case PassEasyWayPhotoUrl
        case PublicTransport
        case RateCount
        case WheelchairAuditorium
        case WheelchairAuditoriumPhotoUrl
    }
}

/*
extension String {
    func decodeWord() -> String? {
        var chars = [unichar]()
        for substr in self.components(separatedBy: "\\u") where !substr.isEmpty {
            if let value = UInt16(substr, radix: 16) {
                chars.append(value)
            }
            else {
                return nil
            }
        }
        return NSString(characters: chars, length: chars.count) as String
    }
}
*/
