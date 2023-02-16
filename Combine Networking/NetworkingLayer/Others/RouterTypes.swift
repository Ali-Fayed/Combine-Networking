//
//  RouterTypes.swift
//  MVVM-Clean
//
//  Created by Ali Fayed on 15/02/2023.
//

import Foundation
typealias HttpHeaders = [String: String]
typealias HttpParameters = [String: String]
enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case options = "OPTIONS"
}
