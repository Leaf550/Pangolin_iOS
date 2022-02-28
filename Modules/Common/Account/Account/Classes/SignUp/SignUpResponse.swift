//
//  SignUpResponse.swift
//  Account
//
//  Created by 方昱恒 on 2022/2/28.
//

//   let signUpResponse = try? newJSONDecoder().decode(SignUpResponse.self, from: jsonData)

import Foundation

// MARK: - SignUpResponse
struct SignUpResponse: Codable {
    var status: Int?
    var data: SignUpData?
    var message: String?
}

// MARK: - SignUpData
struct SignUpData: Codable {
    var tokenString: String?
}

enum SignUpStatusCode: Int {
    case userExisted    = 601
}
