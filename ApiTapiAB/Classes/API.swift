//
//  API.swift
//  ApiTapiAB
//
//  Created by Appbooster on 02/09/2019.
//  Copyright © 2019 Appbooster. All rights reserved.
//

import Foundation

struct API {

  static let modifier: String = "api"
  static let versionModifier: String = "v"
  static let version: Int = 1
  static let path: String = "experiments"

  static func get(_ url: URL,
                  headers: [String: String]?,
                  timeoutInterval: TimeInterval,
                  completion: @escaping (Data?, ApiTapiABError?) -> Void) {
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "GET"
    urlRequest.allHTTPHeaderFields = headers
    urlRequest.timeoutInterval = timeoutInterval

    URLSession.shared.dataTask(with: urlRequest) { data, response, error in
      if let error = error {
        DispatchQueue.main.async {
          let abError = ApiTapiABError(error: "URL error: \(error.localizedDescription)",
            code: (error as? URLError)?.errorCode ?? 0)
          completion(nil, abError)
        }

        return
      }

      guard let response = response as? HTTPURLResponse else {
        DispatchQueue.main.async {
          let abError = ApiTapiABError(error: "Invalid response from server",
                                       code: 0)
          completion(nil, abError)
        }

        return
      }

      guard 200 ... 299 ~= response.statusCode else {
        DispatchQueue.main.async {
          let abError = ApiTapiABError(error: "Server error",
                                       code: response.statusCode)
          completion(nil, abError)
        }

        return
      }

      guard let data = data else {
        DispatchQueue.main.async {
          let abError = ApiTapiABError(error: "Invalid response data",
                                       code: 0)
          completion(nil, abError)
        }

        return
      }

      DispatchQueue.main.async {
        completion(data, nil)
      }
      }.resume()
  }

}
