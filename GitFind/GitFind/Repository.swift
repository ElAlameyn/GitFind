//
//  Repository.swift
//  GitFind
//
//  Created by Артем Калинкин on 26.09.2021.
//

import Foundation


struct Repositories: Codable {
  let repositories: [Repository]
  
  enum CodingKeys: String, CodingKey {
    case repositories = "items"
  }
}

struct Repository: Codable {
  let name: String
  let starsCount: Int
  
  enum CodingKeys: String, CodingKey {
    case name = "full_name"
    case starsCount = "stargazers_count"
  }
}
