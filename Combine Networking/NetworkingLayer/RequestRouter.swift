//
//  Router.swift
//  Combine Networking
//
//  Created by Ali Fayed on 15/02/2023.
//
import Foundation
enum RequestRouter: BaseRouter {
    case users
    //MARK: - URL
    var baseURL: String {
        switch self {
        case .users:
            return "api.github.com"
        }
    }
    //MARK: - Path
    var path: String {
        switch self {
        case .users:
            return "/users"
        }
    }
    //MARK: - HTTPMethod
    var method: HttpMethod {
        switch self {
        case .users:
            return .get
        }
    }
    //MARK: - Parameters or Body
    var parameter: HttpParameters? {
        switch self {
        case .users:
            return ["per_page": "1"]
        }
    }
}
