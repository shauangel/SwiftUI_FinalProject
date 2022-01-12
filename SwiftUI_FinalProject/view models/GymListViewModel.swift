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
        let requestURL = "https://iplay.sa.gov.tw/api/GymSearchAllList?$format=application/json;odata.metadata=none&Keyword=排球&City=\(city)&GymType=排球"
        //處理網址中文參數
        let urlString = requestURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "encoding URL error"
        
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
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
}


class GymRowViewModel: ObservableObject {
    
    func fetchGymDetail(gymId: Int) {
        let urlString = "https://iplay.sa.gov.tw/odata/Gym(\(gymId))?$format=application/json;odata.metadata=none&$expand=GymFuncData"
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    let content = String(data: data, encoding: .utf8) ?? ""
                    print(content)
                    do {
                        //decode searching response to defined structure by decoder
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601
                        let gymDetail = try decoder.decode(GymDetail.self, from: data)
                        print(gymDetail)
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
}
