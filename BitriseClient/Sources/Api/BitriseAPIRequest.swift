//
//  BitriseAPIRequest.swift
//  BitriseClient
//
//  Created by Toshihiro Suzuki on 2018/02/11.
//

import APIKit
import Foundation

protocol BitriseAPIRequest: Request { }

extension BitriseAPIRequest where Response: Decodable {
    var baseURL: URL {
        return URL(string: "https://api.bitrise.io/v0.1")!
    }

    var method: HTTPMethod {
        return .get
    }

    var headerFields: [String : String] {
        var fields: [String: String] = [:]

        if let token = Config.personalAccessToken {
            fields["Authorization"] = "token \(token)"
        }

        return fields
    }

    func intercept(urlRequest: URLRequest) throws -> URLRequest {
        #if DEBUG
            print(urlRequest)
            if let headers = urlRequest.allHTTPHeaderFields {
                print(headers)
            }
        #endif
        return urlRequest
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        if let str = object as? String, let data = str.data(using: .utf8) {
            return try JSONDecoder().decode(Response.self, from: data)
        }

        throw ResponseError.unexpectedObject(object)
    }
}