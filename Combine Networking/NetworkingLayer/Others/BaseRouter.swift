//
//  BaseRouter.swift
//  Combine Networking
//
//  Created by Ali Fayed on 15/02/2023.
//
import Foundation
protocol BaseRouter {
    var baseURL: String {get}
    var scheme: String {get}
    var path: String {get}
    var method: HttpMethod { get }
    var headers: HttpHeaders? { get }
    var parameter: HttpParameters? { get}
}

extension BaseRouter {
    var scheme: String {
        return "https"
    }
    var baseURL: String {
        return "api.github.com"
    }
    var headers: HttpHeaders? {
        return ["Accept": "application/json"]
    }
}
