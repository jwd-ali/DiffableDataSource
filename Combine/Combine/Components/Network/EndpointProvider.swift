//
//  EndpointProvider.swift
//  BirthdayApp
//

import Foundation

public enum HttpMethodType: String {
    case get
}

public protocol RequestConvertible {
    var path: String { get }
    var httpMethodType: HttpMethodType { get }
    var urlRequest: URLRequest? { get }
}

struct EndPointProvider: RequestConvertible {
    var path: String
    var httpMethodType: HttpMethodType

    var url: URL? {
        URL(string: path)
    }

    var urlRequest: URLRequest? {
        guard let url = url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethodType.rawValue
        return request
    }

    init(with path: String, httpMethodType: HttpMethodType = .get) {
        self.path = path
        self.httpMethodType = httpMethodType
    }
}
