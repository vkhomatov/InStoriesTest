//
//  NetworkService.swift
//  InStoriesTestAll
//
//  Created by Vitaly Khomatov on 02.04.2021.
//

import Foundation

class NetworkService {
    
    static let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 20
        config.timeoutIntervalForResource = 100
        let session = URLSession(configuration: config)
        return session
    }()
    
    var urlConstructor: URLComponents = {
        var constructor = URLComponents()
        constructor.scheme = "https"
        constructor.host = "api.unsplash.com"
        return constructor
    }()
    
    func getRandomPhotos(value: Int, completion: @escaping (Swift.Result<[Photo], Error>?, String?) -> Void)  {
        urlConstructor.path = "/photos/random"
        urlConstructor.queryItems = [
            URLQueryItem(name: "client_id", value: "_HARuovjR1l6UWb2FlKYZZPeM8KNsJYZgaLt4Ec1Na8"),
            URLQueryItem(name: "count", value: String(value))
        ]
        
        if let url = urlConstructor.url {
            NetworkService.session.dataTask(with: URLRequest(url: url)) { (data, response, error) in
                if let data = data {
                    do {
                        let photos = try JSONDecoder().decode([Photo].self, from: data)
                        completion(.success(photos), nil)
                    } catch {
                        print("JSON decode failed: \(error.localizedDescription)")
                    }
                } else if let error = error  {
                    completion(.failure(error), nil)
                } else if let httpResponse = response as? HTTPURLResponse {
                    let code = String(httpResponse.statusCode).first
                    if code == "5" || code == "4" {
                        completion(nil, httpResponse.statusCode.description)
                    }
                }
            }.resume()
        } else {
            print("Неверный формат URL")
        }
    }
}


//                    do {
//                        let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [Any]
//                        print("JSON  = \(String(describing: json))")
//                    } catch  {
//                        print("JSON get failed: \(error.localizedDescription)")
//                    }

