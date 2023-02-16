//
//  ErrorModel.swift
//  Combine Networking
//
//  Created by Ali Fayed on 15/02/2023.
//
struct APIError: Error, Equatable, Codable {
    var message: String?
    var code: ErrorCode?
    var statusCode: Int?
    
    init(_ code: ErrorCode?) {
        self.code = code
    }
    init(_ message: String) {
        self.message = message
    }
    enum CodingKeys: String, CodingKey {
        case message
        case code
        case statusCode
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try? values.decode(String.self, forKey: .message)
        code = try? values.decode(ErrorCode.self, forKey: .code)
        statusCode = try? values.decode(Int.self, forKey: .statusCode)
    }
}
