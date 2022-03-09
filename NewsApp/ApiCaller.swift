//
//  ApiCaller.swift
//  NewsApp
//
//  Created by Mücahit Eren Özkur on 9.03.2022.
//

import Foundation

final class ApiCaller {
    static let shared = ApiCaller()
    
    struct Constants {
        static let topHeadLinesURL = URL(string: "https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=14d7d70dc8de47dc91254c151413fa83")
    }
    
    private init() {}
    
    public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = Constants.topHeadLinesURL else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(ApiResponse.self, from: data)
                    print(result.articles.count)
                    completion(.success(result.articles))
                } catch  {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

//Models

struct ApiResponse: Codable {
    let articles: [Article]
    
}


struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable {
    let name: String
}
