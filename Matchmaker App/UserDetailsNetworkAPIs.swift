//
//  UserDetailsNetworkAPIs.swift
//  Matchmaker App
//
//  Created by Arav Khandelwal on 25/07/24.
//

import Combine
import Foundation

class UserDetailsNetworkAPIs {
    private static var cancellables = Set<AnyCancellable>()
    
    /// This function is used to call the user list API to be shown on the screen
    /// - Parameter completion: colosure to return the response or error
    class func sendGetUserListRequest(completion: @escaping (
        _ apiResponse: UsersResponse?,
        _ apiError: CustomError?
    ) -> ()) {
        let urlString = "https://randomuser.me/api/?results=10"
        
        guard let request = NetworkRequest.shared.createRequest(url: urlString, method: .GET) else {
            print("error while creating request")
            completion(nil, nil)
            return
        }
        
        NetworkService.shared.makeRequest(request: request)
            .tryMap { data -> UsersResponse in
                do {
                    return try JSONDecoder().decode(UsersResponse.self, from: data)
                } catch {
                    print("Decoding usersResponse failure")
                    throw CustomError.customizedError("Something went wrong")
                }
            }
            .mapError { error in
                if let customError = error as? CustomError {
                    return customError
                } else {
                    return CustomError.defaultError(error)
                }
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completionStatus in
                switch completionStatus {
                case .finished:
                    break
                case .failure(let error):
                    completion(nil, error)
                }
            }, receiveValue: { apiResponse in
                completion(apiResponse, nil)
            })
            .store(in: &cancellables)
    }
}


