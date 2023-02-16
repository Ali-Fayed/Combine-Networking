//
//  ErrorCode.swift
//  Combine Networking
//
//  Created by Ali Fixed on 16/02/2023.
//
import Foundation
enum ErrorCode: String, Codable {
    case noConnetion
    case general
    case serverError
}
extension ErrorCode {
    var errorDescription: String? {
        switch self {
        case .noConnetion:
            return "Check your internet connection."
        case .serverError:
            return "Server is unavailable."
        default:
            return "Error occured while accessing the service. Please try again later."
        }
    }
}
