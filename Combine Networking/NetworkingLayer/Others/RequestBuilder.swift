//
//  RequestBuilder.swift
//  MVVM-Clean
//
//  Created by Ali Fayed on 15/02/2023.
//

import Foundation
class RequestBuilder {
     private init() {}
     static let shared = RequestBuilder()
     func buildRequest(_ router: BaseRouter, shouldCache: Bool) -> URLRequest {
         var component: URLComponents = URLComponents()
         component.host = router.baseURL
         component.scheme = router.scheme
         component.path = router.path
         if let parameter = router.parameter {
             parameter.forEach {
                 if component.queryItems == nil {
                     component.queryItems = []
                 }
                 component.queryItems?.append(URLQueryItem(name: $0.key, value: $0.value))
             }
         }
         var urlRequest = URLRequest(url: component.url!, cachePolicy: shouldCache ? .useProtocolCachePolicy : .reloadIgnoringLocalCacheData)
         urlRequest.httpMethod = router.method.rawValue
         if router.method == .post {
             confiqureBody(body: router.parameter, request: &urlRequest)
         }
         configureHeaders(headers: router.headers, request: &urlRequest)
         return urlRequest
    }
     private func confiqureBody(body: [String: Any]?, request: inout URLRequest) {
        guard let bodyDic = body else {
            return
        }
        guard let httpBody = try? JSONSerialization.data(withJSONObject: bodyDic, options: []) else {
            return
        }
        request.httpBody = httpBody
    }
    private func configureHeaders(headers: [String: String]?, request: inout URLRequest) {
        headers?.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }
    }
}
