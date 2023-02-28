//
//  RequestBuilder.swift
//  Combine Networking
//
//  Created by Ali Fayed on 15/02/2023.
//
import Foundation
extension BaseRouter {
    func asURLRequest(shouldCache: Bool) -> URLRequest {
        var component: URLComponents = URLComponents()
        component.scheme = self.scheme
        component.host = self.baseURL
        component.path = self.path
        if let parameter = self.parameter {
            parameter.forEach {
                if component.queryItems == nil {
                    component.queryItems = []
                }
                component.queryItems?.append(URLQueryItem(name: $0.key, value: $0.value))
            }
        }
        let url = component.url!
        var urlRequest = URLRequest(url: url, cachePolicy: shouldCache ? .useProtocolCachePolicy : .reloadIgnoringLocalCacheData)
        urlRequest.httpMethod = self.method.rawValue
        if self.method == .post {
            confiqureBody(body: self.parameter, request: &urlRequest)
        }
        configureHeaders(headers: self.headers, request: &urlRequest)
        return urlRequest
   }
    func confiqureBody(body: [String: Any]?, request: inout URLRequest) {
       guard let bodyDic = body else {
           return
       }
       guard let httpBody = try? JSONSerialization.data(withJSONObject: bodyDic, options: []) else {
           return
       }
       request.httpBody = httpBody
   }
   func configureHeaders(headers: [String: String]?, request: inout URLRequest) {
       headers?.forEach {
           request.setValue($0.value, forHTTPHeaderField: $0.key)
       }
   }
}
