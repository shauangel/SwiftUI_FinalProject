//
//  GymListViewModel.swift
//  SwiftUI_FinalProject
//
//  Created by 邵安祺 on 2022/1/9.
//

import Foundation

class GymListViewModel: ObservableObject {
    @Published var gymList = [GymInfo]()
    
    func fetchGymInfo(city: String) {
        //處理網址中文參數
        let urlString = urlEncoder(url: "https://iplay.sa.gov.tw/api/GymSearchAllList?$format=application/json;odata.metadata=none&Keyword=排球&City=\(city)&GymType=排球")
        //make request
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        //decode searching response to defined structure by decoder
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601
                        let gymList = try decoder.decode([GymInfo].self, from: data)
                        
                        //switch to main thread
                        DispatchQueue.main.async {
                            self.gymList = gymList
                            print(self.gymList)
                        }
                    } catch { print(error) }
                }
            }.resume()
        }
    }
}



class GymDetailViewModel: ObservableObject {
    @Published var gymDetail: GymDetail?
    
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
}


func urlEncoder(url: String?) -> String {
    if let result = url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
        return result
    }
    return "err"
}
