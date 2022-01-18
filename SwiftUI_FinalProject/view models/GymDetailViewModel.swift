//
//  GymDetailViewModel.swift
//  SwiftUI_FinalProject
//
//  Created by 邵安祺 on 2022/1/18.
//

import Foundation


class GymDetailViewModel: ObservableObject {
    @Published var gymDetail: GymDetail?
    
    struct PassEasy: Hashable{
        var name: String
        var number: Int
        var photoURL: String
    }
    
    func fetchGymDetail(gymId: Int) {
        let urlString = "https://iplay.sa.gov.tw/odata/Gym(\(gymId))?$format=application/json;odata.metadata=none&$expand=GymFuncData"
        print(urlString)
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        //decode searching response to defined structure by decoder
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601
                        let temp = try decoder.decode(GymDetail.self, from: data)
                        
                        //switch to main thread
                        DispatchQueue.main.async {
                            self.gymDetail = temp
                            if let display = self.gymDetail { print(display) }
                            else { print("load err") }
                        }
                    } catch { print(error) }
                }
            }.resume()
        }
    }
    
    func getImage() -> [String] {
        var photoList = [String]()
        photoList.append(urlEncoder(url: self.gymDetail?.photoURL1))
        photoList.append(urlEncoder(url: self.gymDetail?.photoURL2))
        return photoList
    }
    
    func getTransInfo() -> [String] {
        
        if let trans = self.gymDetail?.PublicTransport {
            //pre-processing: 去除前後空格、空白行、文字分段
            var transArray = trans.components(separatedBy: "\r\n")
            for idx in transArray.indices {
                transArray[idx] = transArray[idx].trimmingCharacters(in: .whitespacesAndNewlines)
            }
            transArray = transArray.filter({ $0 != "" })
            return transArray
        }
        else {
            print("oh no")
            return [""]
        }
    }
    
    func getOpenState(state: String) -> String {
        switch state {
        case "E":
            return "每天開放"
        case "H":
            return "假日開放"
        case "W":
            return "平日開放"
        case "N":
            return "不開放"
        default:
            return "未知"
        }
    }
    
    func getPassEasyInfo() -> [PassEasy] {
        var passEasyList = [PassEasy]()
        passEasyList.append(PassEasy(name: "無障礙升降設備", number: unwrapInt(number: self.gymDetail?.PassEasyEle), photoURL: urlEncoder(url: self.gymDetail?.PassEasyElePhotoUrl)))
        passEasyList.append(PassEasy(name: "無障礙汽車停車格", number: unwrapInt(number: self.gymDetail?.PassEasyParking), photoURL: urlEncoder(url: self.gymDetail?.PassEasyParkingPhotoUrl)))
        passEasyList.append(PassEasy(name: "無障礙淋浴間", number: unwrapInt(number: self.gymDetail?.PassEasyShower), photoURL: urlEncoder(url: self.gymDetail?.PassEasyShowerPhotoUrl)))
        passEasyList.append(PassEasy(name: "無障礙廁所", number: unwrapInt(number: self.gymDetail?.PassEasyToilet), photoURL: urlEncoder(url: self.gymDetail?.PassEasyToiletPhotoUrl)))
        passEasyList.append(PassEasy(name: "無障礙走道", number: unwrapInt(number: self.gymDetail?.PassEasyWay), photoURL: urlEncoder(url: self.gymDetail?.PassEasyWayPhotoUrl)))
        return passEasyList
    }
    
    func unwrapInt(number: Int?) -> Int {
        if let num = number {
            return num
        }
        else {
            print("Int unwrap err")
            return 0
        }
    }
    
}
