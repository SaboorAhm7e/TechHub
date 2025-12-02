//
//  NetworkError.swift
//  TechHub
//
//  Created by saboor on 23/11/2025.
//

import Foundation

//enum NetworkError : Error {
//    case networkError,invalidURL,serverError,decodingError
//}
enum NetworkError : Error {
    case invalidURL
    case serverError
    case decodingError
    case networkError(error:String)
    
    var message : String  {
        switch self {
        case .invalidURL:
            return "Invalid URL passed"
        case .serverError:
            return "Bad Server Request"
        case .decodingError:
            return "Failed to Decode/Encode data"
        case .networkError(let error):
            return error
        }
    }

}

