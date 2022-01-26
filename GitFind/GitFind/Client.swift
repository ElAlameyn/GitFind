//
//  Client.swift
//  GitFind
//
//  Created by Артем Калинкин on 29.09.2021.
//


import Combine
import Foundation
import CoreText

enum clientError: Error {
  case parseError
  case urlError
}
struct Client {
  let perPage = 20

  enum Const {
    static let baseURL = "https://api.github.com/search/repositories?"
  }
  
  func fetchRepositories(query: String, page:Int, completionHandler: @escaping (Result<Repositories, Error>) -> Void) {
    guard let url = URL(string: Const.baseURL + "q=\(query)" + "&per_page=\(perPage)" + "&page=\(page)") else { return }
    let request = URLRequest(url: url)
    URLSession.shared.dataTask(with: request) { data, response, error in
      if let error = error{
        completionHandler(.failure(error))
      } else {
        do {
          guard let data = data else { return }
          if let repositories: Repositories = try parse(json: data) {
            completionHandler(.success(repositories))
            print(url)
          }
        } catch {
          completionHandler(.failure(error))
        }
      }
    }.resume()
  }
  
  func fetch(query: String, page: Int) -> AnyPublisher<Repositories, Error> {
     let url = URL(string: Const.baseURL + "q=\(query)" + "&per_page=\(perPage)" + "&page=\(page)")!
    let request = URLRequest(url: url)
    return URLSession.shared.dataTaskPublisher(for: request)
      .map({$0.data})
      .decode(type: Repositories.self, decoder: JSONDecoder())
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }

  private func parse<T:Decodable>(json: Data) throws -> T{
    return try JSONDecoder().decode(T.self, from: json)
  }
}
