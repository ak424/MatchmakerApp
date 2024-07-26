//
//  NetworkService.swift
//  Matchmaker App
//
//  Created by Arav Khandelwal on 26/07/24.
//

import Combine
import Reachability

class NetworkService {
    
    ///Singleton pattern
    static let shared = NetworkService()
    private init() {}

    private let task = URLSession.shared
    
    
    /// This function is used make network request
    /// - Parameter request: URLRequest to be stnt
    /// - Returns: Publisher to return data or error
    func makeRequest(request: URLRequest) -> AnyPublisher<Data, CustomError> {
        do {
            let reachability = try Reachability()
            if reachability.connection != .unavailable {
                return URLSession.shared.dataTaskPublisher(for: request)
                    .tryMap { output in
                        guard let httpResponse = output.response as? HTTPURLResponse,
                              200...204 ~= httpResponse.statusCode else {
                            throw CustomError.statusCode((output.response as? HTTPURLResponse)?.statusCode ?? 500, output.data)
                        }
                        return output.data
                    }
                    .mapError { error in
                        if let urlError = error as? URLError {
                            return urlError.getCustomError
                        } else if let customError = error as? CustomError {
                            return customError
                        } else {
                            return CustomError.defaultError(error)
                        }
                    }
                    .eraseToAnyPublisher()
            } else {
                return Fail(error: CustomError.networkReachabilityError)
                    .eraseToAnyPublisher()
            }
        } catch let error {
            return Fail(error: CustomError.defaultError(error))
                .eraseToAnyPublisher()
        }
    }
}

extension Error {
    var getCustomError: CustomError {
        let finalError: CustomError
        if let urlError = self as? URLError, urlError.code == .timedOut {
            finalError = CustomError.timedOutError
        }
        else {
            finalError = CustomError.defaultError(self)
        }
        return finalError
    }
}

