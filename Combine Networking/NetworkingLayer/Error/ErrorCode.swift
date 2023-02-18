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
    case decodingError
    case emptyResponse
}
extension ErrorCode {
    var errorDescription: String? {
        switch self {
        case .noConnetion:
            return "Check your internet connection."
        case .serverError:
            return "Server is unavailable."
        case .emptyResponse:
            return "Response is empty."
        case .decodingError:
            return "Decoding error."
        default:
            return "Error occured while accessing the service. Please try again later."
        }
    }
}
