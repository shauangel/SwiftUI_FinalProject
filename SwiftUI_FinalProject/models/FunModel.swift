//
//  FunModel.swift
//  SwiftUI_FinalProject
//
//  Created by 邵安祺 on 2022/1/19.
//

import Foundation


struct FunModel: Codable {
    var author: String
    var nsfw: Bool
    var postLink: String
    var preview: [String]
    var spoiler: Bool
    var subreddit: String
    var title: String
    var ups: Int
    var url: String
    
    init(){
        self.author = ""
        self.nsfw = false
        self.postLink = ""
        self.preview = []
        self.spoiler = false
        self.subreddit = ""
        self.title = ""
        self.ups = 0
        self.url = ""
    }
}
