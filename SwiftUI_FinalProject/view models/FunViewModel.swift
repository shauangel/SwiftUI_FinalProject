//
//  FunViewModel.swift
//  SwiftUI_FinalProject
//
//  Created by 邵安祺 on 2022/1/19.
//

import Foundation


class FunViewModel: ObservableObject {
    @Published var funMeme = FunModel()
    
    
    func fetchMeme() -> Bool {
        let urlString = urlEncoder(url: "https://meme-api.herokuapp.com/gimme")
        var check: Bool = false
        //make request
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        //decode searching response to defined structure by decoder
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601
                        let newMeme = try decoder.decode(FunModel.self, from: data)
                        
                        //switch to main thread
                        DispatchQueue.main.async {
                            self.funMeme = newMeme
                            print(self.funMeme)
                            check = true
                        }
                    } catch {
                        check = false
                        print(error)
                    }
                }
            }.resume()
        }
        return check
    }
}



